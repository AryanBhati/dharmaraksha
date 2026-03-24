import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/legal_book.dart';
import '../../services/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/book_card.dart';
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
    final theme = Theme.of(context);
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
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                style: GoogleFonts.inter(),
                decoration: InputDecoration(
                  hintText: 'Search Constitutional rights, IPC, CrPC...',
                  hintStyle: GoogleFonts.inter(color: AppColors.textTertiaryLight, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondaryLight),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  fillColor: Colors.transparent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return ActionChip(
                  label: Text(category, style: GoogleFonts.inter(fontSize: 13, color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color)),
                  backgroundColor: isSelected ? AppColors.primary : theme.colorScheme.surface,
                  side: BorderSide(color: isSelected ? AppColors.primary : theme.dividerColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  onPressed: () => setState(() => _selectedCategory = category),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: filtered.length,
              itemBuilder: (_, index) {
                final book = filtered[index];
                return BookCard(
                  book: book,
                  onTap: () => _openBook(context, book),
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
