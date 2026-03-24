import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/law_firm.dart';
import '../../services/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../utils/transitions.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/wallet_header_action.dart';
import '../lawyers/lawyer_profile_screen.dart';

class LawFirmProfileScreen extends StatelessWidget {
  final LawFirm firm;

  const LawFirmProfileScreen({super.key, required this.firm});

  @override
  Widget build(BuildContext context) {
    final lawyersAtFirm = MockDataService.lawyersByFirm(firm.id);

    return AppScaffold(
      title: 'Law Firm',
      actions: const <Widget>[
        WalletHeaderAction(),
        SizedBox(width: 8),
      ],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: <Widget>[
          // Firm Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                  ),
                  child: Text(
                    firm.logoPlaceholder,
                    style: GoogleFonts.philosopher(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        firm.name,
                        style: GoogleFonts.philosopher(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${firm.city} | Est. ${firm.foundedYear}',
                        style: GoogleFonts.outfit(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${firm.numberOfLawyers} Professionals',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // About & Location
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
                  'About the Firm',
                  style: GoogleFonts.philosopher(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  firm.description,
                  style: GoogleFonts.outfit(
                    height: 1.5,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Office Location',
                  style: GoogleFonts.philosopher(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        firm.officeAddress,
                        style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Practice Areas',
                  style: GoogleFonts.philosopher(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: firm.practiceAreas
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

          // Lawyers List
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
                  'Legal Team',
                  style: GoogleFonts.philosopher(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (lawyersAtFirm.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'No lawyers listed for this firm yet.',
                        style: GoogleFonts.outfit(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ...lawyersAtFirm.map(
                  (lawyer) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(lawyer.imageUrl),
                          backgroundColor: AppColors.surface,
                        ),
                      ),
                      title: Text(
                        lawyer.name,
                        style: GoogleFonts.philosopher(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      subtitle: Text(
                        '${lawyer.specialization} • ${lawyer.experienceYears}y',
                        style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
                      onTap: () {
                        Navigator.push(
                          context,
                          slideRoute(LawyerProfileScreen(lawyer: lawyer)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.accent,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    'Consultation request sent to ${firm.name}',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.business_center_rounded),
                const SizedBox(width: 12),
                const Text('Request Firm Consultation'),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
