import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: (isCredit ? AppColors.success : AppColors.error)
              .withValues(alpha: 0.12),
          child: Icon(
            isCredit ? Icons.south_west_rounded : Icons.north_east_rounded,
            color: isCredit ? AppColors.success : AppColors.error,
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(AppFormatters.shortDate(transaction.timestamp)),
        trailing: Text(
          '${isCredit ? '+' : '-'}${AppFormatters.inr(transaction.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isCredit ? AppColors.success : AppColors.error,
          ),
        ),
      ),
    );
  }
}
