import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';
import '../../theme/app_colors.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final Function(String)? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCredit = transaction.type == TransactionType.credit;
    final isRefund = transaction.type == TransactionType.refund;

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) => onDelete?.call(transaction.id),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              _buildIcon(isCredit, isRefund),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildCategoryChip(context, isDark),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMM dd, hh:mm a').format(transaction.dateTime),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isCredit || isRefund ? '+' : '-'}₹${transaction.amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: isCredit || isRefund ? AppColors.success : AppColors.error,
                    ),
                  ),
                  if (isRefund)
                    const Text(
                      'Refunded',
                      style: TextStyle(fontSize: 10, color: AppColors.info, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool isCredit, bool isRefund) {
    Color bgColor;
    IconData icon;
    Color iconColor;

    if (isRefund) {
      bgColor = AppColors.info.withValues(alpha: 0.1);
      icon = Icons.replay_rounded;
      iconColor = AppColors.info;
    } else if (isCredit) {
      bgColor = AppColors.success.withValues(alpha: 0.1);
      icon = Icons.south_west_rounded;
      iconColor = AppColors.success;
    } else {
      bgColor = AppColors.error.withValues(alpha: 0.1);
      icon = Icons.north_east_rounded;
      iconColor = AppColors.error;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  Widget _buildCategoryChip(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        transaction.category,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.primaryDarkTheme : AppColors.primary,
        ),
      ),
    );
  }
}
