import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/profile_screen.dart';
import '../theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final bool navigateToProfile;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.navigateToProfile = true,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final initials = user.name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: navigateToProfile
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              }
            : null,
        child: Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: <Color>[
                AppColors.primary.withValues(alpha: 0.9),
                AppColors.secondary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: AppColors.backgroundSoft,
            backgroundImage: user.profileImageUrl.isNotEmpty
                ? NetworkImage(user.profileImageUrl)
                : null,
            child: user.profileImageUrl.isEmpty
                ? Text(
                    initials.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
