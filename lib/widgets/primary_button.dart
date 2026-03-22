import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String? label;
  final String? text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PrimaryButton({
    super.key,
    this.label,
    this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel = label ?? text ?? '';
    final effectiveOnPressed = isLoading ? null : onPressed;
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor:
          (backgroundColor ?? AppColors.primary).withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );

    if (isLoading) {
      return ElevatedButton(
        onPressed: null,
        style: buttonStyle,
        child: const SizedBox(
          height: 22,
          width: 22,
          child:
              CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
        ),
      );
    }

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: effectiveOnPressed,
        style: buttonStyle,
        icon: Icon(icon, size: 18),
        label: Text(displayLabel),
      );
    }

    return ElevatedButton(
      onPressed: effectiveOnPressed,
      style: buttonStyle,
      child: Text(displayLabel),
    );
  }
}
