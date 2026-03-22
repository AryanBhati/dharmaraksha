import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/lawyer.dart';
import '../services/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/app_formatters.dart';

class LawyerCard extends StatelessWidget {
  final Lawyer lawyer;
  final VoidCallback onTap;
  final VoidCallback onConsultNow;

  const LawyerCard({
    super.key,
    required this.lawyer,
    required this.onTap,
    required this.onConsultNow,
  });

  @override
  Widget build(BuildContext context) {
    final availabilityColor = lawyer.isAvailable ? AppColors.success : AppColors.warning;
    final firmName = MockDataService.getFirmById(lawyer.firmId)?.name ?? 'Independent Practice';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: availabilityColor.withOpacity(0.5), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage(lawyer.imageUrl),
                          onBackgroundImageError: (_, __) {},
                          backgroundColor: AppColors.glassColor,
                        ),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: availabilityColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surface, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          lawyer.name,
                          style: GoogleFonts.philosopher(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lawyer.specialization,
                          style: GoogleFonts.outfit(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.business_center_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                firmName,
                                style: GoogleFonts.outfit(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _InfoChip(icon: Icons.star_rounded, label: '${lawyer.rating}'),
                            const SizedBox(width: 8),
                            _InfoChip(icon: Icons.history_edu_rounded, label: '${lawyer.experienceYears}y exp'),
                            const SizedBox(width: 8),
                            _InfoChip(icon: Icons.location_on_outlined, label: lawyer.location),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: AppColors.glassBorder, height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FEE PER MINUTE',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        AppFormatters.inr(lawyer.consultationFeePerMinute),
                        style: GoogleFonts.outfit(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 120,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: onConsultNow,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                      ).copyWith(
                        elevation: WidgetStateProperty.all(4),
                      ),
                      child: Text(
                        'Consult Now',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
