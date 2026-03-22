import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../widgets/hardline/hardline_widgets.dart';
import 'lawyer_appointments_screen.dart';
import 'lawyer_dashboard_screen.dart';
import 'lawyer_wallet_screen.dart';

class LawyerNavigationScreen extends StatefulWidget {
  const LawyerNavigationScreen({super.key});

  @override
  State<LawyerNavigationScreen> createState() => _LawyerNavigationScreenState();
}

class _LawyerNavigationScreenState extends State<LawyerNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    LawyerDashboardScreen(),
    LawyerAppointmentsScreen(),
    _LawyerChatsPlaceholder(),
    LawyerWalletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: AppColors.border),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          elevation: 0,
          backgroundColor: Colors.transparent,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month_rounded),
              label: 'Appoints',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: Icon(Icons.chat_bubble_rounded),
              label: 'Chats',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Wallet',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Lawyer Chats Placeholder ─────────────────────────────────────────────────

class _LawyerChatsPlaceholder extends StatelessWidget {
  const _LawyerChatsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
        title: Text(
          'Client Chats',
          style: GoogleFonts.merriweather(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ChatItem(name: 'Arjun Mehta', lastMsg: 'I need help with the documentation', time: '2m ago', unread: 2),
          _ChatItem(name: 'Priya Nair', lastMsg: 'Thank you for the advice!', time: '15m ago', unread: 0),
          _ChatItem(name: 'Rohan Gupta', lastMsg: 'Can we schedule a follow-up?', time: '1h ago', unread: 1),
        ],
      ),
    );
  }
}

class _ChatItem extends StatelessWidget {
  final String name;
  final String lastMsg;
  final String time;
  final int unread;

  const _ChatItem({
    required this.name,
    required this.lastMsg,
    required this.time,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    return HardlineCard(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary10,
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.center,
                child: Text(
                  name[0],
                  style: GoogleFonts.merriweather(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (unread > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$unread',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  lastMsg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: unread > 0
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
                fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
