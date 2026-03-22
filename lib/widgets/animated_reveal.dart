import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedReveal extends StatefulWidget {
  final Widget child;
  final int delayMs;
  final Offset beginOffset;

  const AnimatedReveal({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.beginOffset = const Offset(0, 0.08),
  });

  @override
  State<AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<AnimatedReveal> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(milliseconds: widget.delayMs), () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : widget.beginOffset,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
