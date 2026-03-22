import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/consultation_mode.dart';
import '../models/lawyer.dart';
import '../providers/user_provider.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/app_formatters.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/wallet_header_action.dart';
import 'wallet_screen.dart';

class ConsultationScreen extends StatefulWidget {
  final Lawyer lawyer;
  final ConsultationMode mode;

  const ConsultationScreen({
    super.key,
    required this.lawyer,
    required this.mode,
  });

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _started = false;

  double get _rate => widget.lawyer.consultationFeePerMinute * widget.mode.feeMultiplier();
  double get _currentCost => (_elapsed.inSeconds / 60).ceil() * _rate;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startConsultation() {
    final wallet = context.read<WalletProvider>();
    if (!wallet.canAfford(_rate)) {
      _showInsufficientBalance();
      return;
    }

    setState(() => _started = true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  void _endConsultation() {
    final wallet = context.read<WalletProvider>();
    final sessionCost = _currentCost;
    
    _timer?.cancel();
    _timer = null;
    
    if (sessionCost > 0) {
      wallet.deductBalance(
        sessionCost,
        title: '${widget.mode.label} consultation - ${widget.lawyer.name}',
      );
      context.read<UserProvider>().incrementConsultationCount();
    }

    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius)),
        title: Text('Consultation Completed', style: GoogleFonts.philosopher(fontWeight: FontWeight.bold)),
        content: Text(
          'Session duration ${_formatDuration(_elapsed)}. Charged ${AppFormatters.inr(sessionCost)} from your wallet.',
          style: GoogleFonts.outfit(),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.mode.label,
      actions: const [
        WalletHeaderAction(),
        SizedBox(width: 8),
      ],
      body: Column(
        children: <Widget>[
          // Header info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  widget.lawyer.name,
                  style: GoogleFonts.philosopher(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _MetaPill(
                      icon: Icons.timer_rounded,
                      text: _formatDuration(_elapsed),
                      isActive: _started,
                    ),
                    const SizedBox(width: 12),
                    _MetaPill(
                      icon: Icons.payments_rounded,
                      text: AppFormatters.inr(_currentCost),
                      isActive: _started,
                      isAccent: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(child: _buildConsultationBody()),
          
          // Action button
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.glassBorder)),
            ),
            child: _started
                ? SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ).copyWith(
                        elevation: WidgetStateProperty.all(8),
                      ),
                      onPressed: _endConsultation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.call_end_rounded),
                          const SizedBox(width: 8),
                          Text('End Consultation', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _startConsultation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_arrow_rounded),
                          const SizedBox(width: 8),
                          Text('Start Consultation', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationBody() {
    switch (widget.mode) {
      case ConsultationMode.chat:
        return _ChatView(started: _started);
      case ConsultationMode.voice:
        return _VoiceView(started: _started);
      case ConsultationMode.video:
        return _VideoView(started: _started);
    }
  }

  void _showInsufficientBalance() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Insufficient Balance',
                style: GoogleFonts.philosopher(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 12),
            Text(
              'You need at least ${AppFormatters.inr(_rate)} to start this consultation.',
              style: GoogleFonts.outfit(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              children: [100, 200, 500].map((amount) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<WalletProvider>().addMoney(amount.toDouble());
                      Navigator.pop(ctx);
                    },
                    child: Text('+${amount}'),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (_) => const WalletScreen()),
                  );
                },
                child: const Text('Go to Wallet'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours.toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isActive;
  final bool isAccent;

  const _MetaPill({
    required this.icon,
    required this.text,
    this.isActive = false,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAccent ? AppColors.accent : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.12) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? color.withOpacity(0.3) : AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: isActive ? color : AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: isActive ? color : AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  final bool started;

  const _ChatView({required this.started});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: const <Widget>[
              _Bubble(
                text: 'Namaste. Please share your key documents and timeline of events.',
                isLawyer: true,
              ),
              _Bubble(
                text: 'I have salary slips and email records from the HR.',
                isLawyer: false,
              ),
              _Bubble(
                text: 'Great. We can begin with drafting a legal notice today.',
                isLawyer: true,
              ),
            ],
          ),
        ),
        if (started)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: TextField(
                style: GoogleFonts.outfit(),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 14),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.send_rounded, color: AppColors.accent),
                ),
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Start session to enable chat',
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}

class _VoiceView extends StatelessWidget {
  final bool started;

  const _VoiceView({required this.started});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: started ? AppColors.accent.withOpacity(0.1) : AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: started ? AppColors.accent : AppColors.glassBorder, width: 2),
              boxShadow: started
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ]
                  : null,
            ),
            child: Icon(
              started ? Icons.mic_rounded : Icons.mic_none_rounded,
              size: 56,
              color: started ? AppColors.accent : AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            started ? 'Consultation in Progress' : 'Ready to Connect',
            style: GoogleFonts.philosopher(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Secure and encrypted voice channel',
            style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _VideoView extends StatelessWidget {
  final bool started;

  const _VideoView({required this.started});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D1A),
                borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
                border: Border.all(color: AppColors.glassBorder),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam_off_rounded, size: 64, color: AppColors.textSecondary.withOpacity(0.1)),
                  const SizedBox(height: 20),
                  Text(
                    started ? 'Waiting for Video Stream...' : 'Camera Preview Disabled',
                    style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 110,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'You',
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool isLawyer;

  const _Bubble({required this.text, required this.isLawyer});

  @override
  Widget build(BuildContext context) {
    final alignment = isLawyer ? Alignment.centerLeft : Alignment.centerRight;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isLawyer ? AppColors.surface : AppColors.accent,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isLawyer ? 4 : 20),
            bottomRight: Radius.circular(isLawyer ? 20 : 4),
          ),
          border: isLawyer ? Border.all(color: AppColors.glassBorder) : null,
          boxShadow: isLawyer
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            color: isLawyer ? AppColors.textPrimary : Colors.white,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
