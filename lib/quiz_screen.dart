import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'models/quiz_question.dart';
import 'app_colors.dart';
import 'utils/badge_utils.dart';
import 'utils/responsive_helper.dart';
import 'data/dummy_quiz_questions.dart';

class QuizScreen extends StatefulWidget {
  final String? region;

  const QuizScreen({super.key, this.region});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int totalScore = 0;
  int correctAnswersCount = 0;
  int? selectedAnswerIndex;

  /// Status apakah soal sudah dijawab pada percobaan ini
  bool isAnswered = false;

  /// Apakah jawaban yang dipilih benar
  bool isCorrect = false;

  List<QuizQuestion> questions = [];
  bool isLoading = true;

  late AnimationController _questionAnimController;
  late Animation<double> _questionFadeAnim;
  late Animation<Offset> _questionSlideAnim;

  @override
  void initState() {
    super.initState();
    _questionAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _questionFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _questionAnimController, curve: Curves.easeOut),
    );
    _questionSlideAnim =
        Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _questionAnimController,
            curve: Curves.easeOut,
          ),
        );
    _fetchQuestions();
  }

  @override
  void dispose() {
    _questionAnimController.dispose();
    super.dispose();
  }

  void _playQuestionAnim() {
    _questionAnimController.reset();
    _questionAnimController.forward();
  }

  Future<void> _fetchQuestions() async {
    try {
      Query query = FirebaseFirestore.instance.collection('kuis_soal');

      if (widget.region != null && widget.region != 'Random') {
        query = query.where('region', isEqualTo: widget.region);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        var fetchedQuestions = snapshot.docs
            .map(
              (doc) => QuizQuestion.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList();

        fetchedQuestions.shuffle();

        if (fetchedQuestions.length > 10) {
          fetchedQuestions = fetchedQuestions.sublist(0, 10);
        }

        if (!mounted) return;
        setState(() {
          questions = fetchedQuestions;
          isLoading = false;
        });
        _playQuestionAnim();
      } else {
        _loadDummyData();
      }
    } catch (e) {
      debugPrint("Error fetching questions: $e");
      _loadDummyData();
    }
  }

  void _loadDummyData() {
    var dummyQuestions = List<QuizQuestion>.from(kDummyQuizQuestions);

    if (widget.region != null && widget.region != 'Random') {
      dummyQuestions = dummyQuestions
          .where((q) => q.region == widget.region)
          .toList();
    }

    dummyQuestions.shuffle();
    if (dummyQuestions.length > 10) {
      dummyQuestions = dummyQuestions.sublist(0, 10);
    }

    if (!mounted) return;
    setState(() {
      questions = dummyQuestions;
      isLoading = false;
    });
    _playQuestionAnim();
  }

  Future<Map<String, dynamic>> _updateUserGamificationData(
    int sessionScore,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'xp': 0, 'level': 1, 'awardedBadges': <String>[]};

    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    try {
      return await FirebaseFirestore.instance.runTransaction((
        transaction,
      ) async {
        final snapshot = await transaction.get(userDocRef);
        final data = snapshot.exists
            ? snapshot.data() as Map<String, dynamic>
            : <String, dynamic>{};

        final int currentXp = (data['xp'] ?? 0) as int;
        final int currentLevel = (data['level'] ?? 1) as int;
        final int currentAttempts = (data['quizAttempts'] ?? 0) as int;
        final List<String> currentBadges = List<String>.from(
          data['badges'] ?? <String>[],
        );

        final int newXp = currentXp + sessionScore;
        final int newLevel = _calculateLevel(newXp);
        final Set<String> updatedBadges = currentBadges.toSet();
        final List<String> awardedBadges = [];

        if (currentAttempts == 0) {
          updatedBadges.add('First Quiz');
          awardedBadges.add('First Quiz');
        }
        if (sessionScore == 100) {
          updatedBadges.add('Perfect Score');
          awardedBadges.add('Perfect Score');
        } else if (sessionScore >= 70) {
          updatedBadges.add('Cultural Hero');
          awardedBadges.add('Cultural Hero');
        }
        if (widget.region != null &&
            widget.region != 'Random' &&
            sessionScore == 100) {
          final regionBadge = 'Master ${widget.region}';
          if (updatedBadges.add(regionBadge)) {
            awardedBadges.add(regionBadge);
          }
        }
        if (widget.region != null &&
            widget.region != 'Random' &&
            sessionScore >= 40) {
          final regionExplorerBadge = 'Explorer ${widget.region}';
          if (updatedBadges.add(regionExplorerBadge)) {
            awardedBadges.add(regionExplorerBadge);
          }
        }
        if (newLevel > currentLevel) {
          final levelBadge = 'Level $newLevel Achieved';
          if (updatedBadges.add(levelBadge)) {
            awardedBadges.add(levelBadge);
          }
        }

        transaction.set(userDocRef, {
          'xp': newXp,
          'level': newLevel,
          'quizAttempts': currentAttempts + 1,
          'lastScore': sessionScore,
          'lastQuizAt': FieldValue.serverTimestamp(),
          'badges': updatedBadges.toList(),
        }, SetOptions(merge: true));

        return {'xp': newXp, 'level': newLevel, 'awardedBadges': awardedBadges};
      });
    } catch (e) {
      debugPrint('Error updating gamification data: $e');
      return {'xp': 0, 'level': 1, 'awardedBadges': <String>[]};
    }
  }

  int _calculateLevel(int xp) {
    if (xp < 200) return 1;
    if (xp < 500) return 2;
    if (xp < 900) return 3;
    if (xp < 1500) return 4;
    return 5;
  }

  String _levelTitle(int level) {
    switch (level) {
      case 1:
        return 'Penjelajah Budaya';
      case 2:
        return 'Pakar Daerah';
      case 3:
        return 'Nusantara Explorer';
      case 4:
        return 'Ahli Tradisi';
      case 5:
        return 'Guru Warisan';
      default:
        return 'Penjelajah Budaya';
    }
  }

  void _onAnswerSelected(int index) {
    if (isAnswered) return;

    final question = questions[currentQuestionIndex];
    final bool correct = index == question.correctAnswerIndex;

    setState(() {
      selectedAnswerIndex = index;
      isAnswered = true;
      isCorrect = correct;
    });

    if (correct) {
      correctAnswersCount++;
    }

    // Jeda 1.8 detik agar user melihat feedback, lalu lanjut
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;

      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedAnswerIndex = null;
          isAnswered = false;
          isCorrect = false;
        });
        _playQuestionAnim();
      } else {
        totalScore = (correctAnswersCount * 100 / questions.length).round();
        _submitScoreAndShowResult();
      }
    });
  }

  Future<void> _submitScoreAndShowResult() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users_score').add({
          'userId': user.uid,
          'score': totalScore,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint("Gagal menyimpan skor ke Firebase: $e");
    }

    final gamification = await _updateUserGamificationData(totalScore);
    final int finalLevel = gamification['level'] as int? ?? 1;
    final int finalXp = gamification['xp'] as int? ?? totalScore;
    final List<String> awardedBadges = List<String>.from(
      gamification['awardedBadges'] ?? <String>[],
    );

    if (!mounted) return;
    _showResultDialog(finalLevel, finalXp, awardedBadges);
  }

  // ============================================================
  // FEEDBACK WARNA
  // ✅ Benar  → pilihan yang diklik jadi HIJAU
  // ❌ Salah  → pilihan yang diklik jadi MERAH
  // ============================================================

  Color _getOptionBgColor(int index) {
    if (!isAnswered) return AppColors.white;
    if (index == selectedAnswerIndex) {
      return isCorrect ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
    }
    return AppColors.white;
  }

  Color _getOptionBorderColor(int index) {
    if (!isAnswered) return AppColors.border;
    if (index == selectedAnswerIndex) {
      return isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
    }
    return AppColors.border.withValues(alpha: 0.5);
  }

  Color _getOptionLabelColor(int index) {
    if (!isAnswered) return AppColors.primary;
    if (index == selectedAnswerIndex) {
      return isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    }
    return AppColors.greyText;
  }

  IconData? _getOptionIcon(int index) {
    if (!isAnswered || index != selectedAnswerIndex) return null;
    return isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 56.sw,
                height: 56.sw,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              SizedBox(height: 20.sh),
              Text(
                "Memuat soal kuis...",
                style: GoogleFonts.poppins(
                  fontSize: 15.sf,
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(40.sw),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 72.sw,
                  color: AppColors.greyText.withValues(alpha: 0.4),
                ),
                SizedBox(height: 20.sh),
                Text(
                  "Belum ada soal kuis yang tersedia.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sf,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ── HEADER ──
                _buildQuizHeader(),

                // ── CONTENT ──
                Expanded(
                  child: FadeTransition(
                    opacity: _questionFadeAnim,
                    child: SlideTransition(
                      position: _questionSlideAnim,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(20.sw, 8.sh, 20.sw, 32.sh),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Card Soal
                            _buildQuestionCard(question),

                            SizedBox(height: 20.sh),

                            // Pilihan Ganda
                            ...List.generate(question.options.length, (index) {
                              return _buildOptionTile(
                                index,
                                question.options[index],
                              );
                            }),

                            SizedBox(height: 16.sh),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Overlay feedback banner so it doesn't shift content
            Positioned(
              top: 110.sh,
              left: 5.sw,
              right: 5.sw,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, -0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          ),
                        ),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: isAnswered
                    ? _buildFeedbackBanner()
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── APP BAR ──
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      title: Text(
        "Kuis Nusantara",
        style: GoogleFonts.lora(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20.sf,
        ),
      ),
    );
  }

  // ── QUIZ HEADER ──
  Widget _buildQuizHeader() {
    final regionLabel = widget.region == null || widget.region == 'Random'
        ? 'Nusantara'
        : widget.region!;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF2D6A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(8.sw, 8.sh, 20.sw, 20.sh),
      child: Column(
        children: [
          // Top row: back button + title + score
          Row(
            children: [
              IconButton(
                onPressed: () => _showExitConfirmation(),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                splashRadius: 24,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kuis Arsitektur $regionLabel',
                      style: GoogleFonts.lora(
                        fontSize: 18.sf,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.sh),
                    Text(
                      'Pertanyaan ${currentQuestionIndex + 1} dari ${questions.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sf,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Score indicator
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.sw,
                  vertical: 8.sh,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.accent,
                      size: 18,
                    ),
                    SizedBox(width: 5.sw),
                    Text(
                      '$correctAnswersCount / ${questions.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sf,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.sh),

          // Step indicators
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.sw),
            child: Row(
              children: List.generate(questions.length, (i) {
                final bool isDone = i < currentQuestionIndex;
                final bool isCurrent = i == currentQuestionIndex;
                return Expanded(
                  child: Container(
                    height: 4.sh,
                    margin: EdgeInsets.symmetric(horizontal: 2.sw),
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.accent
                          : isCurrent
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── QUESTION CARD ──
  Widget _buildQuestionCard(QuizQuestion question) {
    return Container(
      padding: EdgeInsets.all(20.sw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge nomor soal
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.sw, vertical: 4.sh),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF2D6A4F)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Soal ${currentQuestionIndex + 1}',
              style: GoogleFonts.poppins(
                fontSize: 11.sf,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 14.sh),
          // Teks soal
          Text(
            question.questionText,
            style: GoogleFonts.poppins(
              fontSize: 16.sf,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── OPTION TILE ──
  Widget _buildOptionTile(int index, String optionText) {
    final icon = _getOptionIcon(index);
    final bool isSelected = isAnswered && index == selectedAnswerIndex;
    final String label = String.fromCharCode(65 + index); // A, B, C, D

    return Padding(
      padding: EdgeInsets.only(bottom: 12.sh),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : () => _onAnswerSelected(index),
          borderRadius: BorderRadius.circular(10),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 16.sh),
            decoration: BoxDecoration(
              color: _getOptionBgColor(index),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _getOptionBorderColor(index),
                width: isSelected ? 2 : 1.5,
              ),
              boxShadow: [
                if (!isAnswered)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                if (isSelected)
                  BoxShadow(
                    color:
                        (isCorrect
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFE53935))
                            .withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                // Label circle (A, B, C, D) atau ikon feedback
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 38.sw,
                  height: 38.sw,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isCorrect
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFE53935))
                        : AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? null
                        : Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                  ),
                  child: isSelected && icon != null
                      ? Icon(icon, color: Colors.white, size: 22.sw)
                      : Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: 15.sf,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : _getOptionLabelColor(index),
                          ),
                        ),
                ),
                SizedBox(width: 14.sw),
                // Option text
                Expanded(
                  child: Text(
                    optionText,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sf,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? (isCorrect
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFC62828))
                          : AppColors.secondaryText,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── FEEDBACK BANNER ──
  Widget _buildFeedbackBanner() {
    return Container(
      key: ValueKey('feedback_$currentQuestionIndex'),
      margin: EdgeInsets.fromLTRB(20.sw, 8.sh, 20.sw, 4.sh),
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 14.sh),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCorrect
              ? [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]
              : [const Color(0xFFFFEBEE), const Color(0xFFFFCDD2)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCorrect ? const Color(0xFF66BB6A) : const Color(0xFFEF5350),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color:
                (isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935))
                    .withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36.sw,
            height: 36.sw,
            decoration: BoxDecoration(
              color: isCorrect
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE53935),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCorrect ? Icons.check_rounded : Icons.close_rounded,
              color: Colors.white,
              size: 22.sw,
            ),
          ),
          SizedBox(width: 12.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCorrect ? 'Jawaban Benar!' : 'Jawaban Salah!',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sf,
                    fontWeight: FontWeight.w700,
                    color: isCorrect
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFC62828),
                  ),
                ),
                Text(
                  isCorrect
                      ? 'Hebat! Pengetahuan arsitekturmu luar biasa!'
                      : 'Jangan menyerah, terus belajar!',
                  style: GoogleFonts.poppins(
                    fontSize: 11.sf,
                    color: isCorrect
                        ? const Color(0xFF388E3C)
                        : const Color(0xFFD32F2F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── EXIT CONFIRMATION ──
  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          'Keluar dari Kuis?',
          style: GoogleFonts.lora(
            fontWeight: FontWeight.bold,
            fontSize: 18.sf,
            color: AppColors.secondaryText,
          ),
        ),
        content: Text(
          'Progress kuis kamu akan hilang jika keluar sekarang.',
          style: GoogleFonts.poppins(
            fontSize: 14.sf,
            color: AppColors.greyText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Lanjutkan',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14.sf,
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Keluar',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14.sf,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── RESULT DIALOG ──
  void _showResultDialog(int level, int xp, List<String> badges) {
    final double scorePercent = totalScore / 100;
    String message;
    IconData heroIcon;
    Color heroColor;

    if (totalScore == 100) {
      message = 'Sempurna! Kamu adalah ahli arsitektur Nusantara sejati!';
      heroIcon = Icons.emoji_events_rounded;
      heroColor = const Color(0xFFFFB300);
    } else if (totalScore >= 70) {
      message = 'Hebat! Pengetahuan arsitekturmu sangat baik!';
      heroIcon = Icons.military_tech_rounded;
      heroColor = const Color(0xFF66BB6A);
    } else if (totalScore >= 40) {
      message = 'Lumayan! Terus pelajari warisan arsitektur Nusantara.';
      heroIcon = Icons.school_rounded;
      heroColor = AppColors.primary;
    } else {
      message = 'Jangan menyerah! Pelajari lagi dan coba kembali.';
      heroIcon = Icons.auto_stories_rounded;
      heroColor = AppColors.greyText;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.sw, vertical: 40.sh),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header gradient
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(24.sw, 32.sh, 24.sw, 24.sh),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Color(0xFF2D6A4F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Kuis Selesai!',
                        style: GoogleFonts.lora(
                          fontSize: 22.sf,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.sh),
                      // Score circle
                      Container(
                        width: 120.sw,
                        height: 120.sw,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 3,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100.sw,
                              height: 100.sw,
                              child: CircularProgressIndicator(
                                value: scorePercent,
                                strokeWidth: 8,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.accent,
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$totalScore',
                                  style: GoogleFonts.poppins(
                                    fontSize: 36.sf,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  '/ 100',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sf,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.sh),
                      // Hero icon
                      Icon(heroIcon, size: 36.sw, color: heroColor),
                      SizedBox(height: 8.sh),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sf,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats area
                Padding(
                  padding: EdgeInsets.fromLTRB(24.sw, 20.sh, 24.sw, 8.sh),
                  child: Column(
                    children: [
                      // Level & XP row
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.trending_up_rounded,
                                label: 'Level',
                                value: '$level',
                                subtitle: _levelTitle(level),
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 12.sw),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.star_rounded,
                                label: 'Total XP',
                                value: '$xp',
                                subtitle: 'Exp',
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.sh),
                      // Correct answers
                      _buildStatCard(
                        icon: Icons.check_circle_rounded,
                        label: 'Jawaban Benar',
                        value: '$correctAnswersCount / ${questions.length}',
                        subtitle:
                            '${(correctAnswersCount * 100 / questions.length).round()}% akurasi',
                        color: const Color(0xFF4CAF50),
                        isWide: true,
                      ),
                    ],
                  ),
                ),

                // Badges
                if (badges.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.sw, 8.sh, 24.sw, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.workspace_premium_rounded,
                              color: AppColors.accent,
                              size: 20.sw,
                            ),
                            SizedBox(width: 6.sw),
                            Text(
                              'Badge Baru Diraih!',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sf,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sh),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8.sw,
                          runSpacing: 8.sh,
                          children: badges
                              .map(BadgeUtils.buildBadgeChip)
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.sw),
                    child: Text(
                      'Tetap semangat untuk meraih badge baru!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sf,
                        color: AppColors.greyText,
                      ),
                    ),
                  ),
                ],

                // Action buttons
                Padding(
                  padding: EdgeInsets.fromLTRB(24.sw, 20.sh, 24.sw, 24.sh),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.sh),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Kembali ke Beranda",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sf,
                          ),
                        ),
                      ),
                      if (totalScore < 100) ...[
                        SizedBox(height: 12.sh),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.sh),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            setState(() {
                              currentQuestionIndex = 0;
                              totalScore = 0;
                              correctAnswersCount = 0;
                              selectedAnswerIndex = null;
                              isAnswered = false;
                              isCorrect = false;
                            });
                            // Acak soal ulang saat coba lagi
                            questions.shuffle();
                            _playQuestionAnim();
                          },
                          child: Text(
                            "Coba Lagi",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 15.sf,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── STAT CARD (for result dialog) ──
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
    bool isWide = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 14.sh),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.sw,
            height: 40.sw,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22.sw),
          ),
          SizedBox(width: 12.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sf,
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 18.sf,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondaryText,
                    height: 1.2,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 10.sf,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
