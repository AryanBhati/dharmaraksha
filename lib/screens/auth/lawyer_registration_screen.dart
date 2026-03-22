import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../lawyer_app/lawyer_navigation_screen.dart';

class LawyerRegistrationScreen extends StatefulWidget {
  const LawyerRegistrationScreen({super.key});

  @override
  State<LawyerRegistrationScreen> createState() =>
      _LawyerRegistrationScreenState();
}

class _LawyerRegistrationScreenState extends State<LawyerRegistrationScreen> {
  final _nameController = TextEditingController();
  final _barIdController = TextEditingController();
  final _chatRateController = TextEditingController(text: '15');
  final _callRateController = TextEditingController(text: '25');
  final _experienceController = TextEditingController(text: '5');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final List<String> _allSpecializations = [
    'Criminal', 'Family', 'Corporate',
    'Cyber', 'Tenancy', 'Consumer',
    'Labour', 'Property', 'Tax',
    'Immigration', 'IP', 'Banking',
  ];
  final Set<String> _selectedSpecs = {'Criminal'};

  final List<String> _allLanguages = [
    'English', 'Hindi', 'Marathi',
    'Tamil', 'Telugu', 'Bengali',
    'Kannada', 'Gujarati',
  ];
  final Set<String> _selectedLanguages = {'English', 'Hindi'};

  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _barIdController.dispose();
    _chatRateController.dispose();
    _callRateController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < 2) {
      if (_currentStep == 0 && !_formKey.currentState!.validate()) return;
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _submit() async {
    if (_selectedSpecs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one specialization')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    await auth.registerLawyer(
      name: _nameController.text.trim(),
      phone: auth.phoneNumber,
      barCouncilId: _barIdController.text.trim(),
      specializations: _selectedSpecs.toList(),
      yearsExperience: int.tryParse(_experienceController.text) ?? 5,
      languages: _selectedLanguages.toList(),
      chatRate: double.tryParse(_chatRateController.text) ?? 15,
      callRate: double.tryParse(_callRateController.text) ?? 25,
    );

    if (!mounted) return;
    // Show verification pending then navigate
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.hourglass_top_rounded, color: AppColors.accent),
            ),
            const SizedBox(width: 12),
            const Text('Submitted!'),
          ],
        ),
        content: const Text(
          'Your profile is under review. You will receive a "Verified" badge once approved by our admin team (usually within 24-48 hours).',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LawyerNavigationScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Continue to Dashboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.heroGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _back,
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Lawyer Registration',
                      style: GoogleFonts.philosopher(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Step indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: List.generate(3, (i) {
                    final isActive = i <= _currentStep;
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ['Step 1: Identity', 'Step 2: Expertise', 'Step 3: Rates'][_currentStep],
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: [_buildStep1, _buildStep2, _buildStep3][_currentStep](),
                  ),
                ),
              ),
              // Next button
              Padding(
                padding: const EdgeInsets.all(32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 6,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : Text(
                            _currentStep == 2 ? 'Submit for Verification' : 'Next',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey(0),
        children: [
          _glassField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'As per Bar Council',
            icon: Icons.person_outline_rounded,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Name is required'
                : null,
          ),
          const SizedBox(height: 20),
          _glassField(
            controller: _barIdController,
            label: 'Bar Council ID',
            hint: 'e.g., MH/1234/2020',
            icon: Icons.badge_outlined,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Bar Council ID is required'
                : null,
          ),
          const SizedBox(height: 20),
          _glassField(
            controller: _experienceController,
            label: 'Years of Experience',
            hint: 'e.g., 5',
            icon: Icons.work_outline_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 28),
          // Upload buttons (mock)
          _uploadTile(icon: Icons.photo_camera_outlined, label: 'Upload Profile Photo'),
          const SizedBox(height: 12),
          _uploadTile(icon: Icons.credit_card_rounded, label: 'Upload Photo ID'),
          const SizedBox(height: 12),
          _uploadTile(icon: Icons.article_outlined, label: 'Upload Bar Council Certificate'),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specializations',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allSpecializations.map((spec) {
            final selected = _selectedSpecs.contains(spec);
            return FilterChip(
              label: Text(spec),
              selected: selected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedSpecs.add(spec);
                  } else {
                    _selectedSpecs.remove(spec);
                  }
                });
              },
              selectedColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              labelStyle: TextStyle(
                color: selected ? AppColors.primary : Colors.white,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: selected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
                ),
              ),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Text(
          'Languages',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _allLanguages.map((lang) {
            final selected = _selectedLanguages.contains(lang);
            return FilterChip(
              label: Text(lang),
              selected: selected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedLanguages.add(lang);
                  } else {
                    _selectedLanguages.remove(lang);
                  }
                });
              },
              selectedColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              labelStyle: TextStyle(
                color: selected ? AppColors.primary : Colors.white,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: selected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
                ),
              ),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      key: const ValueKey(2),
      children: [
        _glassField(
          controller: _chatRateController,
          label: 'Chat Rate (₹ per minute)',
          hint: '15',
          icon: Icons.chat_bubble_outline_rounded,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        _glassField(
          controller: _callRateController,
          label: 'Call Rate (₹ per minute)',
          hint: '25',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your rates can be updated anytime from your profile dashboard.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _glassField({
    TextEditingController? controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
              prefixIcon: Icon(icon, color: Colors.white60),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _uploadTile({required IconData icon, required String label}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label — mock upload successful')),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white60, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.cloud_upload_outlined,
              color: Colors.white.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
