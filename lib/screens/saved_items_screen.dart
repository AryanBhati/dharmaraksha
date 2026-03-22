import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/mock_data.dart';
import '../widgets/aurora_background.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/wallet_header_action.dart';
import 'lawyer_profile_screen.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final savedLawyers = MockDataService.lawyers
        .where((lawyer) => user.savedLawyerIds.contains(lawyer.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
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
                title: const Text('Saved lawyers'),
                trailing: Text(
                  '${savedLawyers.length}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (savedLawyers.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'No saved lawyers yet. Bookmark profiles to see them here.'),
                ),
              ),
            ...savedLawyers.map(
              (lawyer) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(lawyer.imageUrl)),
                  title: Text(lawyer.name),
                  subtitle: Text(lawyer.specialization),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => LawyerProfileScreen(lawyer: lawyer)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Card(
              child: ListTile(
                title: const Text('Saved documents'),
                subtitle: Text('${user.savedDocumentIds.length} item(s)'),
                trailing: const Icon(Icons.description_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
