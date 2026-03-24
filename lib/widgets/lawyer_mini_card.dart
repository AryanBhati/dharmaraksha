import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../models/lawyer.dart';
import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';
import '../screens/lawyers/lawyer_profile_screen.dart';

class LawyerMiniCard extends StatelessWidget {
  final Lawyer lawyer;
  final String firmName;

  const LawyerMiniCard({
    super.key,
    required this.lawyer,
    required this.firmName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border.withValues(alpha: 0.5),
        ),
        gradient: LinearGradient(
          colors: isDark 
              ? [AppColors.surfaceDark, AppColors.surfaceDark.withValues(alpha: 0.8)]
              : [Theme.of(context).colorScheme.surface, AppColors.primary10.withValues(alpha: 0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LawyerProfileScreen(lawyer: lawyer),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(lawyer.imageUrl),
                        ),
                      ),
                      if (lawyer.introVideoUrl != null)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: InkWell(
                            onTap: () {
                              // Play intro video logic
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: _buildStatusIndicator(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lawyer.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lawyer.specialization,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white60 : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accent, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        lawyer.rating.toString(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${AppFormatters.inr(lawyer.consultationFeePerMinute)}/m',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (lawyer.hasFreeFirstMessage)
              Positioned(
                top: 12,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'FREE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color statusColor;
    bool shouldPulse = false;

    switch (lawyer.status.toLowerCase()) {
      case 'online':
        statusColor = AppColors.success;
        shouldPulse = true;
        break;
      case 'busy':
        statusColor = AppColors.warning;
        shouldPulse = true;
        break;
      default:
        statusColor = Colors.grey;
    }

    final indicator = Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: statusColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );

    if (shouldPulse) {
      return Pulse(
        infinite: true,
        duration: const Duration(milliseconds: 1500),
        child: indicator,
      );
    }

    return indicator;
  }
}
