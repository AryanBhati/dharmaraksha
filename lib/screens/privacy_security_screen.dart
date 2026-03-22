import 'package:flutter/material.dart';

import '../widgets/aurora_background.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/wallet_header_action.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _biometricLock = false;
  bool _sessionPin = true;
  bool _analyticsSharing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
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
                    value: _biometricLock,
                    onChanged: (value) =>
                        setState(() => _biometricLock = value),
                    title: const Text('Biometric app lock'),
                    subtitle: const Text(
                        'Require fingerprint/face unlock for app access'),
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    value: _sessionPin,
                    onChanged: (value) => setState(() => _sessionPin = value),
                    title: const Text('Session protection PIN'),
                    subtitle: const Text(
                        'Prompt PIN before wallet or consultation payments'),
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    value: _analyticsSharing,
                    onChanged: (value) =>
                        setState(() => _analyticsSharing = value),
                    title: const Text('Anonymous analytics sharing'),
                    subtitle: const Text(
                        'Help improve recommendations with anonymous usage patterns'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Download my data'),
                    subtitle:
                        const Text('Export consultation and wallet records'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Data export request queued (demo).')),
                      );
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    title: const Text('Delete account'),
                    subtitle: const Text('Permanently remove account and data'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Account deletion flow is disabled in demo.')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
