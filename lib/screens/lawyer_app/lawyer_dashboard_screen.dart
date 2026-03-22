import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_formatters.dart';
import '../../widgets/hardline/hardline_widgets.dart';

class LawyerDashboardScreen extends StatefulWidget {
  const LawyerDashboardScreen({super.key});

  @override
  State<LawyerDashboardScreen> createState() => _LawyerDashboardScreenState();
}

class _LawyerDashboardScreenState extends State<LawyerDashboardScreen> {
  bool _isOnline = true;

  // Mock data
  final double _todayEarnings = 2850.0;
  final double _monthEarnings = 48750.0;
  final double _withdrawable = 42500.0;
  final int _activeChats = 3;
  final int _pendingAppointments = 5;
  final int _totalClients = 87;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
        title: Text(
          'Dashboard',
          style: GoogleFonts.merriweather(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
        centerTitle: false,
        actions: [
          // Online/Offline toggle — hardline style
          GestureDetector(
            onTap: () => setState(() => _isOnline = !_isOnline),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isOnline ? AppColors.success : AppColors.border,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isOnline ? AppColors.success : AppColors.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isOnline ? 'Online' : 'Offline',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _isOnline ? AppColors.success : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Dark mode toggle
          IconButton(
            onPressed: themeProvider.toggleTheme,
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Earnings Card (hardline: primary bg, gold accents) ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: AppColors.accent, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THIS MONTH',
                    style: GoogleFonts.inter(
                      color: AppColors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppFormatters.inr(_monthEarnings),
                    style: GoogleFonts.robotoMono(
                      fontSize: isMobile ? 28 : 34,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _EarningsPill(
                          label: 'Today',
                          value: AppFormatters.inr(_todayEarnings)),
                      const SizedBox(width: 12),
                      _EarningsPill(
                          label: 'Withdrawable',
                          value: AppFormatters.inr(_withdrawable)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Quick Stats ──
            Row(
              children: [
                _StatTile(
                  icon: Icons.chat_bubble_rounded,
                  label: 'Active\nChats',
                  value: '$_activeChats',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                _StatTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Pending\nAppoints',
                  value: '$_pendingAppointments',
                  color: AppColors.warning,
                ),
                const SizedBox(width: 8),
                _StatTile(
                  icon: Icons.people_rounded,
                  label: 'Total\nClients',
                  value: '$_totalClients',
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── New Client Requests ──
            HardlineSectionHeader(title: 'New Client Requests'),
            const SizedBox(height: 8),
            ..._buildMockRequests(),
            const SizedBox(height: 20),

            // ── Recent Consultations ──
            HardlineSectionHeader(title: 'Recent Consultations'),
            const SizedBox(height: 8),
            ..._buildRecentConsultations(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMockRequests() {
    final requests = [
      {'name': 'Arjun Mehta', 'issue': 'Salary not paid for 3 months', 'time': '2m ago'},
      {'name': 'Priya Nair', 'issue': 'Landlord refusing to return deposit', 'time': '8m ago'},
    ];

    return requests.map((req) {
      return HardlineCard(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            // Avatar initial
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary10,
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.center,
              child: Text(
                req['name']![0],
                style: GoogleFonts.merriweather(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    req['name']!,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    req['issue']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  req['time']!,
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                HardlinePressable(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.success),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      'Accept',
                      style: GoogleFonts.inter(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildRecentConsultations() {
    final items = [
      {'name': 'Rohan Gupta', 'type': 'Chat', 'earned': '₹450', 'duration': '30 min'},
      {'name': 'Sneha Kapoor', 'type': 'Video', 'earned': '₹1,050', 'duration': '15 min'},
    ];

    return items.map((item) {
      return HardlineCard(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary10,
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.center,
              child: Text(
                item['name']![0],
                style: GoogleFonts.merriweather(
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name']!,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.primary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item['type']} · ${item['duration']}',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Text(
              item['earned']!,
              style: GoogleFonts.robotoMono(
                fontWeight: FontWeight.w700,
                color: AppColors.success,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

// ─── Earnings Pill ────────────────────────────────────────────────────────────

class _EarningsPill extends StatelessWidget {
  final String label;
  final String value;
  const _EarningsPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.robotoMono(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// ─── Stat Tile ────────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatTile(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.robotoMono(
                  fontSize: 18, fontWeight: FontWeight.w700, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
