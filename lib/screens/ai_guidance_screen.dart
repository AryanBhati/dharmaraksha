import 'package:flutter/material.dart';

import '../models/ai_response.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_reveal.dart';
import '../widgets/aurora_background.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/wallet_header_action.dart';
import 'main_navigation_screen.dart';

class AIGuidanceScreen extends StatelessWidget {
  final String problem;
  final AIResponse response;

  const AIGuidanceScreen({
    super.key,
    required this.problem,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Legal Pathway'),
        actions: const <Widget>[
          WalletHeaderAction(),
          ProfileAvatar(),
        ],
      ),
      body: AuroraBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            AnimatedReveal(
              delayMs: 40,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: AppColors.heroGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Case summary',
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      problem,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedReveal(
              delayMs: 80,
              child: _SectionCard(
                title: '1. Problem Understanding',
                icon: Icons.lightbulb_circle_rounded,
                child: Text(response.problemUnderstanding),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedReveal(
              delayMs: 120,
              child: _SectionCard(
                title: '2. Applicable Law',
                icon: Icons.menu_book_rounded,
                child: Column(
                  children: response.applicableLaws
                      .map(
                        (law) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.balance_rounded, size: 18),
                          title: Text(law),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedReveal(
              delayMs: 160,
              child: _SectionCard(
                title: '3. Legal Pathway',
                icon: Icons.route_rounded,
                child: Column(
                  children: List<Widget>.generate(
                    response.legalPathwaySteps.length,
                    (index) => _StepTile(
                      index: index + 1,
                      text: response.legalPathwaySteps[index],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedReveal(
              delayMs: 200,
              child: _SectionCard(
                title: '4. Documents Required',
                icon: Icons.fact_check_rounded,
                child: Column(
                  children: response.requiredDocuments
                      .map(
                        (item) => CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          value: false,
                          onChanged: (_) {},
                          title: Text(item),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedReveal(
              delayMs: 240,
              child: _SectionCard(
                title: '5. Recommended Lawyer Type',
                icon: Icons.support_agent_rounded,
                child: Text(
                  response.recommendedLawyerType,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedReveal(
              delayMs: 280,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Need specialist help now?',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 19),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Connect with verified lawyers matched to this pathway and issue type.',
                      ),
                      const SizedBox(height: 14),
                      PrimaryButton(
                        label: 'Find Matching Lawyers',
                        icon: Icons.person_search_rounded,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  const MainNavigationScreen(initialIndex: 1),
                            ),
                            (route) => route.isFirst,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int index;
  final String text;

  const _StepTile({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
