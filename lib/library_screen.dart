import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_colors.dart';
import 'widgets/house_card.dart';
import 'house_detail_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Silakan login untuk melihat koleksi favorit Anda.',
            style: GoogleFonts.poppins(color: AppColors.greyText),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 24.0,
        title: Text(
          'Koleksi Favorit',
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('favorites')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Terjadi kesalahan memuat data.'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        size: 64,
                        color: AppColors.border,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada rumah adat favorit',
                        style: GoogleFonts.lora(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jelajahi berbagai rumah adat nusantara dan ketuk ikon hati untuk menyimpannya di sini.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: AppColors.greyText,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 24,
                top: 8,
              ),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final house = docs[index].data() as Map<String, dynamic>;

                final title = house['title'] ?? '';
                final location = house['location'] ?? '';
                final regionName = house['regionName'] ?? '';
                final description = house['description'] ?? '';
                final imageUrl =
                    house['imageUrl'] ?? 'https://via.placeholder.com/600x400';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HouseDetailScreen(
                            title: title,
                            location: location,
                            regionName: regionName,
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
