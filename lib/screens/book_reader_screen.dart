import 'package:flutter/material.dart';

import '../models/legal_book.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_reveal.dart';

class BookReaderScreen extends StatefulWidget {
  final LegalBook book;

  const BookReaderScreen({super.key, required this.book});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  double _fontSize = 17;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFAF1),
        foregroundColor: AppColors.textPrimary,
        title: Text(
          widget.book.category,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.text_decrease_rounded),
            onPressed: () =>
                setState(() => _fontSize = (_fontSize - 1).clamp(13, 24)),
          ),
          IconButton(
            icon: const Icon(Icons.text_increase_rounded),
            onPressed: () =>
                setState(() => _fontSize = (_fontSize + 1).clamp(13, 24)),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmarked for later reading')),
              );
            },
          ),
        ],
      ),
      body: AnimatedReveal(
        delayMs: 60,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.book.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'By ${widget.book.author}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const Divider(height: 30),
                Text(
                  widget.book.content,
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: AppColors.textPrimary,
                    height: 1.75,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
