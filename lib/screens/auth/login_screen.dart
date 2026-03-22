import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final phone = _phoneController.text.trim();
    context.read<AuthProvider>().setPhoneNumber(phone);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(phoneNumber: phone),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userType = context.watch<AuthProvider>().userType;
    final isLawyer = userType == UserType.lawyer;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Back
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back,
                            color: AppColors.primary, size: 24),
                      ),
                      const Spacer(flex: 2),

                      // Header
                      Text(
                        isLawyer ? 'Lawyer Login' : 'Welcome Back',
                        style: GoogleFonts.merriweather(
                          fontSize: isMobile ? 24 : 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your mobile number to continue',
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 14 : 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Phone input — hardline bottom border
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.primary10,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Country code
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: AppColors.primary10,
                                  ),
                                ),
                              ),
                              child: Text(
                                '+91',
                                style: GoogleFonts.robotoMono(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            // Phone field
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.robotoMono(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                                decoration: InputDecoration(
                                  hintText: '98XXX XXXXX',
                                  hintStyle: GoogleFonts.inter(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.4),
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 10) {
                                    return 'Enter a valid 10-digit number';
                                  }
                                  return null;
                                },
                                maxLength: 10,
                                buildCounter: (context,
                                        {required currentLength,
                                        required isFocused,
                                        required maxLength}) =>
                                    null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Send OTP — gold CTA
                      SizedBox(
                        width: double.infinity,
                        height: isMobile ? 52 : 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendOtp,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.primary,
                                  ),
                                )
                              : Text(
                                  'Send OTP',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  height: 1, color: AppColors.border)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or continue with',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  height: 1, color: AppColors.border)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialButton(
                            icon: Icons.g_mobiledata_rounded,
                            label: 'Google',
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          _SocialButton(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const Spacer(flex: 3),

                      // Terms
                      Center(
                        child: Text(
                          'By continuing, you agree to our Terms of\nService and Privacy Policy.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
