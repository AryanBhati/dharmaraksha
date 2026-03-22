import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/aurora_background.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/wallet_header_action.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _consultationUpdates = true;
  bool _walletAlerts = true;
  bool _knowledgeUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: const <Widget>[
          WalletHeaderAction(),
          ProfileAvatar(),
        ],
      ),
      body: AuroraBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    value: _consultationUpdates,
                    onChanged: (value) =>
                        setState(() => _consultationUpdates = value),
                    title: const Text('Consultation updates'),
                    subtitle: const Text(
                        'Session reminders, lawyer responses, schedule changes'),
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    value: _walletAlerts,
                    onChanged: (value) => setState(() => _walletAlerts = value),
                    title: const Text('Wallet alerts'),
                    subtitle: const Text(
                        'Recharge confirmations and low balance warnings'),
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    value: _knowledgeUpdates,
                    onChanged: (value) =>
                        setState(() => _knowledgeUpdates = value),
                    title: const Text('Knowledge updates'),
                    subtitle: const Text(
                        'New legal explainers and library additions'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text('Recent Alerts',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            ...const <Widget>[
              _AlertTile(
                title: 'Your chat consultation starts in 30 minutes',
                subtitle: 'Today, 6:00 PM',
                icon: Icons.schedule_rounded,
              ),
              _AlertTile(
                title: 'Wallet credited successfully',
                subtitle: 'Yesterday, 10:12 AM',
                icon: Icons.account_balance_wallet_rounded,
              ),
              _AlertTile(
                title: 'New labour-law guide added to library',
                subtitle: '2 days ago',
                icon: Icons.auto_stories_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _AlertTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
