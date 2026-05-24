import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_colors.dart';
import 'quiz_screen.dart';
import 'utils/responsive_helper.dart';

class HouseDetailScreen extends StatefulWidget {
  final String title;
  final String location;
  final String regionName;
  final String description;
  final String imageUrl;

  const HouseDetailScreen({
    super.key,
    required this.title,
    required this.location,
    required this.regionName,
    required this.description,
    required this.imageUrl,
  });

  @override
  State<HouseDetailScreen> createState() => _HouseDetailScreenState();
}

class _HouseDetailScreenState extends State<HouseDetailScreen> {
  bool isFavorite = false;
  List<String> funFacts = [];
  bool isFunFactsLoading = true;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    _loadFunFacts();
  }

  Future<void> _checkFavoriteStatus() async {
    if (_user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .collection('favorites')
          .doc(widget.title)
          .get();

      if (mounted) {
        setState(() {
          isFavorite = doc.exists;
        });
      }
    } catch (e) {
      debugPrint("Gagal memuat status favorit: $e");
    }
  }

  /// Memuat fakta menarik dari Firestore berdasarkan judul rumah adat.
  /// Struktur Firestore: koleksi 'houses', field 'funFacts' berupa `List<String>`
  Future<void> _loadFunFacts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('houses')
          .where('title', isEqualTo: widget.title)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final rawFacts = data['funFacts'];
        if (rawFacts != null && rawFacts is List) {
          if (mounted) {
            setState(() {
              funFacts = List<String>.from(rawFacts);
              isFunFactsLoading = false;
            });
            return;
          }
        }
      }
    } catch (e) {
      debugPrint("Gagal memuat fakta menarik: $e");
    }

    // Fallback: fakta default berdasarkan judul rumah
    if (mounted) {
      setState(() {
        funFacts = _getDefaultFunFacts(widget.title);
        isFunFactsLoading = false;
      });
    }
  }

  /// Fakta menarik fallback jika Firestore belum memiliki field 'funFacts'
  List<String> _getDefaultFunFacts(String title) {
    final Map<String, List<String>> facts = {
      'Rumah Gadang': [
        'Jumlah gonjong (tanduk atap) pada Rumah Gadang melambangkan jumlah suku di nagari tersebut.',
        'Seluruh ukiran di dinding Rumah Gadang terinspirasi dari alam — tidak ada ukiran berbentuk manusia atau hewan nyata.',
        'Rumah Gadang dimiliki secara turun-temurun oleh perempuan dalam sistem matrilineal Minangkabau.',
      ],
      'Rumah Bolon': [
        'Satu Rumah Bolon bisa dihuni oleh 5 hingga 6 keluarga besar sekaligus secara komunal.',
        'Tiang-tiangnya ditaruh di atas batu datar tanpa ditanam ke tanah — teknik tahan gempa alami nenek moyang.',
        'Warna merah, putih, dan hitam pada ukiran Bolon memiliki makna kosmologis suku Batak.',
      ],
      'Rumah Betang': [
        'Rumah Betang bisa mencapai panjang 150-300 meter dan menampung hingga 100 kepala keluarga!',
        'Tangga masuknya berupa sebatang pohon utuh yang dipahat — jika terbalik, menandakan kepala adat sedang berduka.',
        'Tidak ada sekat permanen antar ruang keluarga di dalam Rumah Betang sebagai simbol persatuan.',
      ],
      'Rumah Joglo Jawa Tengah': [
        'Soko guru (4 tiang utama) pada Rumah Joglo tidak pernah boleh diganti sembarangan karena dianggap memiliki jiwa.',
        'Tumpang sari, susunan balok bertingkat di atas soko guru, bisa terdiri hingga 10 lapisan kayu ukir.',
        'Pendopo Joglo dirancang tanpa dinding agar angin bisa bebas mengalir — sistem pendingin alami tropis.',
      ],
      'Rumah Tongkonan': [
        'Tanduk kerbau yang ditumpuk di tiang utama Tongkonan bisa mencapai puluhan pasang — menunjukkan berapa kali pesta adat (Rambu Solo) diadakan.',
        'Atap Tongkonan yang melengkung ke depan dan belakang terinspirasi dari bentuk perahu leluhur Austronesia.',
        'Rumah Tongkonan tidak bisa dijual — ia hanya boleh diwariskan dalam satu klan keluarga untuk selamanya.',
      ],
      'Rumah Honai': [
        'Bentuk bulat tanpa sudut pada Honai dirancang agar angin pegunungan Papua (yang bisa mencapai -10°C) tidak menabrak dinding secara langsung.',
        'Api unggun di dalam Honai tidak pernah boleh padam — asapnya dipercaya mengawetkan atap ilalang dan mengusir serangga.',
        'Laki-laki dan perempuan tidur di bangunan Honai yang terpisah sebagai bagian dari tradisi adat suku Dani.',
      ],
    };

    return facts[title] ??
        [
          'Rumah adat ini merupakan warisan budaya leluhur yang kaya makna filosofis.',
          'Setiap elemen arsitekturnya dirancang selaras dengan alam dan kepercayaan lokal.',
          'Teknik pembangunannya diwariskan secara lisan dari generasi ke generasi tanpa cetak biru.',
        ];
  }

  Future<void> _toggleFavorite() async {
    if (_user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu.')),
      );
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .collection('favorites')
        .doc(widget.title);

    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      if (isFavorite) {
        await docRef.set({
          'title': widget.title,
          'location': widget.location,
          'regionName': widget.regionName,
          'description': widget.description,
          'imageUrl': widget.imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Ditambahkan ke favorit! ❤️',
                style: GoogleFonts.poppins(),
              ),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        await docRef.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Dihapus dari favorit.',
                style: GoogleFonts.poppins(),
              ),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isFavorite = !isFavorite;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. Bagian Atas (Header & Hero Image)
              // ==========================================
              Padding(
                padding: EdgeInsets.all(16.sw),
                child: Stack(
                  children: [
                    Hero(
                      tag: widget.title,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.imageUrl,
                          width: double.infinity,
                          height: 320.sh,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 320.sh,
                                color: Colors.grey.shade300,
                                child: Icon(Icons.broken_image, size: 50.sw),
                              ),
                        ),
                      ),
                    ),

                    // Tombol Kembali
                    Positioned(
                      top: 16.sh,
                      left: 16.sw,
                      child: _buildCircleButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),

                    // Ikon Favorit
                    Positioned(
                      top: 16.sh,
                      right: 16.sw,
                      child: _buildCircleButton(
                        icon: isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        iconColor: isFavorite
                            ? Colors.redAccent
                            : AppColors.secondaryText,
                        onTap: _toggleFavorite,
                      ),
                    ),
                  ],
                ),
              ),

              // ==========================================
              // 2. Bagian Identitas (Informasi Singkat)
              // ==========================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.sw),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.lora(
                        fontSize: 24.sf,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryText,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 16.sh),

                    Wrap(
                      spacing: 8.sw,
                      runSpacing: 8.sh,
                      children: [
                        _buildChip(widget.location, Icons.location_on_rounded),
                        _buildChip(
                          'Pulau ${widget.regionName}',
                          Icons.explore_rounded,
                        ),
                      ],
                    ),

                    SizedBox(height: 32.sh),
                    const Divider(height: 1, thickness: 1),
                    SizedBox(height: 24.sh),

                    // ==========================================
                    // 3. Filosofi & Arsitektur
                    // ==========================================
                    Text(
                      'Filosofi & Arsitektur',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sf,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 12.sh),

                    Text(
                      widget.description,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sf,
                        height: 1.8,
                        color: AppColors.secondaryText.withValues(alpha: 0.85),
                      ),
                    ),

                    SizedBox(height: 32.sh),
                    const Divider(height: 1, thickness: 1),
                    SizedBox(height: 24.sh),

                    // ==========================================
                    // 4. Seksi Fakta Menarik (BARU)
                    // ==========================================
                    _buildFunFactsSection(),

                    SizedBox(height: 40.sh),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ==========================================
      // 5. Tombol Aksi (Tes Kuis per daerah)
      // ==========================================
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(24.sw, 16.sh, 24.sw, 24.sh),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(region: widget.regionName),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 16.sh),
              elevation: 4,
              shadowColor: AppColors.primary.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_rounded, color: Colors.white, size: 20.sw),
                SizedBox(width: 10.sw),
                Text(
                  widget.regionName.isNotEmpty
                      ? 'Tes Kuis ${widget.regionName}'
                      : 'Tes Kuis',
                  style: GoogleFonts.poppins(
                    fontSize: 15.sf,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Widget Seksi Fakta Menarik
  // ==========================================
  Widget _buildFunFactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.sw),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.accent,
                size: 18.sw,
              ),
            ),
            SizedBox(width: 10.sw),
            Text(
              'Fakta Menarik',
              style: GoogleFonts.poppins(
                fontSize: 16.sf,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.sh),

        if (isFunFactsLoading)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.sh),
              child: const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          )
        else if (funFacts.isEmpty)
          Text(
            'Belum ada fakta menarik tersedia.',
            style: GoogleFonts.poppins(
              fontSize: 13.sf,
              color: AppColors.greyText,
            ),
          )
        else
          ...funFacts.asMap().entries.map((entry) {
            final i = entry.key;
            final fact = entry.value;
            return _buildFactCard(fact, i);
          }),
      ],
    );
  }

  Widget _buildFactCard(String fact, int index) {
    final List<Color> cardColors = [
      const Color(0xFFFFF8E1),
      const Color(0xFFE8F5E9),
      const Color(0xFFE3F2FD),
    ];
    final List<Color> borderColors = [
      const Color(0xFFFFD54F),
      const Color(0xFF81C784),
      const Color(0xFF64B5F6),
    ];

    final color = cardColors[index % cardColors.length];
    final border = borderColors[index % borderColors.length];

    return Container(
      margin: EdgeInsets.only(bottom: 12.sh),
      padding: EdgeInsets.all(16.sw),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border.withValues(alpha: 0.6), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2.sh),
            width: 24.sw,
            height: 24.sw,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: border.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: GoogleFonts.poppins(
                fontSize: 12.sf,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          SizedBox(width: 12.sw),
          Expanded(
            child: Text(
              fact,
              style: GoogleFonts.poppins(
                fontSize: 13.sf,
                height: 1.7,
                color: AppColors.secondaryText.withValues(alpha: 0.88),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper tombol bulat
  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = AppColors.secondaryText,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.sw),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 22.sw, color: iconColor),
      ),
    );
  }

  // Helper chip badge
  Widget _buildChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sh),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sw, color: AppColors.primary),
          SizedBox(width: 6.sw),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11.sf,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
