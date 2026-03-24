import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/consultation_mode.dart';
import '../../models/lawyer.dart';
import '../../services/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../utils/transitions.dart';
import '../../widgets/lawyer_card.dart';
import '../consultation_screen.dart';
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
  RangeValues _feeRange = const RangeValues(0, 10000);
  double _feeMin = 0;
  double _feeMax = 10000;
  double _minimumRating = 0;
  LawyerSortOption _sortOption = LawyerSortOption.recommended;

  @override
  void initState() {
    super.initState();
    final allFees = MockDataService.lawyers
        .map((lawyer) => lawyer.consultationFeePerMinute)
        .toList();
    allFees.sort();
    if (allFees.isNotEmpty) {
      _feeMin = allFees.first;
      _feeMax = allFees.last;
      _feeRange = RangeValues(_feeMin, _feeMax);
    }
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
    final theme = Theme.of(context);
    final lawyers = _applyFilters(MockDataService.lawyers);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: CustomScrollView(
        slivers: <Widget>[
          // Search & Filter Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(bottom: BorderSide(color: theme.dividerColor)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppColors.textSecondaryLight, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              onChanged: (value) => setState(() => _query = value),
                              style: GoogleFonts.inter(color: theme.textTheme.bodyLarge?.color),
                              decoration: InputDecoration(
                                hintText: 'Search lawyers...',
                                hintStyle: GoogleFonts.inter(color: AppColors.textTertiaryLight, fontSize: 14),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                                fillColor: Colors.transparent,
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
                        color: _hasActiveFilters ? AppColors.accent : theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _hasActiveFilters ? AppColors.accent : theme.dividerColor),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: _hasActiveFilters ? Colors.white : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Result info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    '${lawyers.length} legal experts match your needs',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondaryLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (lawyers.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(onReset: _resetFilters),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    final lawyer = lawyers[index];
                    return LawyerCard(
                      lawyer: lawyer,
                      onTap: () => _openProfile(context, lawyer),
                      onCall: () => _quickConsult(context, lawyer, ConsultationMode.voice),
                      onChat: () => _quickConsult(context, lawyer, ConsultationMode.chat),
                    );
                  },
                  childCount: lawyers.length,
                ),
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
            final theme = Theme.of(context);
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(color: theme.dividerColor),
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
                            color: theme.dividerColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Refine Search',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
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
                              label: Text(area, style: GoogleFonts.inter(fontSize: 13)),
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
                              labelStyle: TextStyle(color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color),
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
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<LawyerSortOption>(
                              value: tempSort,
                              isExpanded: true,
                              dropdownColor: theme.colorScheme.surface,
                              style: GoogleFonts.inter(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.w500),
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
                              child: const Text('Apply'),
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

  void _quickConsult(BuildContext context, Lawyer lawyer, ConsultationMode mode) {
    Navigator.push(
      context,
      slideRoute(ConsultationScreen(
        lawyer: lawyer,
        mode: mode,
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
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondaryLight),
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
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: theme.dividerColor),
              ),
              child: Icon(Icons.search_off_rounded, size: 48, color: AppColors.textSecondaryLight.withOpacity(0.5)),
            ),
            const SizedBox(height: 24),
            Text(
              'No legal experts found',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your filters or using different keywords to find the right lawyer for you.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppColors.textSecondaryLight, height: 1.5),
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
