import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/transitions.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/lawyer_mini_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/wallet_header_action.dart';
import 'ai_guidance_screen.dart';
import 'main_navigation_screen.dart';
import 'wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _problemController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  Future<void> _analyzeProblem() async {
    final problem = _problemController.text.trim();
    if (problem.isEmpty) return;

    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() => _submitting = false);
    Navigator.push(
      context,
      slideRoute(AIGuidanceScreen(
        problem: problem,
        response: MockDataService.buildGuidance(problem),
      )),
    );
  }

  void _setQuickIssue(String issue) {
    _problemController.text = issue;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'DharmaRaksha',
      actions: const <Widget>[
        WalletHeaderAction(),
        ProfileAvatar(),
        SizedBox(width: 8),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Section ──
            _buildHeroSection(),

            // ── Problem Description ──
            _buildProblemSection(),

            // ── Featured Lawyers ──
            _buildFeaturedLawyers(),

            const SizedBox(height: 32),
            _buildNyayLibrary(),

            const SizedBox(height: 32),
            _buildLegalTip(),

            // ── Stats ──
            const SizedBox(height: 32),
            _buildStatsSection(),

            // ── Footer ──
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Legal\nCommand Center',
            style: GoogleFonts.philosopher(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'AI-assisted guidance, verified lawyers,\nand faster legal action in one place.',
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      slideRoute(const MainNavigationScreen(initialIndex: 1)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 52),
                  ),
                  child: const Text('Find Lawyer'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, slideRoute(const WalletScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    minimumSize: const Size(0, 52),
                  ),
                  child: const Text('Open Wallet'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _heroTrustBadges(),
        ],
      ),
    );
  }

  Widget _heroTrustBadges() {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        _buildTrustBadge(Icons.verified_user_rounded, '500+ Verified Lawyers'),
        _buildTrustBadge(Icons.gavel_rounded, '10k+ Cases Resolved'),
        _buildTrustBadge(Icons.star_rounded, '4.8★ User Rating'),
      ],
    );
  }

  Widget _buildTrustBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.accent, size: 20),
              const SizedBox(width: 10),
              Text(
                'Describe your problem',
                style: GoogleFonts.philosopher(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _problemController,
            maxLines: 3,
            style: GoogleFonts.outfit(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'e.g., Salary not paid by employer since 3 months...',
              hintStyle: GoogleFonts.outfit(
                color: AppColors.textSecondary.withOpacity(0.5),
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.glassColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.accent),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitting ? null : _analyzeProblem,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: _submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Generate AI Guidance'),
          ),
          const SizedBox(height: 16),
          Text(
            'Quick Issues:',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MockDataService.quickIssues
                  .map(
                    (issue) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        onPressed: () => _setQuickIssue(issue),
                        label: Text(issue),
                        labelStyle: GoogleFonts.outfit(fontSize: 12),
                        backgroundColor: AppColors.glassColor,
                        side: BorderSide(color: AppColors.glassBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedLawyers() {
    final topLawyers = MockDataService.lawyers.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Lawyers',
                style: GoogleFonts.philosopher(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: topLawyers.length,
            itemBuilder: (context, index) {
              final lawyer = topLawyers[index];
              final firmName = MockDataService.getFirmById(lawyer.firmId)?.name ?? 'Alpha Legal';
              return LawyerMiniCard(lawyer: lawyer, firmName: firmName);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNyayLibrary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Nyay Library',
            style: GoogleFonts.philosopher(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: [
              _buildLibraryCard(
                'Case of the Day',
                'How a tenant won against unfair eviction.',
                Icons.history_edu_rounded,
              ),
              _buildLibraryCard(
                'FIR Guide',
                'Step-by-step guide to filing a police complaint.',
                Icons.gavel_rounded,
              ),
              _buildLibraryCard(
                'Cyber Safety',
                'Protecting yourself from online financial fraud.',
                Icons.security_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryCard(String title, String subtitle, IconData icon) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.accent, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.philosopher(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLegalTip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
          border: Border.all(color: AppColors.accent.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_rounded, color: AppColors.accent, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'LEGAL TIP OF THE DAY',
                        style: GoogleFonts.outfit(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Always get a signed receipt for cash rent payments to ensure legal proof.',
                    style: GoogleFonts.philosopher(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatCard('Verified Lawyers', '500+', Icons.verified_user_rounded),
          const SizedBox(width: 12),
          _buildStatCard('Response Time', '15m', Icons.timer_rounded),
          const SizedBox(width: 12),
          _buildStatCard('User Rating', '4.8', Icons.star_rounded),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: AppColors.accent),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.philosopher(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.balance_rounded, color: AppColors.accent, size: 24),
              const SizedBox(width: 12),
              Text(
                'DharmaRaksha',
                style: GoogleFonts.philosopher(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Securing your rights, with sacred trust.',
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '© 2026 DharmaRaksha. All rights reserved.',
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
