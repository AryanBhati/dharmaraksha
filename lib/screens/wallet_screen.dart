import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/wallet_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../models/transaction.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/payment/payment_method_sheet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _showBalance = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      if (mounted) {
        context.read<WalletProvider>().refreshTransactions();
      }
    });
  }

  void _showAddMoney() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PaymentMethodSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'Wallet',
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: wallet.refreshTransactions,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // ── Balance Card ──
            _BalanceCard(
              balance: wallet.balance,
              showBalance: _showBalance,
              onToggle: () => setState(() => _showBalance = !_showBalance),
              onAddMoney: _showAddMoney,
              isLoading: wallet.state == WalletState.loading,
            ),
            const SizedBox(height: 24),

            // ── Quick Actions ──
            Row(
              children: [
                _QuickAction(
                  icon: Icons.add_rounded,
                  label: 'Add',
                  onTap: _showAddMoney,
                ),
                const SizedBox(width: 12),
                _QuickAction(
                  icon: Icons.history_rounded,
                  label: 'History',
                  onTap: () {},
                ),
                const SizedBox(width: 12),
                _QuickAction(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Transactions Header ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                TextButton(
                  onPressed: wallet.refreshTransactions,
                  child: Text(
                    'Refresh',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Transactions List ──
            _buildTransactionList(wallet, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(WalletProvider wallet, ThemeData theme) {
    if (wallet.state == WalletState.error) {
      return _buildMessage(
        theme,
        icon: Icons.error_outline_rounded,
        color: AppColors.error,
        text: wallet.errorMessage ?? 'Failed to load transactions.',
        action: TextButton(
          onPressed: wallet.refreshTransactions,
          child: const Text('Retry'),
        ),
      );
    }

    if (wallet.state == WalletState.loading && wallet.transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final txns = wallet.transactions;
    if (txns.isEmpty) {
      return _buildMessage(
        theme,
        icon: Icons.history_rounded,
        color: AppColors.primary,
        text: 'No transactions yet.',
      );
    }

    // Group by date
    final grouped = <String, List<Transaction>>{};
    for (final tx in txns) {
      final key = _dateLabel(tx.dateTime);
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8, left: 4),
              child: Text(
                entry.key.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
                border: Border.all(color: theme.dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: entry.value.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 68,
                  endIndent: 16,
                  color: theme.dividerColor,
                ),
                itemBuilder: (_, idx) {
                  final tx = entry.value[idx];
                  final isCredit = tx.type == TransactionType.credit;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isCredit ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isCredit ? Icons.add_rounded : Icons.remove_rounded,
                        size: 20,
                        color: isCredit ? AppColors.success : AppColors.error,
                      ),
                    ),
                    title: Text(
                      tx.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    subtitle: Text(
                      '${tx.category} • ${DateFormat('hh:mm a').format(tx.dateTime)}',
                      style: GoogleFonts.inter(color: AppColors.textSecondaryLight, fontSize: 13),
                    ),
                    trailing: Text(
                      '${isCredit ? '+' : '-'} ₹${tx.amount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCredit ? AppColors.success : theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMessage(ThemeData theme, {required IconData icon, required Color color, required String text, Widget? action}) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 20),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              action,
            ]
          ],
        ),
      ),
    );
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);
    if (date == today) return 'Today';
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('MMMM d, yyyy').format(dt);
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final bool showBalance;
  final bool isLoading;
  final VoidCallback onToggle;
  final VoidCallback onAddMoney;

  const _BalanceCard({
    required this.balance,
    required this.showBalance,
    required this.isLoading,
    required this.onToggle,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withBlue(100),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.white.withValues(alpha: 0.12), Colors.transparent],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'AVAILABLE BALANCE',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: onToggle,
                        child: Icon(
                          showBalance ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 18,
                        ),
                      ),
                      const Spacer(),
                      if (isLoading)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: balance),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, val, child) {
                      return Text(
                        showBalance ? '₹ ${val.toStringAsFixed(2)}' : '₹ ••••••',
                        style: GoogleFonts.poppins(
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: onAddMoney,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add Money',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_outward_rounded, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
          border: Border.all(color: theme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 24, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
