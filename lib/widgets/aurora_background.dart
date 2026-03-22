import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AuroraBackground extends StatelessWidget {
  final Widget child;
  final bool applySafeArea;

  const AuroraBackground({
    super.key,
    required this.child,
    this.applySafeArea = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = applySafeArea ? SafeArea(child: child) : child;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.auroraGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: -160,
          left: -80,
          child: _GlowOrb(
            size: 300,
            color: AppColors.primary.withValues(alpha: 0.16),
          ),
        ),
        Positioned(
          top: 120,
          right: -100,
          child: _GlowOrb(
            size: 260,
            color: AppColors.secondary.withValues(alpha: 0.14),
          ),
        ),
        Positioned(
          bottom: -120,
          right: -40,
          child: _GlowOrb(
            size: 280,
            color: AppColors.accent.withValues(alpha: 0.18),
          ),
        ),
        content,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[color, Colors.transparent],
            stops: const <double>[0, 1],
          ),
        ),
      ),
    );
  }
}
