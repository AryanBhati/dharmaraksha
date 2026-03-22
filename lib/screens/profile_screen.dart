import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../providers/wallet_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsOn = true;
  bool _hideBalance = false;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final wallet = context.watch<WalletProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return AppScaffold(
      title: 'My Profile',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // ── Profile Header ──
            Center(
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accent, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: ClipOval(
                          child: user.profilePhoto.isNotEmpty
                              ? Image.network(
                                  user.profilePhoto,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _avatarFallback(user.name),
                                )
                              : _avatarFallback(user.name),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: GoogleFonts.philosopher(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    user.email,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Wallet Overview (Glass) ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wallet Balance',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _hideBalance ? '₹ ••••••' : '₹${wallet.balance.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(0, 40),
                    ),
                    child: const Text('Top Up'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Menu Sections ──
            _buildSection(
              context,
              'ACCOUNT SETTINGS',
              [
                _buildMenuItem(Icons.person_outline_rounded, 'Personal Information', onTap: () {}),
                _buildMenuItem(Icons.notifications_none_rounded, 'Notifications', 
                  trailing: _buildToggle(_notificationsOn, (v) => setState(() => _notificationsOn = v))),
                _buildMenuItem(Icons.visibility_off_outlined, 'Hide Balance', 
                  trailing: _buildToggle(_hideBalance, (v) => setState(() => _hideBalance = v))),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'PREFERENCES',
              [
                _buildMenuItem(Icons.language_rounded, 'Language', trailingText: 'English'),
                _buildMenuItem(
                  themeProvider.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  'Dark Mode',
                  trailing: _buildToggle(themeProvider.isDarkMode, (_) => themeProvider.toggleTheme()),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'SUPPORT & LEGAL',
              [
                _buildMenuItem(Icons.help_outline_rounded, 'Help Center', onTap: () {}),
                _buildMenuItem(Icons.description_outlined, 'Terms of Service', onTap: () {}),
                _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy Policy', onTap: () {}),
              ],
            ),
            const SizedBox(height: 40),

            // ── Log Out ──
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton(
                onPressed: () => _showLogoutDialog(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.redAccent.withOpacity(0.2)),
                  ),
                ),
                child: Text(
                  'Log Out',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'DharamRaksha v1.0.0',
              style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary.withOpacity(0.5)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 0, 12),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap, Widget? trailing, String? trailingText}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.accent),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textSecondary),
              ),
            if (trailing != null) trailing,
            if (onTap != null && trailing == null && trailingText == null)
              Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondary.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(bool value, ValueChanged<bool> onChanged) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.accent,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.kCardBorderRadius)),
        title: Text('Log Out', style: GoogleFonts.philosopher(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback(String name) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 100,
      height: 100,
      color: AppColors.accent.withOpacity(0.1),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.philosopher(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
