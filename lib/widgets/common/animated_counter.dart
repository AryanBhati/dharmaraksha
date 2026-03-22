import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final String value;
  final TextStyle style;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _targetValue = 0;
  String _prefix = '';
  String _suffix = '';
  int _decimalPlaces = 0;

  @override
  void initState() {
    super.initState();
    _parseValue();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: _targetValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
    );
    _controller.forward();
  }

  void _parseValue() {
    final numericRegex = RegExp(r'(\d+\.?\d*)');
    final match = numericRegex.firstMatch(widget.value);
    
    if (match != null) {
      final numericPart = match.group(0)!;
      _targetValue = double.tryParse(numericPart) ?? 0;
      
      if (numericPart.contains('.')) {
        _decimalPlaces = numericPart.split('.')[1].length;
      } else {
        _decimalPlaces = 0;
      }
      
      _prefix = widget.value.substring(0, match.start);
      _suffix = widget.value.substring(match.end);
    } else {
      _targetValue = 0;
      _prefix = '';
      _suffix = widget.value;
    }
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final oldTargetValue = _targetValue;
      _parseValue();
      _animation = Tween<double>(begin: oldTargetValue, end: _targetValue).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final displayValue = _animation.value.toStringAsFixed(_decimalPlaces);
        return Text(
          '$_prefix$displayValue$_suffix',
          style: widget.style,
        );
      },
    );
  }
}
