import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/category_card.dart';
import '../../widgets/firm_card.dart';
import '../../widgets/lawyer_mini_card.dart';
import 'ai_assistant_screen.dart';
import '../support_center_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SearchBar(controller: _searchController),
                    const _AiAssistantHero(),
                    const _LegalCategories(),
                    const _TrendingLawyers(),
                    const _TopFirms(),
                    const _LiveSessions(),
                    const _LibraryPreview(),
                    const _DocumentServices(),
                    const _SosCTA(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── EXTRACTED STATELESS WIDGETS FOR PERFORMANCE (CONST) ──

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search lawyers, issues, documents...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}

class _AiAssistantHero extends StatelessWidget {
  const _AiAssistantHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(Icons.auto_awesome, size: 100, color: Colors.white.withOpacity(0.1)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, size: 14, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text('24/7 AI SUPPORT', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Ask your legal problem',
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
              ),
              const SizedBox(height: 8),
              Text(
                'Get instant legal pathways, document drafts, and lawyer recommendations.',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withOpacity(0.9), height: 1.4),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AiAssistantScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Start Free Chat'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegalCategories extends StatelessWidget {
  const _LegalCategories();

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.family_restroom, 'label': 'Divorce'},
      {'icon': Icons.business_center_rounded, 'label': 'Corporate'},
      {'icon': Icons.house_rounded, 'label': 'Property'},
      {'icon': Icons.gavel_rounded, 'label': 'Criminal'},
      {'icon': Icons.description_rounded, 'label': 'Documents'},
      {'icon': Icons.more_horiz_rounded, 'label': 'More'},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Legal Categories', actionText: 'View All'),
          const SizedBox(height: 16),
          // Wrap ensures responsiveness on smaller screens
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            spacing: 8,
            children: categories.map((c) {
              return CategoryCard(
                label: c['label'] as String,
                icon: c['icon'] as IconData,
                onTap: () {},
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TrendingLawyers extends StatelessWidget {
  const _TrendingLawyers();

  @override
  Widget build(BuildContext context) {
    final topLawyers = MockDataService.lawyers.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _SectionHeader(title: 'Trending Lawyers', actionText: 'See All'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 230,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: topLawyers.length,
            itemBuilder: (context, index) {
              final lawyer = topLawyers[index];
              return LawyerMiniCard(
                lawyer: lawyer,
                firmName: MockDataService.getFirmById(lawyer.firmId)?.name ?? 'Alpha Legal',
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LiveSessions extends StatelessWidget {
  const _LiveSessions();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _SectionHeader(title: 'Live Legal Sessions', actionText: 'View Calendar'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.circle, size: 8, color: AppColors.error),
                              const SizedBox(width: 4),
                              Text('LIVE', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.error)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.people_alt_rounded, size: 14, color: AppColors.textSecondaryLight),
                        const SizedBox(width: 4),
                        Text('1.2k', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryLight)),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Tenant Rights & Eviction Rules',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text('Adv. Rajesh Kumar', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryLight)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TopFirms extends StatelessWidget {
  const _TopFirms();

  @override
  Widget build(BuildContext context) {
    final topFirms = MockDataService.lawFirms.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _SectionHeader(title: 'Top Law Firms', actionText: 'See All'),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topFirms.length,
          itemBuilder: (context, index) {
            return FirmCard(
              firm: topFirms[index],
              onTap: () {},
            );
          },
        ),
      ],
    );
  }
}

class _LibraryPreview extends StatelessWidget {
  const _LibraryPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _SectionHeader(title: 'Judicial Library', actionText: 'Explore All'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: [
              _buildLibraryCard(theme, 'Case of the Day', 'How a tenant won against unfair eviction.', Icons.history_edu_rounded),
              _buildLibraryCard(theme, 'FIR Guide', 'Step-by-step guide to filing a police complaint.', Icons.gavel_rounded),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryCard(ThemeData theme, String title, String subtitle, IconData icon) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.accent, size: 24),
          ),
          const Spacer(),
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondaryLight, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DocumentServices extends StatelessWidget {
  const _DocumentServices();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _SectionHeader(title: 'Document Generator', actionText: 'Draft Now'),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.description_rounded, color: AppColors.success, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Legal Documents', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Auto-generate Notices, Wills, Affidavits.', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryLight)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SosCTA extends StatelessWidget {
  const _SosCTA();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportCenterScreen())),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sos_rounded, size: 28),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'EMERGENCY LEGAL SOS',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  const _SectionHeader({required this.title, required this.actionText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          actionText,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
        ),
      ],
    );
  }
}
