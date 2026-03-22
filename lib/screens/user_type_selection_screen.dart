import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'auth/login_screen.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  void _select(BuildContext context, UserType type) {
    context.read<AuthProvider>().setUserType(type);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Logo circle
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary10,
                      border: Border.all(color: AppColors.primary, width: 1),
                    ),
                    child: const Icon(
                      Icons.balance_rounded,
                      color: AppColors.accent,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome to\nDharamRaksha',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.merriweather(
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'How would you like to use the app?',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 14 : 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),

                  // Client card
                  _TypeCard(
                    icon: Icons.person_rounded,
                    title: 'I need legal help',
                    subtitle:
                        'Find verified lawyers, get instant advice, manage your legal matters.',
                    label: 'Continue as Client',
                    onTap: () => _select(context, UserType.client),
                  ),
                  const SizedBox(height: 16),
                  // Lawyer card
                  _TypeCard(
                    icon: Icons.gavel_rounded,
                    title: 'I am a Lawyer',
                    subtitle:
                        'Offer consultations, manage clients, grow your practice.',
                    label: 'Continue as Lawyer',
                    onTap: () => _select(context, UserType.lawyer),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String label;
  final VoidCallback onTap;

  const _TypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary10,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.merriweather(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
