import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';

/// Style teks yang di-cache agar tidak memuat font ulang setiap build.
class AppTextStyles {
  AppTextStyles._();

  static bool _initialized = false;

  static late final TextStyle loraBoldSecondary;
  static late final TextStyle loraBoldSecondary18;
  static late final TextStyle loraBoldSecondary20;
  static late final TextStyle manropeBody;
  static late final TextStyle manropeBody13Grey;
  static late final TextStyle manropeSemi14;
  static late final TextStyle manropeBold;
  static late final TextStyle manropeBoldPrimary;
  static late final TextStyle manropeField14;
  static late final TextStyle manropeHint14;
  static late final TextStyle manropeError12;

  static Future<void> preload() async {
    if (_initialized) return;

    await GoogleFonts.pendingFonts([
      GoogleFonts.lora(fontWeight: FontWeight.bold),
      GoogleFonts.manrope(),
      GoogleFonts.manrope(fontWeight: FontWeight.w600),
      GoogleFonts.manrope(fontWeight: FontWeight.bold),
    ]);

    loraBoldSecondary = GoogleFonts.lora(
      fontWeight: FontWeight.bold,
      color: AppColors.secondaryText,
    );
    loraBoldSecondary18 = GoogleFonts.lora(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.secondaryText,
    );
    loraBoldSecondary20 = GoogleFonts.lora(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.secondaryText,
    );
    manropeBody = GoogleFonts.manrope(color: AppColors.greyText);
    manropeBody13Grey = GoogleFonts.manrope(
      fontSize: 13,
      color: AppColors.greyText,
    );
    manropeSemi14 = GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.secondaryText,
    );
    manropeBold = GoogleFonts.manrope(fontWeight: FontWeight.bold);
    manropeBoldPrimary = GoogleFonts.manrope(
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    );
    manropeField14 = GoogleFonts.manrope(
      fontSize: 14,
      color: AppColors.secondaryText,
    );
    manropeHint14 = GoogleFonts.manrope(
      fontSize: 14,
      color: AppColors.greyText.withValues(alpha: 0.5),
    );
    manropeError12 = GoogleFonts.manrope(fontSize: 12, color: Colors.red);

    _initialized = true;
  }
}
