import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/consultation_mode.dart';
import '../models/lawyer.dart';
import '../providers/user_provider.dart';
import '../services/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/transitions.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/wallet_header_action.dart';
import 'consultation_screen.dart';
import 'law_firm_profile_screen.dart';

class LawyerProfileScreen extends StatefulWidget {
  final Lawyer lawyer;

  const LawyerProfileScreen({super.key, required this.lawyer});

  @override
  State<LawyerProfileScreen> createState() => _LawyerProfileScreenState();
}

class _LawyerProfileScreenState extends State<LawyerProfileScreen> {
  ConsultationMode _selectedMode = ConsultationMode.chat;

  @override
  Widget build(BuildContext context) {
    final lawyer = widget.lawyer;
    final firm = MockDataService.getFirmById(lawyer.firmId);
    final isSaved = context.watch<UserProvider>().isLawyerSaved(lawyer.id);
    final effectivePerMinuteFee =
        lawyer.consultationFeePerMinute * _selectedMode.feeMultiplier();
    final starterFee = effectivePerMinuteFee * 10;

    return AppScaffold(
      title: 'Lawyer Profile',
      actions: <Widget>[
        const WalletHeaderAction(),
        IconButton(
          icon: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
            color: isSaved ? AppColors.accent : AppColors.textSecondary,
          ),
          onPressed: () =>
              context.read<UserProvider>().toggleSaveLawyer(lawyer.id),
        ),
        const SizedBox(width: 8),
      ],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: <Widget>[
          // ── Profile Header (Modern Glass) ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: <Widget>[
                // Avatar with availability indicator
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
                        border: Border.all(
                          color: lawyer.isAvailable
                              ? AppColors.success
                              : AppColors.border,
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        lawyer.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.primary10,
                          alignment: Alignment.center,
                          child: Text(
                            lawyer.name[0],
                            style: GoogleFonts.philosopher(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: lawyer.isAvailable
                              ? AppColors.success
                              : AppColors.warning,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.background, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        lawyer.name,
                        style: GoogleFonts.philosopher(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lawyer.specialization,
                        style: GoogleFonts.outfit(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.star_rounded,
                              size: 16, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text(
                            '${lawyer.rating} (${lawyer.reviewsCount} reviews)',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${lawyer.experienceYears}y exp',
                            style: GoogleFonts.outfit(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Availability Badge ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.glassColor,
              borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
              border: Border.all(
                color: lawyer.isAvailable
                    ? AppColors.success.withOpacity(0.3)
                    : AppColors.warning.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  lawyer.isAvailable
                      ? Icons.check_circle_outline
                      : Icons.access_time_rounded,
                  size: 18,
                  color: lawyer.isAvailable
                      ? AppColors.success
                      : AppColors.warning,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    lawyer.isAvailable
                        ? 'Available now · avg ${lawyer.averageResponseMinutes} min response'
                        : 'Currently busy · avg ${lawyer.averageResponseMinutes} min response',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: lawyer.isAvailable
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Professional Details ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Professional Details',
                  style: GoogleFonts.philosopher(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _DetailRow(label: 'Specialization', value: lawyer.specialization),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: Text(
                        'Firm',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: firm == null
                          ? Text(
                              'Independent Practice',
                              style: GoogleFonts.outfit(fontSize: 14),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  slideRoute(LawFirmProfileScreen(firm: firm)),
                                );
                              },
                              child: Text(
                                firm.name,
                                style: GoogleFonts.outfit(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.accent,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _DetailRow(label: 'Location', value: lawyer.location),
                const SizedBox(height: 12),
                _DetailRow(label: 'Languages', value: lawyer.languages.join(', ')),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: lawyer.practiceAreas
                      .map(
                        (area) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                          ),
                          child: Text(
                            area,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── About ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'About',
                  style: GoogleFonts.philosopher(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  lawyer.bio,
                  style: GoogleFonts.outfit(
                    height: 1.6,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Consultation Mode ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Consultation Mode',
                  style: GoogleFonts.philosopher(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: ConsultationMode.values.map((mode) {
                    final isSelected = mode == _selectedMode;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => setState(() => _selectedMode = mode),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.accent : AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.accent : AppColors.glassBorder,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.accent.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  mode.icon,
                                  size: 20,
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  mode.label,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? Colors.white : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${effectivePerMinuteFee.toStringAsFixed(0)} / min',
                          style: GoogleFonts.philosopher(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                          ),
                        ),
                        Text(
                          '≈ ₹${starterFee.toStringAsFixed(0)} for 10 min',
                          style: GoogleFonts.outfit(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          slideRoute(ConsultationScreen(
                            lawyer: lawyer,
                            mode: _selectedMode,
                          )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Start Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
