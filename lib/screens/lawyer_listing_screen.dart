import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/consultation_mode.dart';
import '../models/lawyer.dart';
import '../services/mock_data.dart';
import '../theme/app_colors.dart';
import '../utils/transitions.dart';
import '../widgets/animated_reveal.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/lawyer_card.dart';
import '../widgets/wallet_header_action.dart';
import 'consultation_screen.dart';
import 'lawyer_profile_screen.dart';

enum LawyerSortOption { recommended, ratingHigh, experienceHigh, feeLowToHigh }

class LawyerListingScreen extends StatefulWidget {
  const LawyerListingScreen({super.key});

  @override
  State<LawyerListingScreen> createState() => _LawyerListingScreenState();
}

class _LawyerListingScreenState extends State<LawyerListingScreen> {
  String _query = '';
  final Set<String> _selectedPracticeAreas = <String>{};
  final Set<String> _selectedLanguages = <String>{};
  final Set<String> _selectedLocations = <String>{};
  RangeValues _experienceRange = const RangeValues(0, 25);
  late RangeValues _feeRange;
  late final double _feeMin;
  late final double _feeMax;
  double _minimumRating = 0;
  LawyerSortOption _sortOption = LawyerSortOption.recommended;

  @override
  void initState() {
    super.initState();
    final allFees = MockDataService.lawyers
        .map((lawyer) => lawyer.consultationFeePerMinute)
        .toList();
    allFees.sort();
    _feeMin = allFees.isNotEmpty ? allFees.first : 0;
    _feeMax = allFees.isNotEmpty ? allFees.last : 100;
    _feeRange = RangeValues(_feeMin, _feeMax);
  }

  bool get _hasActiveFilters =>
      _selectedPracticeAreas.isNotEmpty ||
      _selectedLanguages.isNotEmpty ||
      _selectedLocations.isNotEmpty ||
      _minimumRating > 0 ||
      _experienceRange.start > 0 ||
      _experienceRange.end < 25 ||
      _feeRange.start > _feeMin ||
      _feeRange.end < _feeMax ||
      _sortOption != LawyerSortOption.recommended;

  @override
  Widget build(BuildContext context) {
    final lawyers = _applyFilters(MockDataService.lawyers);

    return AppScaffold(
      title: 'Lawyer Recommendations',
      actions: const [
        WalletHeaderAction(),
        SizedBox(width: 8),
      ],
      body: Column(
        children: <Widget>[
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (value) => setState(() => _query = value),
                            style: GoogleFonts.outfit(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Search lawyers...',
                              hintStyle: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: _openFilterSheet,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: _hasActiveFilters ? AppColors.accent : AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _hasActiveFilters ? AppColors.accent : AppColors.glassBorder),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: _hasActiveFilters ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Result info
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text(
                  '${lawyers.length} legal experts match your needs',
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: lawyers.isEmpty
                ? _EmptyState(onReset: _resetFilters)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: lawyers.length,
                    itemBuilder: (_, index) {
                      final lawyer = lawyers[index];
                      return AnimatedReveal(
                        delayMs: index < 8 ? index * 60 : 0,
                        child: LawyerCard(
                          lawyer: lawyer,
                          onTap: () => _openProfile(context, lawyer),
                          onConsultNow: () => _quickConsult(context, lawyer),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Lawyer> _applyFilters(List<Lawyer> allLawyers) {
    final query = _query.trim().toLowerCase();
    final filtered = allLawyers.where((lawyer) {
      final matchesQuery = query.isEmpty ||
          lawyer.name.toLowerCase().contains(query) ||
          lawyer.specialization.toLowerCase().contains(query) ||
          lawyer.practiceAreas.join(' ').toLowerCase().contains(query) ||
          lawyer.location.toLowerCase().contains(query);

      final matchesPracticeArea = _selectedPracticeAreas.isEmpty ||
          lawyer.practiceAreas
              .any((area) => _selectedPracticeAreas.contains(area));

      final matchesExperience =
          lawyer.experienceYears >= _experienceRange.start &&
              lawyer.experienceYears <= _experienceRange.end;

      final matchesRating = lawyer.rating >= _minimumRating;

      final matchesFee = lawyer.consultationFeePerMinute >= _feeRange.start &&
          lawyer.consultationFeePerMinute <= _feeRange.end;

      final matchesLanguage = _selectedLanguages.isEmpty ||
          lawyer.languages
              .any((language) => _selectedLanguages.contains(language));

      final matchesLocation = _selectedLocations.isEmpty ||
          _selectedLocations.contains(lawyer.location);

      return matchesQuery &&
          matchesPracticeArea &&
          matchesExperience &&
          matchesRating &&
          matchesFee &&
          matchesLanguage &&
          matchesLocation;
    }).toList();

    filtered.sort((a, b) {
      switch (_sortOption) {
        case LawyerSortOption.ratingHigh:
          return b.rating.compareTo(a.rating);
        case LawyerSortOption.experienceHigh:
          return b.experienceYears.compareTo(a.experienceYears);
        case LawyerSortOption.feeLowToHigh:
          return a.consultationFeePerMinute
              .compareTo(b.consultationFeePerMinute);
        case LawyerSortOption.recommended:
          if (a.isAvailable != b.isAvailable) {
            return (b.isAvailable ? 1 : 0).compareTo(a.isAvailable ? 1 : 0);
          }
          return b.rating.compareTo(a.rating);
      }
    });

    return filtered;
  }

  Future<void> _openFilterSheet() async {
    final selectedPracticeAreas = Set<String>.from(_selectedPracticeAreas);
    final selectedLanguages = Set<String>.from(_selectedLanguages);
    final selectedLocations = Set<String>.from(_selectedLocations);
    var tempExperience = _experienceRange;
    var tempFeeRange = _feeRange;
    var tempRating = _minimumRating;
    var tempSort = _sortOption;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Refine Search',
                        style: GoogleFonts.philosopher(fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      const SizedBox(height: 24),
                      _FilterSection(
                        title: 'Practice Areas',
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: MockDataService.allPracticeAreas.map((area) {
                            final isSelected = selectedPracticeAreas.contains(area);
                            return FilterChip(
                              label: Text(area, style: GoogleFonts.outfit(fontSize: 13)),
                              selected: isSelected,
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected) {
                                    selectedPracticeAreas.add(area);
                                  } else {
                                    selectedPracticeAreas.remove(area);
                                  }
                                });
                              },
                              selectedColor: AppColors.accent,
                              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                            );
                          }).toList(),
                        ),
                      ),
                      _FilterSection(
                        title: 'Experience (${tempExperience.start.round()}-${tempExperience.end.round()} years)',
                        child: RangeSlider(
                          min: 0,
                          max: 25,
                          divisions: 25,
                          values: tempExperience,
                          activeColor: AppColors.accent,
                          onChanged: (value) => setModalState(() => tempExperience = value),
                        ),
                      ),
                      _FilterSection(
                        title: 'Consultation Fee (per min)',
                        child: RangeSlider(
                          min: _feeMin,
                          max: _feeMax,
                          divisions: (_feeMax - _feeMin).round().clamp(1, 100),
                          values: tempFeeRange,
                          activeColor: AppColors.accent,
                          onChanged: (value) => setModalState(() => tempFeeRange = value),
                        ),
                      ),
                      _FilterSection(
                        title: 'Sort By',
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<LawyerSortOption>(
                              value: tempSort,
                              isExpanded: true,
                              dropdownColor: AppColors.surface,
                              style: GoogleFonts.outfit(color: AppColors.textPrimary),
                              items: const [
                                DropdownMenuItem(value: LawyerSortOption.recommended, child: Text('Recommended')),
                                DropdownMenuItem(value: LawyerSortOption.ratingHigh, child: Text('Highest Rating')),
                                DropdownMenuItem(value: LawyerSortOption.experienceHigh, child: Text('Most Experienced')),
                                DropdownMenuItem(value: LawyerSortOption.feeLowToHigh, child: Text('Lowest Fee')),
                              ],
                              onChanged: (value) {
                                if (value != null) setModalState(() => tempSort = value);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                              onPressed: () {
                                Navigator.pop(ctx);
                                _resetFilters();
                              },
                              child: const Text('Reset All'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                              onPressed: () {
                                setState(() {
                                  _selectedPracticeAreas..clear()..addAll(selectedPracticeAreas);
                                  _selectedLanguages..clear()..addAll(selectedLanguages);
                                  _selectedLocations..clear()..addAll(selectedLocations);
                                  _experienceRange = tempExperience;
                                  _minimumRating = tempRating;
                                  _feeRange = tempFeeRange;
                                  _sortOption = tempSort;
                                });
                                Navigator.pop(ctx);
                              },
                              child: const Text('Apply Filters'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedPracticeAreas.clear();
      _selectedLanguages.clear();
      _selectedLocations.clear();
      _experienceRange = const RangeValues(0, 25);
      _minimumRating = 0;
      _feeRange = RangeValues(_feeMin, _feeMax);
      _sortOption = LawyerSortOption.recommended;
    });
  }

  void _openProfile(BuildContext context, Lawyer lawyer) {
    Navigator.push(context, slideRoute(LawyerProfileScreen(lawyer: lawyer)));
  }

  void _quickConsult(BuildContext context, Lawyer lawyer) {
    Navigator.push(
      context,
      slideRoute(ConsultationScreen(
        lawyer: lawyer,
        mode: ConsultationMode.chat,
      )),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onReset;

  const _EmptyState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Icon(Icons.search_off_rounded, size: 48, color: AppColors.textSecondary.withOpacity(0.5)),
            ),
            const SizedBox(height: 24),
            Text(
              'No legal experts found',
              style: GoogleFonts.philosopher(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your filters or using different keywords to find the right lawyer for you.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: onReset,
              child: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
