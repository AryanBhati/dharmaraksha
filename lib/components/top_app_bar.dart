import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/wallet_header_action.dart';

class GlobalTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlobalTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        'DharamRaksha',
        style: GoogleFonts.philosopher(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      actions: const [
        WalletHeaderAction(),
        SizedBox(width: 8),
        ProfileAvatar(radius: 18),
        SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
