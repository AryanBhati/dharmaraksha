import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../utils/app_formatters.dart';
import '../../widgets/hardline/hardline_widgets.dart';

class LawyerWalletScreen extends StatelessWidget {
  const LawyerWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const withdrawable = 42500.0;
    const totalEarned = 125750.0;
    const totalWithdrawn = 83250.0;

    final transactions = [
      _Txn(title: 'Payout to Bank', amount: -15000, date: 'Mar 18', status: 'Completed'),
      _Txn(title: 'Chat: Arjun Mehta', amount: 450, date: 'Mar 18', status: ''),
      _Txn(title: 'Video: Sneha Kapoor', amount: 1050, date: 'Mar 17', status: ''),
      _Txn(title: 'Payout to Bank', amount: -20000, date: 'Mar 15', status: 'Completed'),
      _Txn(title: 'Chat: Rohan Gupta', amount: 330, date: 'Mar 14', status: ''),
      _Txn(title: 'Call: Priya Nair', amount: 775, date: 'Mar 14', status: ''),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
        title: Text(
          'Earnings Wallet',
          style: GoogleFonts.merriweather(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Withdrawable Balance Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: AppColors.accent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WITHDRAWABLE BALANCE',
                    style: GoogleFonts.inter(
                      color: AppColors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppFormatters.inr(withdrawable),
                    style: GoogleFonts.robotoMono(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Withdrawal request submitted!')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.accent),
                        foregroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: Text(
                        'Withdraw to Bank',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Stats row ──
            Row(
              children: [
                Expanded(
                  child: HardlineCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Earned',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppFormatters.inr(totalEarned),
                          style: GoogleFonts.robotoMono(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: HardlineCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Withdrawn',
                          style: GoogleFonts.inter(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppFormatters.inr(totalWithdrawn),
                          style: GoogleFonts.robotoMono(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Transactions ──
            HardlineSectionHeader(title: 'Recent Transactions'),
            const SizedBox(height: 8),
            ...transactions.map((txn) {
              final isCredit = txn.amount > 0;
              return HardlineCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary10,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Icon(
                        isCredit
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: isCredit ? AppColors.success : AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title + date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            txn.title,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.primary),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                txn.date,
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              ),
                              if (txn.status.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.success),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    txn.status,
                                    style: GoogleFonts.inter(
                                        fontSize: 9,
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Amount
                    Text(
                      '${isCredit ? '+' : ''}${AppFormatters.inr(txn.amount.abs())}',
                      style: GoogleFonts.robotoMono(
                        fontWeight: FontWeight.w700,
                        color: isCredit ? AppColors.success : AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _Txn {
  final String title;
  final double amount;
  final String date;
  final String status;
  const _Txn(
      {required this.title,
      required this.amount,
      required this.date,
      required this.status});
}
