import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../widgets/wallet_header_action.dart';
import 'ai_guidance_screen.dart';
import '../../models/ai_response.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'role': 'ai',
      'text': 'Hello! I am your AI Legal Assistant. How can I help you understand your legal situation today?'
    }
  ];
  bool _isTyping = false;
  bool _showApplicableLaw = true;

  final List<String> _suggestions = [
    'Tenant eviction notice',
    'Filing for divorce',
    'Startup incorporation',
    'Check employment contract',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
    });
    _controller.clear();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add({
          'role': 'ai',
          'text': 'Based on Indian law, this appears to be a civil dispute. I can provide a step-by-step legal pathway.'
        });
      });
    });
  }

  void _showGuidance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AIGuidanceScreen(
          problem: 'Civil dispute overview',
          response: AIResponse(
            problemUnderstanding: 'You are facing a civil disagreement requiring arbitration or court intervention.',
            applicableLaws: ['Civil Procedure Code, 1908', 'Indian Contract Act, 1872'],
            legalPathwaySteps: ['Notice period', 'Mediation', 'Filing suit'],
            requiredDocuments: ['Identity Proof', 'Contract copies', 'Communication records'],
            recommendedLawyerType: 'Civil Litigation Lawyer',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Legal Assistant', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('🟢 Online • Verified AI Models', style: GoogleFonts.inter(fontSize: 10, color: AppColors.success)),
          ],
        ),
        actions: [
          const WalletHeaderAction(),
          Switch(
            value: _showApplicableLaw,
            onChanged: (val) => setState(() => _showApplicableLaw = val),
            activeThumbColor: AppColors.primary,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_showApplicableLaw)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: AppColors.primary.withOpacity(0.05),
                child: Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'AI will cite applicable Indian laws for every query.',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return _buildTypingIndicator(theme);
                  }
                  final msg = _messages[index];
                  final isAi = msg['role'] == 'ai';
                  return _buildMessageBubble(msg['text']!, isAi, theme);
                },
              ),
            ),
            _buildSuggestions(theme),
            _buildInputField(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isAi, ThemeData theme) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isAi ? theme.colorScheme.surface : AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isAi ? 4 : 20),
            bottomRight: Radius.circular(isAi ? 20 : 4),
          ),
          border: isAi ? Border.all(color: theme.dividerColor) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAi)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, size: 14, color: AppColors.accent),
                  const SizedBox(width: 4),
                  Text('DharamRaksha AI', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accent)),
                ],
              ),
            if (isAi) const SizedBox(height: 6),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: isAi ? theme.textTheme.bodyLarge?.color : Colors.white,
                height: 1.4,
              ),
            ),
            if (isAi && _messages.length > 2 && text.contains('step-by-step'))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: OutlinedButton.icon(
                  onPressed: _showGuidance,
                  icon: const Icon(Icons.route_outlined, size: 16),
                  label: const Text('View Full Legal Pathway'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 14, color: AppColors.accent),
            const SizedBox(width: 8),
            Text('Analyzing case...', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondaryLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(ThemeData theme) {
    if (_messages.length > 1) return const SizedBox.shrink();
    
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(_suggestions[index], style: GoogleFonts.inter(fontSize: 12)),
              backgroundColor: theme.colorScheme.surface,
              side: BorderSide(color: theme.dividerColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () => _sendMessage(_suggestions[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mic_rounded, color: AppColors.primary),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.inter(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        hintText: 'Describe your legal problem...',
                        hintStyle: GoogleFonts.inter(color: AppColors.textTertiaryLight, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppColors.accent),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
