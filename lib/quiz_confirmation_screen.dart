import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'quiz_screen.dart';
import 'utils/responsive_helper.dart';

class QuizConfirmationScreen extends StatelessWidget {
  final String title;
  final String region;
  final String description;
  final IconData icon;
  final Color color;

  const QuizConfirmationScreen({
    super.key,
    required this.title,
    required this.region,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.secondaryText),
        title: Text(
          'Detail Kuis',
          style: GoogleFonts.lora(
            fontSize: 22.sf,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryText,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.sw, vertical: 16.sh),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Card Kategori
              Container(
                padding: EdgeInsets.all(28.sw),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80.sw,
                      height: 80.sw,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 42.sw),
                    ),
                    SizedBox(height: 20.sh),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lora(
                        fontSize: 26.sf,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 12.sh),
                    Text(
                      description,
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
              SizedBox(height: 32.sh),

              // Info Kuis
              Container(
                padding: EdgeInsets.all(20.sw),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryText.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _infoRow(
                      icon: Icons.quiz_rounded,
                      iconColor: AppColors.primary,
                      label: 'Jumlah Soal',
                      value: '10 soal per sesi',
                    ),
                    Divider(height: 24.sh, color: AppColors.border),
                    _infoRow(
                      icon: Icons.shuffle_rounded,
                      iconColor: Colors.orange,
                      label: 'Urutan Soal',
                      value: 'Diacak setiap sesi',
                    ),
                    Divider(height: 24.sh, color: AppColors.border),
                    _infoRow(
                      icon: Icons.stars_rounded,
                      iconColor: Colors.amber,
                      label: 'Skor',
                      value: 'Disimpan ke akun Anda',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Tombol Mulai Kuis
              SizedBox(
                width: double.infinity,
                height: 54.sh,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Ganti halaman ini dengan QuizScreen (hapus dari stack)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(region: region),
                      ),
                    );
                  },
                  icon: Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 28.sw),
                  label: Text(
                    'Mulai Kuis',
                    style: GoogleFonts.manrope(
                      fontSize: 16.sf,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(height: 12.sh),

              // Tombol Kembali ke Pilih Kuis
              SizedBox(
                width: double.infinity,
                height: 54.sh,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Pop kembali ke QuizMenuScreen
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_rounded, color: AppColors.primary, size: 20.sw),
                  label: Text(
                    'Kembali ke Pilih Kuis',
                    style: GoogleFonts.manrope(
                      fontSize: 15.sf,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.sh),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.sw),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20.sw),
        ),
        SizedBox(width: 14.sw),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sf,
              color: AppColors.greyText,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 14.sf,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
