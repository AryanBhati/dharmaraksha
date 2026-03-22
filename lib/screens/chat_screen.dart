import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/chat_message.dart';
import '../models/lawyer.dart';
import '../providers/consultation_provider.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/app_formatters.dart';
import '../widgets/app_scaffold.dart';

class ChatScreen extends StatefulWidget {
  final Lawyer lawyer;

  const ChatScreen({super.key, required this.lawyer});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _costTimer;
  int _elapsedSeconds = 0;
  double _currentCost = 0;
  bool _isSessionActive = true;

  double get _ratePerMinute => widget.lawyer.consultationFeeChat;

  @override
  void initState() {
    super.initState();
    _startCostTimer();
  }

  void _startCostTimer() {
    _costTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_isSessionActive) return;
      setState(() {
        _elapsedSeconds++;
        _currentCost = (_elapsedSeconds / 60) * _ratePerMinute;
      });
    });
  }

  String get _formattedDuration {
    final m = _elapsedSeconds ~/ 60;
    final s = _elapsedSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final msg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user_1',
      receiverId: widget.lawyer.id,
      content: text,
      type: 'text',
      timestamp: DateTime.now(),
    );

    context.read<ConsultationProvider>().sendMessage(widget.lawyer.id, msg);
    _msgController.clear();

    // Simulate lawyer response
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || !_isSessionActive) return;
      final reply = ChatMessage(
        id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
        senderId: widget.lawyer.id,
        receiverId: 'user_1',
        content: _getMockReply(text),
        type: 'text',
        timestamp: DateTime.now(),
        isRead: true,
      );
      context.read<ConsultationProvider>().sendMessage(widget.lawyer.id, reply);
    });

    _scrollToBottom();
  }

  String _getMockReply(String userMsg) {
    final lower = userMsg.toLowerCase();
    if (lower.contains('fir') || lower.contains('police')) {
      return 'For filing an FIR, you need to visit the nearest police station. I can guide you through the process step by step.';
    } else if (lower.contains('rent') || lower.contains('tenant')) {
      return 'Under the Rent Control Act, tenants have specific rights. Could you share your rental agreement for review?';
    } else if (lower.contains('divorce') || lower.contains('family')) {
      return 'Family law matters require careful handling. Let me understand your situation. Are there children involved?';
    }
    return 'I understand your concern. Can you provide more details so I can give you accurate legal guidance?';
  }

  void _endSession() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius)),
        title: Text('End Consultation?', style: GoogleFonts.philosopher(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SummaryRow(label: 'Duration', value: _formattedDuration),
            _SummaryRow(label: 'Rate', value: '${AppFormatters.inr(_ratePerMinute)}/min'),
            Divider(color: AppColors.glassBorder),
            _SummaryRow(
              label: 'Total Cost',
              value: AppFormatters.inr(_currentCost),
              isBold: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WalletProvider>().deductBalance(
                    _currentCost,
                    title: 'Chat with ${widget.lawyer.name}',
                  );
              setState(() => _isSessionActive = false);
              _costTimer?.cancel();
              Navigator.pop(context); // dialog
              Navigator.pop(context); // chat screen
            },
            child: const Text('End & Pay'),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _costTimer?.cancel();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConsultationProvider>();
    final messages = provider.activeChats[widget.lawyer.id] ?? [];

    return AppScaffold(
      title: widget.lawyer.name,
      actions: [
        // Live cost ticker
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accent.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, size: 14, color: AppColors.accent),
              const SizedBox(width: 4),
              Text(
                AppFormatters.inr(_currentCost),
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ],
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.senderId == 'user_1';
                return _ChatBubble(message: msg, isMe: isMe);
              },
            ),
          ),
          // Input bar
          Container(
            padding: EdgeInsets.fromLTRB(
              12, 12, 12, MediaQuery.of(context).padding.bottom + 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.glassBorder)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  color: AppColors.textSecondary,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSoft,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: TextField(
                      controller: _msgController,
                      style: GoogleFonts.outfit(fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          // End session button (Sacred Modern Style)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              border: Border(top: BorderSide(color: Colors.red.withOpacity(0.1))),
            ),
            child: TextButton.icon(
              onPressed: _endSession,
              icon: const Icon(Icons.call_end_rounded, size: 18, color: Colors.redAccent),
              label: Text(
                'End Consultation',
                style: GoogleFonts.outfit(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: 4,
              left: isMe ? 64 : 0,
              right: isMe ? 0 : 64,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.accent : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
              ),
              border: isMe ? null : Border.all(color: AppColors.glassBorder),
              boxShadow: isMe ? [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ] : null,
            ),
            child: Text(
              message.content,
              style: GoogleFonts.outfit(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                    size: 14,
                    color: message.isRead ? AppColors.accent : AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
            color: AppColors.textSecondary,
          )),
          Text(value, style: GoogleFonts.outfit(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize:isBold ? 18 : 14,
            color: isBold ? AppColors.accent : AppColors.textPrimary,
          )),
        ],
      ),
    );
  }
}
