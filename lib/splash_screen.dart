import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'constants/app_info.dart';
import 'theme/app_text_styles.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'utils/responsive_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _minSplashDuration = Duration(milliseconds: 2200);

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
    _goToNextScreen();
  }

  Future<void> _goToNextScreen() async {
    final results = await Future.wait<dynamic>([
      Future.delayed(_minSplashDuration),
      FirebaseAuth.instance.authStateChanges().first,
      AppTextStyles.preload(),
    ]);

    if (!mounted) return;

    final user = results[1] as User?;
    final Widget next = user != null ? const HomeScreen() : const LoginScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => next,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.sw),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100.sw,
                    height: 100.sw,
                  ),
                  SizedBox(height: 16.sh),
                  Text(
                    AppInfo.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 28.sf,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  SizedBox(height: 8.sh),
                  Text(
                    'Rumah Adat Warisan Budaya',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sf,
                      color: AppColors.greyText,
                    ),
                  ),
                  SizedBox(height: 48.sh),
                  SizedBox(
                    width: 28.sw,
                    height: 28.sw,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
