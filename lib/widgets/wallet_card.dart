import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';

class WalletCard extends StatelessWidget {
  final double balance;
  final VoidCallback onAddMoney;

  const WalletCard({
    super.key,
    required this.balance,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: <Color>[
            AppColors.walletGradientStart,
            AppColors.walletGradientEnd
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(Icons.account_balance_wallet_outlined,
                  color: Colors.white70),
              SizedBox(width: 8),
              Text(
                'DharamRaksha Wallet',
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppFormatters.inr(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Secure legal wallet for consultation and documentation charges',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.84), fontSize: 12.5),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 156,
            child: ElevatedButton.icon(
              onPressed: onAddMoney,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(42),
              ),
              label: const Text('Add Money'),
            ),
          ),
        ],
      ),
    );
  }
}
