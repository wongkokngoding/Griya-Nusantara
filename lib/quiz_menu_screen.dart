import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_colors.dart';
import 'quiz_confirmation_screen.dart';
import 'utils/responsive_helper.dart';

class QuizMenuScreen extends StatelessWidget {
  const QuizMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    // List region bisa disesuaikan dengan yang ada di database atau hardcode populer
    final List<Map<String, dynamic>> quizCategories = [
      {
        'title': 'Acak (Nusantara)',
        'region': 'Random',
        'icon': Icons.public,
        'color': Colors.blueGrey,
        'desc':
            'Uji pemahamanmu secara menyeluruh tentang arsitektur di seluruh Indonesia.',
      },
      {
        'title': 'Sumatera',
        'region': 'Sumatera',
        'icon': Icons.map,
        'color': Colors.green[700],
        'desc':
            'Fokus pada rumah gadang, krong bade, dan arsitektur Sumatera lainnya.',
      },
      {
        'title': 'Jawa',
        'region': 'Jawa',
        'icon': Icons.account_balance,
        'color': Colors.brown[600],
        'desc': 'Pelajari keanggunan Joglo, limasan, dan rumah adat Jawa.',
      },
      {
        'title': 'Kalimantan',
        'region': 'Kalimantan',
        'icon': Icons.park,
        'color': Colors.teal[700],
        'desc': 'Menjelajahi kearifan rumah Betang dan rumah panggung lainnya.',
      },
      {
        'title': 'Sulawesi',
        'region': 'Sulawesi',
        'icon': Icons.sailing,
        'color': Colors.indigo[600],
        'desc': 'Uji pengetahuanmu tentang Tongkonan dan pesona Sulawesi.',
      },
      {
        'title': 'Papua',
        'region': 'Papua',
        'icon': Icons.landscape,
        'color': Colors.orange[800],
        'desc': 'Temukan keunikan Honai dan arsitektur alam Papua.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing:
            24.sw, // Memberikan jarak agar sejajar dengan padding body (24.0)
        title: Text(
          'Pilih Kuis',
          style: GoogleFonts.lora(
            fontSize: 24.sf,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 24.sw,
            right: 24.sw,
            bottom: 24.sh,
            top: 8.sh,
          ),
          itemCount:
              quizCategories.length + 1, // +1 untuk kartu skor di bagian atas
          itemBuilder: (context, index) {
            // Jika index 0, tampilkan Kartu Skor
            if (index == 0) {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return const SizedBox.shrink();

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users_score')
                    .where('userId', isEqualTo: user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  int totalScore = 0;
                  if (snapshot.hasData) {
                    for (var doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      totalScore += (data['score'] ?? 0) as int;
                    }
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: 24.sh),
                    padding: EdgeInsets.all(20.sw),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.sw),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.stars_rounded,
                            color: Colors.white,
                            size: 36.sw,
                          ),
                        ),
                        SizedBox(width: 16.sw),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Poin Kuis',
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14.sf,
                                ),
                              ),
                              Text(
                                '$totalScore Poin',
                                style: GoogleFonts.lora(
                                  color: Colors.white,
                                  fontSize: 28.sf,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            // Untuk index lainnya, tampilkan list kategori (dikurangi 1 karena index 0 dipakai skor)
            final category = quizCategories[index - 1];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.sh),
              child: InkWell(
                onTap: () {
                  _showQuizSelectionConfirmation(context, category);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(16.sw),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60.sw,
                        height: 60.sw,
                        decoration: BoxDecoration(
                          color: (category['color'] as Color).withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category['icon'],
                          color: category['color'],
                          size: 30.sw,
                        ),
                      ),
                      SizedBox(width: 16.sw),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 16.sf,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            SizedBox(height: 6.sh),
                            Text(
                              category['desc'],
                              style: GoogleFonts.poppins(
                                fontSize: 13.sf,
                                color: AppColors.greyText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.sw),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.greyText.withValues(alpha: 0.5),
                        size: 32.sw,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showQuizSelectionConfirmation(
    BuildContext context,
    Map<String, dynamic> category,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        ResponsiveHelper.init(context);
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: 24.sw,
            vertical: 24.sh,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            padding: EdgeInsets.all(20.sw),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.sw),
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withValues(
                          alpha: 0.12,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        category['icon'],
                        color: category['color'] as Color,
                        size: 28.sw,
                      ),
                    ),
                    SizedBox(width: 12.sw),
                    Expanded(
                      child: Text(
                        'Konfirmasi Kuis',
                        style: GoogleFonts.lora(
                          fontSize: 20.sf,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                    IconButton(
                      splashRadius: 22.sw,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.secondaryText,
                    ),
                  ],
                ),
                SizedBox(height: 16.sh),
                Container(
                  padding: EdgeInsets.all(18.sw),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        category['title'],
                        style: GoogleFonts.lora(
                          fontSize: 18.sf,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      SizedBox(height: 8.sh),
                      Text(
                        category['desc'],
                        style: GoogleFonts.poppins(
                          fontSize: 14.sf,
                          color: AppColors.greyText,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 12.sh),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 16.sw,
                            color: AppColors.greyText,
                          ),
                          SizedBox(width: 6.sw),
                          Text(
                            category['region'],
                            style: GoogleFonts.manrope(
                              fontSize: 13.sf,
                              color: AppColors.secondaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.sh),
                Text(
                  'Yakin ingin mulai kuis ini sekarang?',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sf,
                    color: AppColors.greyText,
                  ),
                ),
                SizedBox(height: 24.sh),
                SizedBox(
                  width: double.infinity,
                  height: 52.sh,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizConfirmationScreen(
                            title: category['title'],
                            region: category['region'],
                            description: category['desc'],
                            icon: category['icon'],
                            color: category['color'] as Color,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Mulai Kuis',
                      style: GoogleFonts.manrope(
                        fontSize: 16.sf,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.sh),
                SizedBox(
                  width: double.infinity,
                  height: 52.sh,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Kembali',
                      style: GoogleFonts.manrope(
                        fontSize: 15.sf,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
