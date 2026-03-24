import 'package:flutter/material.dart';

import '../components/top_app_bar.dart';
import '../components/bottom_nav_bar.dart';
import 'home/home_screen.dart';
import 'lawyers/lawyer_listing_screen.dart';
import 'firms/law_firm_listing_screen.dart';
import 'library/knowledge_library_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  final List<Widget> _tabs = const <Widget>[
    HomeScreen(),
    LawyerListingScreen(),
    LawFirmListingScreen(),
    KnowledgeLibraryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _tabs.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const GlobalTopAppBar(),
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: GlobalBottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
