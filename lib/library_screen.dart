import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_colors.dart';
import 'widgets/house_card.dart';
import 'house_detail_screen.dart';
import 'utils/responsive_helper.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Silakan login untuk melihat koleksi favorit Anda.',
            style: GoogleFonts.poppins(
              fontSize: 14.sf,
              color: AppColors.greyText,
            ),
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
        titleSpacing: 24.sw,
        title: Text(
          'Koleksi Favorit',
          style: GoogleFonts.lora(
            fontSize: 24.sf,
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
                  padding: EdgeInsets.symmetric(horizontal: 32.sw),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 64.sw,
                        color: AppColors.border,
                      ),
                      SizedBox(height: 16.sh),
                      Text(
                        'Belum ada rumah adat favorit',
                        style: GoogleFonts.lora(
                          fontSize: 20.sf,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      SizedBox(height: 8.sh),
                      Text(
                        'Jelajahi berbagai rumah adat nusantara dan ketuk ikon hati untuk menyimpannya di sini.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sf,
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
              padding: EdgeInsets.only(
                left: 24.sw,
                right: 24.sw,
                bottom: 24.sh,
                top: 8.sh,
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
                  padding: EdgeInsets.only(bottom: 2.sh),
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
