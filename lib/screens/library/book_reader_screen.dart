import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/legal_book.dart';
import '../../theme/app_colors.dart';
import '../../widgets/animated_reveal.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final readerBackground = isDark ? theme.colorScheme.surface : const Color(0xFFFFFAF1);
    final readerForeground = isDark ? Colors.white : AppColors.textPrimary;
    
    return Scaffold(
      backgroundColor: readerBackground,
      appBar: AppBar(
        backgroundColor: readerBackground,
        foregroundColor: readerForeground,
        elevation: 0,
        title: Text(
          widget.book.category,
          style: GoogleFonts.inter(fontSize: 14, color: isDark ? Colors.white70 : AppColors.textSecondaryLight),
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
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: theme.dividerColor),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.book.title,
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'By ${widget.book.author}',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                    fontSize: 14,
                  ),
                ),
                Divider(height: 30, color: theme.dividerColor),
                Text(
                  widget.book.content,
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: readerForeground,
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
