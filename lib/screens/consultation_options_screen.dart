import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/consultation_mode.dart';
import '../models/lawyer.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';
import '../widgets/aurora_background.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/wallet_header_action.dart';
import 'consultation_screen.dart';
import 'wallet_screen.dart';

class ConsultationOptionsScreen extends StatelessWidget {
  final Lawyer lawyer;

  const ConsultationOptionsScreen({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(lawyer.name),
        actions: const <Widget>[
          WalletHeaderAction(),
          ProfileAvatar(),
        ],
      ),
      body: AuroraBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: <Color>[
                  AppColors.walletGradientStart,
                  AppColors.walletGradientEnd
                ]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.account_balance_wallet_rounded,
                      color: AppColors.accent, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Wallet Balance',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                      Text(
                        AppFormatters.inr(wallet.balance),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WalletScreen())),
                    child: const Text('Add Money',
                        style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('Choose Consultation Mode',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
            const SizedBox(height: 12),
            ...ConsultationMode.values.map(
              (mode) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ModeOptionTile(lawyer: lawyer, mode: mode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeOptionTile extends StatelessWidget {
  final Lawyer lawyer;
  final ConsultationMode mode;

  const _ModeOptionTile({required this.lawyer, required this.mode});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final fee = lawyer.consultationFeePerMinute * mode.feeMultiplier() * 10;
    final canAfford = wallet.canAfford(fee);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(mode.icon, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(mode.label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16)),
                ),
                Text('${AppFormatters.inr(fee)}/10 min',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 8),
            Text(mode.subtitle),
            const SizedBox(height: 10),
            PrimaryButton(
              label: canAfford ? 'Start ${mode.label}' : 'Recharge Wallet',
              backgroundColor: canAfford ? null : AppColors.warning,
              onPressed: () {
                if (!canAfford) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) => const WalletScreen()),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        ConsultationScreen(lawyer: lawyer, mode: mode),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
