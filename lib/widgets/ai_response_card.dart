import 'package:flutter/material.dart';

import '../models/ai_response.dart';

class AIResponseCard extends StatelessWidget {
  final AIResponse response;

  const AIResponseCard({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'AI Legal Guidance',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(response.problemUnderstanding),
          ],
        ),
      ),
    );
  }
}
