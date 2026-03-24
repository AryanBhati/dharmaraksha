import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/icons/app_icons.dart';
import '../providers/wallet_provider.dart';
import '../screens/wallet_screen.dart';
import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';

class WalletHeaderAction extends StatelessWidget {
  final bool enabled;

  const WalletHeaderAction({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<WalletProvider>().balance;

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: enabled
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const WalletScreen()),
                );
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: <Widget>[
              const Icon(AppIcons.wallet, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                AppFormatters.inr(balance),
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
