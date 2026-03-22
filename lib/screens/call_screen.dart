import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/lawyer.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';

class CallScreen extends StatefulWidget {
  final Lawyer lawyer;
  final bool isVideo;

  const CallScreen({
    super.key,
    required this.lawyer,
    this.isVideo = false,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with TickerProviderStateMixin {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isMuted = false;
  bool _isSpeaker = false;
  bool _isCameraOff = false;
  bool _isConnecting = true;
  late AnimationController _pulseController;

  double get _rate => widget.isVideo
      ? widget.lawyer.consultationFeeVideo
      : widget.lawyer.consultationFeeVoice;

  double get _currentCost => (_elapsedSeconds / 60) * _rate;

  String get _formattedDuration {
    final m = _elapsedSeconds ~/ 60;
    final s = _elapsedSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Simulate connection delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isConnecting = false);
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsedSeconds++);
    });
  }

  void _endCall() {
    _timer?.cancel();
    context.read<WalletProvider>().deductBalance(
          _currentCost,
          title: '${widget.isVideo ? 'Video' : 'Voice'} call with ${widget.lawyer.name}',
        );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.success),
            ),
            const SizedBox(width: 12),
            const Text('Call Ended'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InfoRow(label: 'Duration', value: _formattedDuration),
            _InfoRow(label: 'Rate', value: '${AppFormatters.inr(_rate)}/min'),
            const Divider(),
            _InfoRow(
              label: 'Amount Charged',
              value: AppFormatters.inr(_currentCost),
              isBold: true,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // call screen
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Lawyer avatar with pulse
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + (_pulseController.value * 0.08);
                return Transform.scale(
                  scale: _isConnecting ? scale : 1.0,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isConnecting ? Colors.white24 : AppColors.success,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(widget.lawyer.imageUrl),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.lawyer.name,
              style: GoogleFonts.philosopher(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.lawyer.specialization,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 24),
            // Status
            Text(
              _isConnecting ? 'Connecting...' : _formattedDuration,
              style: GoogleFonts.robotoMono(
                fontSize: _isConnecting ? 16 : 36,
                fontWeight: FontWeight.bold,
                color: _isConnecting ? Colors.white38 : Colors.white,
                letterSpacing: 2,
              ),
            ),
            if (!_isConnecting) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppFormatters.inr(_currentCost),
                  style: GoogleFonts.robotoMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
            const Spacer(flex: 3),
            // Controls
            if (widget.isVideo)
              _buildVideoControls()
            else
              _buildVoiceControls(),
            const SizedBox(height: 32),
            // End call
            GestureDetector(
              onTap: _endCall,
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x44FF0000),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.call_end_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ControlButton(
          icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
          label: _isMuted ? 'Unmute' : 'Mute',
          isActive: _isMuted,
          onTap: () => setState(() => _isMuted = !_isMuted),
        ),
        const SizedBox(width: 32),
        _ControlButton(
          icon: _isSpeaker ? Icons.volume_up_rounded : Icons.volume_down_rounded,
          label: 'Speaker',
          isActive: _isSpeaker,
          onTap: () => setState(() => _isSpeaker = !_isSpeaker),
        ),
      ],
    );
  }

  Widget _buildVideoControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ControlButton(
          icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
          label: _isMuted ? 'Unmute' : 'Mute',
          isActive: _isMuted,
          onTap: () => setState(() => _isMuted = !_isMuted),
        ),
        const SizedBox(width: 24),
        _ControlButton(
          icon: _isCameraOff
              ? Icons.videocam_off_rounded
              : Icons.videocam_rounded,
          label: _isCameraOff ? 'Camera On' : 'Camera Off',
          isActive: _isCameraOff,
          onTap: () => setState(() => _isCameraOff = !_isCameraOff),
        ),
        const SizedBox(width: 24),
        _ControlButton(
          icon: _isSpeaker ? Icons.volume_up_rounded : Icons.volume_down_rounded,
          label: 'Speaker',
          isActive: _isSpeaker,
          onTap: () => setState(() => _isSpeaker = !_isSpeaker),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          )),
          Text(value, style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppColors.primary : null,
          )),
        ],
      ),
    );
  }
}
