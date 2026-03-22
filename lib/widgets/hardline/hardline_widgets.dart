import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// A sharp-cornered card with 1px border, no shadow, no border-radius.
class HardlineCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? borderColor;
  final Color? backgroundColor;

  const HardlineCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? AppColors.surfaceDark : AppColors.surface),
        border: Border.all(
          color: borderColor ??
              (isDark ? AppColors.borderDark : AppColors.border),
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: child,
    );
  }
}

/// Section header with gold left border, caps label.
class HardlineSectionHeader extends StatelessWidget {
  final String title;
  final EdgeInsets padding;

  const HardlineSectionHeader({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.only(top: 24, bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            color: AppColors.accent,
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Hardline list tile with custom icon, chevron, and bottom divider.
class HardlineListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const HardlineListTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 24, color: AppColors.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.primary50,
                      size: 20,
                    ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            margin: const EdgeInsets.only(left: 40),
            color: AppColors.border.withValues(alpha: 0.6),
          ),
      ],
    );
  }
}

/// A scale-down button press animation wrapper.
class HardlinePressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const HardlinePressable({super.key, required this.child, this.onTap});

  @override
  State<HardlinePressable> createState() => _HardlinePressableState();
}

class _HardlinePressableState extends State<HardlinePressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}

/// Transaction row matching the hardline spec.
class HardlineTransactionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double amount;
  final bool isCredit;

  const HardlineTransactionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary10,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            '${isCredit ? '+' : '-'}₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontFamily: 'RobotoMono',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isCredit ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
