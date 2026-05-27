import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_colors.dart';
import 'quiz_confirmation_screen.dart';
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
  HouseExtraContent? _firestoreExtraContent;

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

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'forest':
      case 'wood':
      case 'tree':
        return Icons.forest_rounded;
      case 'grass':
      case 'thatch':
      case 'straw':
        return Icons.grass_rounded;
      case 'eco':
      case 'bamboo':
      case 'leaf':
        return Icons.eco_rounded;
      case 'home':
      case 'roof':
        return Icons.home_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'build':
      case 'tool':
        return Icons.construction_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  /// Memuat fakta menarik dan data tambahan dari Firestore berdasarkan judul rumah adat.
  Future<void> _loadFunFacts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('houses')
          .where('title', isEqualTo: widget.title)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();

        // Load fun facts
        final rawFacts = data['funFacts'];
        List<String> loadedFacts = [];
        if (rawFacts != null && rawFacts is List) {
          loadedFacts = List<String>.from(rawFacts);
        } else {
          loadedFacts = _getDefaultFunFacts(widget.title);
        }

        // Load extra content
        HouseExtraContent? loadedExtra;
        final filosofi = data['filosofiAtap'];
        final fungsi = data['fungsiRuangan'];
        final rawMaterials = data['materials'];

        if (filosofi != null && fungsi != null && rawMaterials is List) {
          final List<MaterialDetail> materialsList = [];
          for (var item in rawMaterials) {
            if (item is Map) {
              materialsList.add(
                MaterialDetail(
                  name: item['name'] ?? '',
                  description: item['description'] ?? '',
                  icon: _getIconData(item['icon']),
                ),
              );
            }
          }
          loadedExtra = HouseExtraContent(
            filosofiAtap: filosofi,
            materials: materialsList,
            fungsiRuangan: fungsi,
          );
        }

        if (mounted) {
          setState(() {
            funFacts = loadedFacts;
            isFunFactsLoading = false;
            _firestoreExtraContent = loadedExtra;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint("Gagal memuat data dari Firestore: $e");
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

  HouseExtraContent _getExtraContent(String title, String location) {
    final Map<String, HouseExtraContent> extraContentMap = {
      'Rumah Gadang': const HouseExtraContent(
        filosofiAtap:
            'Garis atap yang melengkung dan menyapu, yang dikenal sebagai gonjong, dirancang menyerupai tanduk kerbau, hewan yang sangat dihormati dalam budaya Minangkabau. Selain itu, atap ini juga dikatakan mewakili bentuk haluan kapal, yang melambangkan warisan maritim nenek moyang mereka.',
        materials: [
          MaterialDetail(
            name: 'Kayu (Wood)',
            description:
                'Pilar struktural utama dan panel dinding terbuat dari kayu jati atau juar berkualitas tinggi.',
            icon: Icons.forest_rounded,
          ),
          MaterialDetail(
            name: 'Ijuk (Thatch)',
            description:
                'Material atap tradisional yang terbuat dari serat pohon aren, memberikan isolasi yang sangat baik.',
            icon: Icons.grass_rounded,
          ),
          MaterialDetail(
            name: 'Bambu (Bamboo)',
            description:
                'Digunakan untuk lantai dan bagian ikat struktural sekunder, menawarkan fleksibilitas.',
            icon: Icons.eco_rounded,
          ),
        ],
        fungsiRuangan:
            'Bagian dalamnya adalah aula utama yang terbuka dan tanpa sekat (lanjar) yang digunakan untuk tempat tinggal bersama, makan, dan upacara. Bagian belakang dibagi menjadi kamar-kamar kecil (bilik) yang diperuntukkan bagi anak perempuan yang sudah menikah, mencerminkan struktur masyarakat matrilineal Minangkabau.',
      ),
      'Rumah Bolon': const HouseExtraContent(
        filosofiAtap:
            'Bentuk atap Rumah Bolon melengkung menyerupai punggung kerbau atau bentuk perahu, melambangkan perjalanan hidup nenek moyang suku Batak serta perlindungan spiritual terhadap seluruh penghuni rumah.',
        materials: [
          MaterialDetail(
            name: 'Kayu (Wood)',
            description:
                'Kayu keras berkualitas tinggi yang digunakan untuk tiang-tiang penyangga (soko) tanpa ditanam di tanah.',
            icon: Icons.forest_rounded,
          ),
          MaterialDetail(
            name: 'Ijuk (Thatch)',
            description:
                'Atap dari serat ijuk yang diikat kencang pada kerangka kayu, memberikan ketahanan cuaca yang sangat baik.',
            icon: Icons.grass_rounded,
          ),
          MaterialDetail(
            name: 'Rotan (Rattan)',
            description:
                'Digunakan sebagai pengikat struktural tradisional pengganti paku besi.',
            icon: Icons.eco_rounded,
          ),
        ],
        fungsiRuangan:
            'Bagian dalam merupakan ruang terbuka besar (jabu) tanpa sekat permanen. Pembagian ruang ditentukan secara adat, seperti jabu bona untuk kepala keluarga di sudut kanan belakang, dan jabu suhat untuk anak tertua.',
      ),
      'Rumah Betang': const HouseExtraContent(
        filosofiAtap:
            'Atap tinggi melengkung memberikan sirkulasi udara optimal di daerah tropis basah serta melambangkan hubungan spiritual yang tinggi dengan para leluhur di langit.',
        materials: [
          MaterialDetail(
            name: 'Kayu Ulin (Ironwood)',
            description:
                'Kayu besi khas Kalimantan yang sangat kuat dan tahan air untuk tiang pancang setinggi 3-5 meter.',
            icon: Icons.forest_rounded,
          ),
          MaterialDetail(
            name: 'Bambu (Bamboo)',
            description:
                'Digunakan sebagai lantai (lanting) yang memberikan kelenturan dan kesejukan alami.',
            icon: Icons.eco_rounded,
          ),
          MaterialDetail(
            name: 'Daun Rumbia',
            description:
                'Atap berbahan daun rumbia atau sirap kayu ulin yang disusun rapi untuk melindungi dari hujan deras.',
            icon: Icons.grass_rounded,
          ),
        ],
        fungsiRuangan:
            'Terdiri dari bilik-bilik keluarga (sadang) di sepanjang bagian belakang untuk privasi masing-masing keluarga, sementara bagian depan berupa selasar panjang terbuka untuk musyawarah.',
      ),
      'Rumah Joglo Jawa Tengah': const HouseExtraContent(
        filosofiAtap:
            'Bentuk atap tajug (gunung) melambangkan gunung suci, tempat bersemayamnya para dewa atau leluhur, serta mencerminkan ketenangan dan keseimbangan hidup masyarakat Jawa.',
        materials: [
          MaterialDetail(
            name: 'Kayu Jati (Teakwood)',
            description:
                'Kayu utama yang sangat kuat dan berharga tinggi, digunakan untuk soko guru dan gebyok ukir.',
            icon: Icons.forest_rounded,
          ),
          MaterialDetail(
            name: 'Genteng Tanah Liat',
            description:
                'Atap genteng tanah liat tradisional yang menyerap panas matahari, menjaga suhu ruangan tetap dingin.',
            icon: Icons.home_rounded,
          ),
          MaterialDetail(
            name: 'Batu Candi',
            description:
                'Fondasi batu sebagai tumpuan tiang utama agar terhindar dari pelapukan tanah.',
            icon: Icons.category_rounded,
          ),
        ],
        fungsiRuangan:
            'Dibagi menjadi tiga bagian utama: Pendopo di depan untuk menerima tamu, Pringgitan di tengah untuk pertunjukan seni, dan Dalem Ageng di belakang sebagai area keluarga privat.',
      ),
      'Rumah Tongkonan': const HouseExtraContent(
        filosofiAtap:
            'Atap melengkung ekstrem yang menyerupai perahu melambangkan perahu leluhur Austronesia, sekaligus menyerupai tanduk kerbau yang melambangkan kekuatan.',
        materials: [
          MaterialDetail(
            name: 'Kayu Uru',
            description:
                'Kayu lokal berkualitas tinggi yang tahan lapuk, digunakan untuk panel dinding dan tiang penopang.',
            icon: Icons.forest_rounded,
          ),
          MaterialDetail(
            name: 'Bambu (Bamboo)',
            description:
                'Atap terbuat dari susunan bambu yang dilapisi ijuk, dirancang agar air hujan mengalir dengan cepat.',
            icon: Icons.eco_rounded,
          ),
          MaterialDetail(
            name: 'Tanduk Kerbau',
            description:
                'Hiasan tanduk kerbau asli yang dipasang di tiang depan sebagai lambang status sosial keluarga.',
            icon: Icons.star_rounded,
          ),
        ],
        fungsiRuangan:
            'Terbagi menjadi tiga bagian: Banua Sangka\' di bagian utara untuk tamu, Sulluk Banua di tengah untuk tempat tidur, dan Banua Kakia\' di selatan untuk tetua adat.',
      ),
      'Rumah Honai': const HouseExtraContent(
        filosofiAtap:
            'Bentuk bulat dan atap kubah jerami melambangkan persatuan suku Dani serta meminimalkan paparan angin pegunungan yang dingin agar panas api di dalam tetap terjaga.',
        materials: [
          MaterialDetail(
            name: 'Kayu Hutan (Wood)',
            description:
                'Kayu kuat pilihan dari hutan Papua untuk tiang penopang utama dan dinding lingkaran.',
            icon: Icons.forest_rounded,
          ),
          MaterialDetail(
            name: 'Alang-alang / Jerami',
            description:
                'Atap tumpukan jerami tebal yang berfungsi sebagai isolator termal alami dari suhu dingin ekstrem.',
            icon: Icons.grass_rounded,
          ),
          MaterialDetail(
            name: 'Rotan (Rattan)',
            description:
                'Pengikat kerangka atap jerami agar tahan terhadap tiupan angin kencang.',
            icon: Icons.eco_rounded,
          ),
        ],
        fungsiRuangan:
            'Terdiri dari dua lantai: lantai bawah dengan perapian di tengah untuk berkumpul, serta lantai atas berlandaskan jerami untuk tempat tidur yang hangat.',
      ),
    };

    return extraContentMap[title] ??
        HouseExtraContent(
          filosofiAtap:
              'Bentuk atap $title dirancang dengan kemiringan tertentu yang adaptif terhadap iklim tropis basah di Indonesia, sekaligus melambangkan doa dan rasa syukur kepada Sang Pencipta.',
          materials: const [
            MaterialDetail(
              name: 'Kayu Lokal (Local Wood)',
              description:
                  'Bahan struktural utama untuk tiang dan dinding yang diambil langsung dari alam sekitar.',
              icon: Icons.forest_rounded,
            ),
            MaterialDetail(
              name: 'Serat Alam',
              description:
                  'Atap dari ijuk, rumbia, atau ilalang kering yang memberikan sirkulasi udara alami.',
              icon: Icons.grass_rounded,
            ),
            MaterialDetail(
              name: 'Bambu / Rotan',
              description:
                  'Digunakan untuk lantai bilah dan pengikat struktural tradisional.',
              icon: Icons.eco_rounded,
            ),
          ],
          fungsiRuangan:
              'Tata ruang di dalam $title dirancang fleksibel dengan membagi area menjadi ruang publik di bagian depan untuk musyawarah adat, dan ruang privat di bagian belakang untuk keluarga.',
        );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final extraContent =
        _firestoreExtraContent ??
        _getExtraContent(widget.title, widget.location);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. Bagian Atas (Header & Hero Image) - Lebar Penuh
            // ==========================================
            Stack(
              children: [
                Hero(
                  tag: widget.title,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                        stops: [0.7, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.network(
                      widget.imageUrl,
                      width: double.infinity,
                      height: 380.sh,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 380.sh,
                        color: Colors.grey.shade300,
                        child: Icon(Icons.broken_image, size: 50.sw),
                      ),
                    ),
                  ),
                ),

                // Tombol Kembali
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16.sh,
                  left: 16.sw,
                  child: _buildCircleButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                ),

                // Ikon Favorit
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16.sh,
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

                // Badge Lokasi (Overlaid di bagian kiri bawah gambar)
                Positioned(
                  bottom: 24.sh,
                  left: 24.sw,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.sw,
                      vertical: 8.sh,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      widget.location.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12.sf,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ==========================================
            // 2. Konten Utama (Title, Desc & Seksi)
            // ==========================================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.lora(
                      fontSize: 32.sf,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 16.sh),

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

                  // ==========================================
                  // 3. Seksi-seksi Baru (Cards)
                  // ==========================================

                  // Seksi 1: Filosofi Atap
                  _buildSectionCard(
                    icon: Icons.roofing_rounded,
                    title: 'Filosofi Atap',
                    child: Text(
                      extraContent.filosofiAtap,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sf,
                        height: 1.7,
                        color: AppColors.secondaryText.withValues(alpha: 0.85),
                      ),
                    ),
                  ),

                  // Seksi 2: Material Bangunan
                  _buildSectionCard(
                    icon: Icons.construction_rounded,
                    title: 'Material Bangunan',
                    child: Column(
                      children: extraContent.materials.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        final material = entry.value;
                        final isLast =
                            index == extraContent.materials.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 16.sh),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.sw),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  material.icon,
                                  size: 18.sw,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 12.sw),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      material.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sf,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                    SizedBox(height: 2.sh),
                                    Text(
                                      material.description,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.sf,
                                        height: 1.5,
                                        color: AppColors.secondaryText
                                            .withValues(alpha: 0.65),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Seksi 3: Fungsi Ruangan
                  _buildSectionCard(
                    icon: Icons.door_sliding_rounded,
                    title: 'Fungsi Ruangan',
                    child: Text(
                      extraContent.fungsiRuangan,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sf,
                        height: 1.7,
                        color: AppColors.secondaryText.withValues(alpha: 0.85),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.sh),
                ],
              ),
            ),
          ],
        ),
      ),

      // ==========================================
      // 4. Tombol Aksi (Tes Kuis per daerah)
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
              final String region = widget.regionName.isNotEmpty
                  ? widget.regionName
                  : 'Random';
              final Map<String, dynamic> category = {
                'title': region == 'Random' ? 'Acak (Nusantara)' : region,
                'region': region,
                'icon': _getRegionIcon(region),
                'color': _getRegionColor(region),
                'desc': _getRegionDesc(region),
              };
              _showQuizSelectionConfirmation(context, category);
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

  // Widget Seksi Kartu Baru
  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20.sw,
              color: const Color(0xFF8B5E3C), // Earthy brown accent color
            ),
            SizedBox(width: 8.sw),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16.sf,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.sh),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.sw),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: child,
        ),
        SizedBox(height: 20.sh),
      ],
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
        padding: EdgeInsets.all(8.sw),
        decoration: BoxDecoration(
          color: Colors.white,
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

  IconData _getRegionIcon(String region) {
    switch (region.toLowerCase()) {
      case 'sumatera':
        return Icons.map;
      case 'jawa':
        return Icons.account_balance;
      case 'kalimantan':
        return Icons.park;
      case 'sulawesi':
        return Icons.sailing;
      case 'papua':
        return Icons.landscape;
      default:
        return Icons.public;
    }
  }

  Color _getRegionColor(String region) {
    switch (region.toLowerCase()) {
      case 'sumatera':
        return Colors.green[700] ?? Colors.green;
      case 'jawa':
        return Colors.brown[600] ?? Colors.brown;
      case 'kalimantan':
        return Colors.teal[700] ?? Colors.teal;
      case 'sulawesi':
        return Colors.indigo[600] ?? Colors.indigo;
      case 'papua':
        return Colors.orange[800] ?? Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  String _getRegionDesc(String region) {
    switch (region.toLowerCase()) {
      case 'sumatera':
        return 'Fokus pada rumah gadang, krong bade, dan arsitektur Sumatera lainnya.';
      case 'jawa':
        return 'Pelajari keanggunan Joglo, limasan, dan rumah adat Jawa.';
      case 'kalimantan':
        return 'Menjelajahi kearifan rumah Betang dan rumah panggung lainnya.';
      case 'sulawesi':
        return 'Uji pengetahuanmu tentang Tongkonan dan pesona Sulawesi.';
      case 'papua':
        return 'Temukan keunikan Honai dan arsitektur alam Papua.';
      default:
        return 'Uji pemahamanmu secara menyeluruh tentang arsitektur di seluruh Indonesia.';
    }
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

// Data Classes untuk Seksi Tambahan
class MaterialDetail {
  final String name;
  final String description;
  final IconData icon;

  const MaterialDetail({
    required this.name,
    required this.description,
    required this.icon,
  });
}

class HouseExtraContent {
  final String filosofiAtap; // renamed from filofiAtap
  final List<MaterialDetail> materials;
  final String fungsiRuangan;

  const HouseExtraContent({
    required this.filosofiAtap,
    required this.materials,
    required this.fungsiRuangan,
  });
}
