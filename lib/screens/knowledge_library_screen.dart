import 'package:flutter/material.dart';

import '../models/legal_book.dart';
import '../services/mock_data.dart';
import '../widgets/animated_reveal.dart';
import '../widgets/aurora_background.dart';
import '../widgets/knowledge_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/wallet_header_action.dart';
import 'book_reader_screen.dart';

class KnowledgeLibraryScreen extends StatefulWidget {
  const KnowledgeLibraryScreen({super.key});

  @override
  State<KnowledgeLibraryScreen> createState() => _KnowledgeLibraryScreenState();
}

class _KnowledgeLibraryScreenState extends State<KnowledgeLibraryScreen> {
  String _query = '';
  String _selectedCategory = 'All';

  List<String> get _categories {
    final categories = <String>{
      'All',
      ...MockDataService.legalBooks.map((book) => book.category),
    };
    final sorted = categories.where((category) => category != 'All').toList()
      ..sort();
    return <String>['All', ...sorted];
  }

  @override
  Widget build(BuildContext context) {
    final filtered = MockDataService.legalBooks.where((book) {
      final matchesCategory =
          _selectedCategory == 'All' || book.category == _selectedCategory;
      final q = _query.toLowerCase();
      final matchesQuery = q.isEmpty ||
          book.title.toLowerCase().contains(q) ||
          book.description.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Library'),
        actions: const <Widget>[
          WalletHeaderAction(),
          ProfileAvatar(),
        ],
      ),
      body: AuroraBackground(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Search legal books and references',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final category = _categories[index];
                  return ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (_) =>
                        setState(() => _selectedCategory = category),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final book = filtered[index];
                  return AnimatedReveal(
                    delayMs: index < 8 ? index * 70 : 0,
                    child: KnowledgeCard(
                      book: book,
                      onTap: () => _openBook(context, book),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBook(BuildContext context, LegalBook book) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => BookReaderScreen(book: book),
      ),
    );
  }
}
