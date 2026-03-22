import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar;

  const AppScaffold({
    super.key,
    required this.title,
    this.actions,
    required this.body,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: AppBar(
        title: Text(title),
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.maybePop(context),
              )
            : null,
        actions: actions,
        // Ensure static behavior
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background.withOpacity(0.8),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.glassBorder, width: 0.5),
            ),
          ),
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
