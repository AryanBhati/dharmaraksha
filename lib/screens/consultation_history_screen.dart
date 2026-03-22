import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/user_provider.dart';
import '../providers/wallet_provider.dart';
import '../utils/app_formatters.dart';
import '../widgets/aurora_background.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/wallet_header_action.dart';

class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final history = context
        .watch<WalletProvider>()
        .transactions
        .where((Transaction tx) =>
            tx.type == TransactionType.debit &&
            tx.description.toLowerCase().contains('consultation'))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation History'),
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
              child: ListTile(
                title: const Text('Completed consultations'),
                trailing: Text(
                  '${user.consultationsCompleted}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (history.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No consultation transactions yet.'),
                ),
              ),
            ...history.map(
              (tx) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(tx.description),
                  subtitle: Text(AppFormatters.shortDate(tx.timestamp)),
                  trailing: Text(
                    AppFormatters.inr(tx.amount),
                    style: const TextStyle(fontWeight: FontWeight.w700),
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
