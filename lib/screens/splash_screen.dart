import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'lawyer_app/lawyer_navigation_screen.dart';
import 'main_navigation_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      final auth = context.read<AuthProvider>();
      final Widget destination;

      if (auth.isAuthenticated) {
        if (auth.userType == UserType.lawyer) {
          destination = const LawyerNavigationScreen();
        } else {
          destination = const MainNavigationScreen();
        }
      } else {
        destination = const OnboardingScreen();
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => destination),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Hardline logo box (sharp)
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3), width: 1),
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: const Icon(Icons.balance_rounded,
                  color: AppColors.accent, size: 46),
            ),
            const SizedBox(height: 22),
            Text(
              'DharamRaksha',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Justice. Guidance. Protection.',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
