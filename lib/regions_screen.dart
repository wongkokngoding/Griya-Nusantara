import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_colors.dart';
import 'widgets/house_card.dart';
import 'house_detail_screen.dart';
import 'utils/responsive_helper.dart';

// ===========================================================================
// Data Model
// ===========================================================================
class IslandRegion {
  final String name;
  final String label;
  final IconData icon;
  final Color color;
  final String description;
  final double xPercent;
  final double yPercent;
  final bool
  textAboveCircle; // 👈 Menentukan apakah teks berada di atas atau di bawah lingkaran

  const IslandRegion({
    required this.name,
    required this.label,
    required this.icon,
    required this.color,
    required this.description,
    required this.xPercent,
    required this.yPercent,
    this.textAboveCircle = false, // 👈 Default di bawah lingkaran
  });
}

final List<IslandRegion> kIslandRegions = [
  IslandRegion(
    name: 'Sumatera',
    label: 'Sumatera',
    icon: Icons.map,
    color: Colors.green[700]!,
    description: '10 Rumah Adat dari Aceh hingga Lampung',
    xPercent: 0.23,
    yPercent: 0.60,
  ),
  IslandRegion(
    name: 'Jawa',
    label: 'Jawa',
    icon: Icons.account_balance,
    color: Colors.brown[600]!,
    description: '6 Rumah Adat dari Banten hingga Jawa Timur',
    xPercent: 0.40,
    yPercent: 0.78,
  ),
  IslandRegion(
    name: 'Kalimantan',
    label: 'Kalimantan',
    icon: Icons.park,
    color: Colors.teal[700]!,
    description: '11 Rumah Adat suku Dayak & Banjar',
    xPercent: 0.42,
    yPercent: 0.48,
    textAboveCircle: true,
  ),
  IslandRegion(
    name: 'Sulawesi',
    label: 'Sulawesi',
    icon: Icons.sailing,
    color: Colors.indigo[600]!,
    description: '7 Rumah Adat dari Toraja hingga Minahasa',
    xPercent: 0.58,
    yPercent: 0.64,
  ),
  IslandRegion(
    name: 'Papua',
    label: 'Papua',
    icon: Icons.landscape,
    color: Colors.orange[800]!,
    description: '10 Rumah Adat dari Honai hingga Kariwari',
    xPercent: 0.93,
    yPercent: 0.66,
  ),
];

// ===========================================================================
// RegionsScreen
// ===========================================================================
class RegionsScreen extends StatefulWidget {
  const RegionsScreen({super.key});

  @override
  State<RegionsScreen> createState() => _RegionsScreenState();
}

class _RegionsScreenState extends State<RegionsScreen>
    with TickerProviderStateMixin {
  IslandRegion? _selectedRegion;

  // Animasi pin berdenyut
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Animasi slide-up tombol wilayahrr
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse untuk pin di atas peta
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Slide-up + fade untuk tombol wilayah yang muncul saat diklik
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // Ketika pin pulau diklik: tampilkan tombol untuk wilayah itu
  void _onPinTap(IslandRegion region) {
    if (_selectedRegion?.name == region.name) {
      // Klik pin yang sama lagi → sembunyikan tombol
      _slideController.reverse().then((_) {
        if (mounted) setState(() => _selectedRegion = null);
      });
    } else {
      setState(() => _selectedRegion = region);
      _slideController.forward(from: 0);
    }
  }

  // Batalkan pilihan pulau saat tap area kosong di peta (bukan pin)
  void _onMapTapEmpty() {
    if (_selectedRegion == null) return;
    _slideController.reverse().then((_) {
      if (mounted) setState(() => _selectedRegion = null);
    });
  }

  // Ketika tombol wilayah diklik → buka bottom sheet
  void _onRegionButtonTap(IslandRegion region) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RegionBottomSheet(region: region),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Scrollable area: Header + Peta + Section Bento ──────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──────────────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.sw, 24.sh, 24.sw, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Peta Nusantara',
                            style: GoogleFonts.lora(
                              fontSize: 24.sf,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 6.sh),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _selectedRegion == null
                                  ? 'Ketuk pin pulau di peta untuk menjelajah.'
                                  : 'Pulau ${_selectedRegion!.label} dipilih. Ketuk tombol di bawah untuk melihat rumah adat.',
                              key: ValueKey(_selectedRegion?.name ?? 'empty'),
                              style: GoogleFonts.poppins(
                                fontSize: 13.sf,
                                color: _selectedRegion == null
                                    ? AppColors.greyText
                                    : AppColors.primary,
                                fontWeight: _selectedRegion == null
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.sh),

                    // ── Peta SVG Indonesia ────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sw),
                      child: AspectRatio(
                        aspectRatio: 2021 / 1500,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4EBF8),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.06,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final mapWidth = constraints.maxWidth;
                                final mapHeight = constraints.maxHeight;

                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: _onMapTapEmpty,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Padding(
                                          padding: EdgeInsets.all(12.sw),
                                          child: SvgPicture.asset(
                                            'assets/indonesia.svg',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      ...kIslandRegions.map((region) {
                                        final isActive =
                                            _selectedRegion?.name ==
                                            region.name;
                                        final leftPos =
                                            region.xPercent * mapWidth;
                                        final topPos =
                                            region.yPercent * mapHeight;

                                        return Positioned(
                                          left: leftPos - 55.sw,
                                          top: topPos - 32.sh,
                                          child: _MapHotspotPin(
                                            region: region,
                                            isActive: isActive,
                                            pulseAnimation: _pulseAnimation,
                                            onTap: () => _onPinTap(region),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 28.sh),

                    // ── Judul Section "Jelajahi Pulau" ────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sw),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jelajahi Pulau',
                                style: GoogleFonts.lora(
                                  fontSize: 24.sf,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              Text(
                                'Pilih pulau untuk melihat rumah adatnya',
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sf,
                                  color: AppColors.greyText,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.sw,
                              vertical: 3.sh,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '5 Pulau',
                              style: GoogleFonts.poppins(
                                fontSize: 11.sf,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 14.sh),

                    // ── Shortcut Button Pulau (Bento Layout Kotak) ────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sw),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _BentoShortcutButton(
                                  region: kIslandRegions[0],
                                  isSelected:
                                      _selectedRegion?.name ==
                                      kIslandRegions[0].name,
                                  onTap: () => _onPinTap(kIslandRegions[0]),
                                ),
                              ),
                              SizedBox(width: 8.sw),
                              Expanded(
                                child: _BentoShortcutButton(
                                  region: kIslandRegions[1],
                                  isSelected:
                                      _selectedRegion?.name ==
                                      kIslandRegions[1].name,
                                  onTap: () => _onPinTap(kIslandRegions[1]),
                                ),
                              ),
                              SizedBox(width: 8.sw),
                              Expanded(
                                child: _BentoShortcutButton(
                                  region: kIslandRegions[2],
                                  isSelected:
                                      _selectedRegion?.name ==
                                      kIslandRegions[2].name,
                                  onTap: () => _onPinTap(kIslandRegions[2]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.sh),
                          Row(
                            children: [
                              Expanded(
                                child: _BentoShortcutButton(
                                  region: kIslandRegions[3],
                                  isSelected:
                                      _selectedRegion?.name ==
                                      kIslandRegions[3].name,
                                  onTap: () => _onPinTap(kIslandRegions[3]),
                                ),
                              ),
                              SizedBox(width: 8.sw),
                              Expanded(
                                child: _BentoShortcutButton(
                                  region: kIslandRegions[4],
                                  isSelected:
                                      _selectedRegion?.name ==
                                      kIslandRegions[4].name,
                                  onTap: () => _onPinTap(kIslandRegions[4]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.sh),
                  ],
                ),
              ),
            ),

            // ── Area Bawah: Tombol Wilayah yang Muncul Secara Dinamis ──────
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              height: _selectedRegion == null
                  ? 0
                  : 118.sh, // 0 saat awal/kosong, 132 saat pulau diklik agar card tidak overflow
              child: _selectedRegion == null
                  ? const SizedBox.shrink()
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sw),
                          child: _RegionActionCard(
                            region: _selectedRegion!,
                            onTap: () => _onRegionButtonTap(_selectedRegion!),
                            onDismiss: () {
                              _slideController.reverse().then((_) {
                                if (mounted) {
                                  setState(() => _selectedRegion = null);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
            ),

            SizedBox(height: 16.sh),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// _MapHotspotPin – Pin berdenyut di atas peta
// ===========================================================================
class _MapHotspotPin extends StatelessWidget {
  final IslandRegion region;
  final bool isActive;
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const _MapHotspotPin({
    required this.region,
    required this.isActive,
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    // Siapkan daftar widget
    final List<Widget> childrenList = [
      // 1. Lingkaran berdenyut
      AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isActive ? pulseAnimation.value : 1.0,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isActive ? 22.sw : 16.sw,
          height: isActive ? 22.sw : 16.sw,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: region.color.withValues(alpha: isActive ? 1.0 : 0.7),
            boxShadow: [
              BoxShadow(
                color: region.color.withValues(alpha: isActive ? 0.6 : 0.3),
                blurRadius: isActive ? 12 : 6,
                spreadRadius: isActive ? 3 : 1,
              ),
            ],
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isActive ? 10.sw : 6.sw,
              height: isActive ? 10.sw : 6.sw,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 5.sh),
      // 2. Badge nama pulau
      AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 8.sw, vertical: 4.sh),
        decoration: BoxDecoration(
          color: isActive ? region.color : Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: region.color, width: isActive ? 1.5 : 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              region.icon,
              size: 14.sw,
              color: isActive ? Colors.white : region.color,
            ),
            SizedBox(width: 3.sw),
            Text(
              region.label,
              style: GoogleFonts.poppins(
                fontSize: 9.sf,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    ];

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // Jika textAboveCircle bernilai true, balikkan list agar teks berada di atas
        children: region.textAboveCircle
            ? childrenList.reversed.toList()
            : childrenList,
      ),
    );
  }
}

// ===========================================================================
// _RegionActionCard – Kartu tombol wilayah yang muncul saat pin diklik
// ===========================================================================
class _RegionActionCard extends StatelessWidget {
  final IslandRegion region;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _RegionActionCard({
    required this.region,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: region.color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: region.color.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.sw, vertical: 14.sh),
      child: Row(
        children: [
          // Icon/emoji
          Container(
            width: 52.sw,
            height: 52.sw,
            decoration: BoxDecoration(
              color: region.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(region.icon, size: 26.sw, color: region.color),
          ),
          SizedBox(width: 14.sw),
          // Info wilayah
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pulau ${region.label}',
                  style: GoogleFonts.lora(
                    fontSize: 17.sf,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(height: 3.sh),
                Text(
                  region.description,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sf,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.sw),
          // Tombol Jelajahi
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.sw, vertical: 10.sh),
              decoration: BoxDecoration(
                color: region.color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: region.color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.explore_outlined,
                    color: Colors.white,
                    size: 18.sw,
                  ),
                  SizedBox(height: 2.sh),
                  Text(
                    'Jelajahi',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sf,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.sw),
          // Tombol tutup / dismiss
          GestureDetector(
            onTap: onDismiss,
            child: Container(
              padding: EdgeInsets.all(8.sw),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.close, size: 16.sw, color: AppColors.greyText),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// _RegionBottomSheet – Panel popup daftar rumah adat
// ===========================================================================
class _RegionBottomSheet extends StatelessWidget {
  final IslandRegion region;

  const _RegionBottomSheet({required this.region});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.4,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Drag Handle
              SizedBox(height: 12.sh),
              Container(
                width: 40.sw,
                height: 4.sh,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 16.sh),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.sw),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.sw),
                      decoration: BoxDecoration(
                        color: region.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        region.icon,
                        size: 24.sw,
                        color: region.color,
                      ),
                    ),
                    SizedBox(width: 14.sw),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pulau ${region.label}',
                            style: GoogleFonts.lora(
                              fontSize: 20.sf,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          Text(
                            region.description,
                            style: GoogleFonts.poppins(
                              fontSize: 12.sf,
                              color: AppColors.greyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8.sw),
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18.sw,
                          color: AppColors.greyText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.sh),
              const Divider(color: AppColors.border, height: 1),
              SizedBox(height: 8.sh),

              // Daftar Rumah Adat dari Firestore
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('houses')
                      .where('category', isEqualTo: region.name)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: region.color),
                            SizedBox(height: 12.sh),
                            Text(
                              'Memuat rumah adat...',
                              style: GoogleFonts.poppins(
                                color: AppColors.greyText,
                                fontSize: 13.sf,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Terjadi kesalahan: ${snapshot.error}',
                          style: TextStyle(color: Colors.red, fontSize: 14.sf),
                        ),
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];

                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.house_siding_outlined,
                              size: 64.sw,
                              color: AppColors.border,
                            ),
                            SizedBox(height: 12.sh),
                            Text(
                              'Belum ada data untuk wilayah ini.\nSilahkan sync database terlebih dahulu.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: AppColors.greyText,
                                fontSize: 13.sf,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.fromLTRB(24.sw, 8.sh, 24.sw, 24.sh),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final house =
                            docs[index].data() as Map<String, dynamic>;

                        final title = house['title'] ?? '';
                        final location = house['location'] ?? '';
                        final description = house['description'] ?? '';
                        final imageUrl =
                            house['imageUrl'] ??
                            'https://via.placeholder.com/600x400';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HouseDetailScreen(
                                  title: title,
                                  location: location,
                                  regionName: region.label,
                                  description: description,
                                  imageUrl: imageUrl,
                                ),
                              ),
                            );
                          },
                          child: HouseCard(
                            title: title,
                            location: location,
                            description: description,
                            imageUrl: imageUrl,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ===========================================================================
// _BentoShortcutButton – Desain kotak khusus untuk Shortcut Bento
// ===========================================================================
class _BentoShortcutButton extends StatelessWidget {
  final IslandRegion region;
  final bool isSelected;
  final VoidCallback onTap;

  const _BentoShortcutButton({
    required this.region,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 115.sh, // 👈 Tinggi bento box diperbesar agar muat deskripsi
        padding: EdgeInsets.symmetric(
          horizontal: 6.sw,
          vertical: 8.sh,
        ), // Padding agar teks tidak mentok garis
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              region.icon,
              size: 25.sw,
              color: isSelected ? Colors.white : region.color,
            ), // 👈 Ikon diperbesar
            SizedBox(height: 6.sh),
            Text(
              region.label,
              style: GoogleFonts.poppins(
                fontSize: 14.sf, // 👈 Teks pulau diperbesar
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 4.sh),
            // 👈 Ringkasan singkat ditambahkan di sini
            Text(
              region.description,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10
                    .sf, // Ukuran font dibuat kecil agar estetik dan muat di dalam kotak
                height: 1.2,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : AppColors.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
