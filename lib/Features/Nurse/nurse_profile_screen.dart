import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/api/token_storage.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Nurse/nurse_personal_info_screen.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_earnings_screen.dart';
import 'package:nurse_app/Features/Nurse/Presentation/nurse_ratings_screen.dart';
import 'package:nurse_app/Core/widgets/language_selector_sheet.dart';

/// Settings-style hub: deep links to sub-screens (no API changes here).
class NurseProfileScreen extends StatelessWidget {
  const NurseProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n.nurseProfileLogoutDialogTitle,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          l10n.nurseProfileLogoutDialogMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.nurseAvailCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.nurseProfileLogoutTitle,
              style: TextStyle(
                color: Color(0xFFDC2626),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    try {
      await TokenStorage.clearToken();
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nurseProfileLogoutFailed('$e'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Text(
              l10n.nurseProfileTitle,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1D2433),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.nurseProfileSubtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            _ProfileSettingsTile(
              icon: Icons.person_outline_rounded,
              title: l10n.nurseProfilePersonalInfoTitle,
              subtitle: l10n.nurseProfilePersonalInfoSubtitle,
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const NursePersonalInfoScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _ProfileSettingsTile(
              icon: Icons.star_outline_rounded,
              title: l10n.nurseProfileRatingsTitle,
              subtitle: l10n.nurseProfileRatingsSubtitle,
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const NurseRatingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _ProfileSettingsTile(
              icon: Icons.account_balance_wallet_outlined,
              title: l10n.nurseProfileEarningsTitle,
              subtitle: l10n.nurseProfileEarningsSubtitle,
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const NurseEarningsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _ProfileSettingsTile(
              icon: Icons.language_rounded,
              title: l10n.patientMoreLanguage,
              subtitle: l10n.languageSelectorSubtitle,
              onTap: () => showLanguageSelectorSheet(context),
            ),
            const SizedBox(height: 10),
            _ProfileSettingsTile(
              icon: Icons.logout_rounded,
              title: l10n.nurseProfileLogoutTitle,
              subtitle: l10n.nurseProfileLogoutSubtitle,
              iconColor: const Color(0xFFDC2626),
              titleColor: const Color(0xFFDC2626),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _ProfileSettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: titleColor ?? const Color(0xFF1D2433),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
