import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../utils/responsive_helper.dart';

class HouseCard extends StatelessWidget {
  final String title;
  final String location;
  final String description;
  final String imageUrl;

  const HouseCard({
    super.key,
    required this.title,
    required this.location,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.only(bottom: 24.sh),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryText.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
                child: Image.network(
                  imageUrl,
                  height: 200.sh,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150.sh,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 50.sw, color: Colors.grey),
                    );
                  },
                ),
              ),
              Positioned(
                top: 16.sh,
                right: 16.sw,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.sw,
                    vertical: 6.sh,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    location,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sf,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lora(
                    fontSize: 20.sf,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(height: 8.sh),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sf,
                    color: AppColors.greyText,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.sh),
                Row(
                  children: [
                    Text(
                      'Jelajahi Detail',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sf,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4.sw),
                    Icon(
                      Icons.arrow_forward,
                      size: 16.sw,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
