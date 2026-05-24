import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_colors.dart';

import 'widgets/house_card.dart';
import 'regions_screen.dart';
import 'house_detail_screen.dart';
import 'quiz_menu_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';
import 'utils/responsive_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Halaman-halaman yang ditampilkan sesuai tab yang aktif
  late final List<Widget> _pages = [
    const _ExploreTab(), // index 0: Explore
    const RegionsScreen(), // index 1: Regions
    const QuizMenuScreen(), // index 2: Quiz Menu
    const LibraryScreen(), // index 3: Library
    const ProfileScreen(), // index 4: Profile
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Griya Nusantara',
          style: GoogleFonts.lora(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24.sf,
          ),
        ),
        centerTitle: true,
      ),
      // IndexedStack menjaga state setiap tab tetap hidup saat berpindah tab
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.greyText,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        elevation: 20,
        selectedFontSize: 12.sf,
        unselectedFontSize: 12.sf,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.normal,
        ),
        iconSize: 24.sw,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Daerah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Kuis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
            label: 'Perpustakaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// _ExploreTab – Konten tab Explore (dipindahkan dari HomeScreen)
// ===========================================================================
class _ExploreTab extends StatefulWidget {
  const _ExploreTab();

  @override
  State<_ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<_ExploreTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _searchDebounce;
  final User? _user = FirebaseAuth.instance.currentUser;

  // Daftar rumah adat "Populer" yang tampil sebagai default di beranda
  final List<String> _popularHouses = [
    'rumah gadang',
    'rumah krong bade',
    'rumah joglo',
    'rumah betang',
    'rumah tongkonan',
    'honai',
  ];

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = value.toLowerCase().trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(_user?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              String name = 'Nusantara Explorer';
              if (snapshot.hasData && snapshot.data!.exists) {
                name = snapshot.data!['name'] ?? name;
              }
              return Text(
                'Selamat Datang,\n$name',
                style: GoogleFonts.lora(
                  fontSize: 28.sf,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryText,
                  height: 1.2,
                ),
              );
            },
          ),
          SizedBox(height: 8.sh),
          Text(
            'Temukan warisan Rumah Adat Indonesia.',
            style: TextStyle(fontSize: 16.sf, color: AppColors.greyText),
          ),
          SizedBox(height: 24.sh),

          // ── Search Bar ──────────────────────────────────────────────────
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Cari rumah adat, provinsi, atau pulau',
              hintStyle: GoogleFonts.poppins(
                color: AppColors.greyText,
                fontSize: 14.sf,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.greyText,
                size: 24.sw,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 14.sh),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.sh),

          // ── Section Title ───────────────────────────────────────────────
          Text(
            _searchQuery.isEmpty ? 'Rumah Adat Populer' : 'Hasil Pencarian',
            style: GoogleFonts.lora(
              fontSize: 22.sf,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(height: 16.sh),

          // ── Main Content (Filtered locally from Firestore) ──────────────
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('houses').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Terjadi kesalahan data'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final docs = snapshot.data!.docs;

              // Filter logic (Pencarian & Popular)
              final filteredDocs = docs.where((doc) {
                final house = doc.data() as Map<String, dynamic>;
                final title = (house['title'] ?? '').toString().toLowerCase();
                final location = (house['location'] ?? '')
                    .toString()
                    .toLowerCase();
                final category = (house['category'] ?? '')
                    .toString()
                    .toLowerCase();

                if (_searchQuery.isNotEmpty) {
                  // Pencarian aktif
                  return title.contains(_searchQuery) ||
                      location.contains(_searchQuery) ||
                      category.contains(_searchQuery);
                } else {
                  // Jika kosong, tampilkan hanya yang populer
                  return _popularHouses.any(
                    (popularName) => title.contains(popularName),
                  );
                }
              }).toList();

              if (filteredDocs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.sh),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64.sw,
                          color: AppColors.border,
                        ),
                        SizedBox(height: 16.sh),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Belum ada data populer yang ditemukan.'
                              : 'Pencarian "$_searchQuery" tidak ditemukan',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sf,
                            color: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final house =
                      filteredDocs[index].data() as Map<String, dynamic>;

                  final title = house['title'] ?? '';
                  final location = house['location'] ?? '';
                  final description = house['description'] ?? '';
                  final category = house['category'] ?? 'Indonesia';
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
                            regionName: category,
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
        ],
      ),
    );
  }
}
