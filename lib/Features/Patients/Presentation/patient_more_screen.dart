import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/api/token_storage.dart';
import 'package:nurse_app/Core/widgets/language_selector_sheet.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_profile_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_report_issue_screen.dart';

/// More tab: profile, language, logout and future settings.
class PatientMoreScreen extends StatelessWidget {
  const PatientMoreScreen({super.key});

  static const Color _primary = Color(0xFF2F7F8D);
  static const Color _bg = Color(0xFFF6F7F9);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.patientNavMore,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _MoreTileCard(
            icon: Icons.person_outline_rounded,
            title: l10n.patientMoreProfileTitle,
            subtitle: l10n.patientMoreProfileSubtitle,
            onTap: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const PatientProfileScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _MoreTileCard(
            icon: Icons.flag_outlined,
            title: l10n.patientMoreReportIssueTitle,
            subtitle: l10n.patientMoreReportIssueSubtitle,
            onTap: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const PatientReportIssueScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _MoreTileCard(
            icon: Icons.language_rounded,
            title: l10n.patientMoreLanguage,
            subtitle: l10n.patientMoreLanguageSubtitle,
            onTap: () => showLanguageSelectorSheet(context),
          ),
          const SizedBox(height: 12),
          _MoreTileCard(
            icon: Icons.logout_rounded,
            title: l10n.patientLogout,
            subtitle: l10n.patientMoreSignOutSubtitle,
            isDestructive: true,
            onTap: () async {
              await TokenStorage.clearToken();
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MoreTileCard extends StatelessWidget {
  const _MoreTileCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFFE8ECF2);
    const destructiveRed = Color(0xFFDC2626);
    final iconBg = isDestructive ? const Color(0xFFFFECEC) : const Color(0xFFEAF4F6);
    final iconColor = isDestructive ? destructiveRed : PatientMoreScreen._primary;
    final titleColor = isDestructive ? destructiveRed : const Color(0xFF1D2433);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor),
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
                        fontSize: 16,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDestructive ? destructiveRed.withValues(alpha: 0.5) : const Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
