import 'package:flutter/material.dart';

import '../../services/mock_data.dart';
import '../../widgets/firm_card.dart';
import 'law_firm_profile_screen.dart';

class LawFirmListingScreen extends StatefulWidget {
  const LawFirmListingScreen({super.key});

  @override
  State<LawFirmListingScreen> createState() => _LawFirmListingScreenState();
}

class _LawFirmListingScreenState extends State<LawFirmListingScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final firms = MockDataService.lawFirms
        .where(
          (firm) =>
              _query.isEmpty ||
              firm.name.toLowerCase().contains(_query.toLowerCase()) ||
              firm.city.toLowerCase().contains(_query.toLowerCase()) ||
              firm.practiceAreas
                  .join(' ')
                  .toLowerCase()
                  .contains(_query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Search firms by city or practice area',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            Expanded(
              child: firms.isEmpty
                  ? const Center(
                      child: Text(
                        'No firms found. Try another search.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: firms.length,
                      itemBuilder: (_, index) => FirmCard(
                        firm: firms[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  LawFirmProfileScreen(firm: firms[index]),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
