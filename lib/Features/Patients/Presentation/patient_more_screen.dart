import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/localization/app_language_prefs.dart';
import 'package:nurse_app/app_locale_scope.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_profile_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_report_issue_screen.dart';

/// More tab: profile, language, and future settings.
class PatientMoreScreen extends StatelessWidget {
  const PatientMoreScreen({super.key});

  static const Color _primary = Color(0xFF2F7F8D);
  static const Color _bg = Color(0xFFF6F7F9);
  static const Color _border = Color(0xFFE8ECF2);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveCode = Localizations.localeOf(context).languageCode;

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
          const SizedBox(height: 20),
          _LanguageSettingsGroup(
            primary: _primary,
            border: _border,
            sectionTitle: l10n.patientMoreLanguage,
            isArabicUi: Localizations.localeOf(context).languageCode == 'ar',
            englishSelected: effectiveCode == 'en',
            arabicSelected: effectiveCode == 'ar',
            englishTitle: l10n.patientMoreLanguageEnglish,
            arabicTitle: l10n.patientMoreLanguageArabic,
            onSelectEnglish: () async {
              await AppLanguagePrefs.saveLanguage('en');
              if (!context.mounted) return;
              AppLocaleScope.of(context).setLocale(const Locale('en'));
            },
            onSelectArabic: () async {
              await AppLanguagePrefs.saveLanguage('ar');
              if (!context.mounted) return;
              AppLocaleScope.of(context).setLocale(const Locale('ar'));
            },
          ),
        ],
      ),
    );
  }
}

/// Grouped settings-style language list (system Settings–like).
class _LanguageSettingsGroup extends StatelessWidget {
  const _LanguageSettingsGroup({
    required this.primary,
    required this.border,
    required this.sectionTitle,
    required this.isArabicUi,
    required this.englishSelected,
    required this.arabicSelected,
    required this.englishTitle,
    required this.arabicTitle,
    required this.onSelectEnglish,
    required this.onSelectArabic,
  });

  static const Color _sectionLabelColor = Color(0xFF6B7280);

  final Color primary;
  final Color border;
  final String sectionTitle;
  final bool isArabicUi;
  final bool englishSelected;
  final bool arabicSelected;
  final String englishTitle;
  final String arabicTitle;
  final VoidCallback onSelectEnglish;
  final VoidCallback onSelectArabic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 4, bottom: 8),
          child: Text(
            sectionTitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: isArabicUi ? 0 : 0.35,
              color: _sectionLabelColor,
            ),
          ),
        ),
        Material(
          color: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LanguageListTile(
                primary: primary,
                dividerColor: border,
                title: englishTitle,
                selected: englishSelected,
                onTap: onSelectEnglish,
                showDividerBelow: true,
              ),
              _LanguageListTile(
                primary: primary,
                dividerColor: border,
                title: arabicTitle,
                selected: arabicSelected,
                onTap: onSelectArabic,
                showDividerBelow: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageListTile extends StatelessWidget {
  const _LanguageListTile({
    required this.primary,
    required this.dividerColor,
    required this.title,
    required this.selected,
    required this.onTap,
    required this.showDividerBelow,
  });

  static const Color _titleColor = Color(0xFF1D2433);

  final Color primary;
  final Color dividerColor;
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final bool showDividerBelow;

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16,
      height: 1.2,
      color: _titleColor,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: selected ? primary.withValues(alpha: 0.07) : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: ListTile(
              contentPadding: const EdgeInsetsDirectional.only(
                start: 16,
                end: 12,
                top: 12,
                bottom: 12,
              ),
              minVerticalPadding: 0,
              title: Text(
                title,
                style: titleStyle.copyWith(
                  color: selected ? primary : _titleColor,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                ),
              ),
              trailing: SizedBox(
                width: 28,
                child: selected
                    ? Icon(Icons.check_rounded, color: primary, size: 26)
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        if (showDividerBelow)
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: dividerColor,
          ),
      ],
    );
  }
}

class _MoreTileCard extends StatelessWidget {
  const _MoreTileCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFFE8ECF2);
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
                  color: const Color(0xFFEAF4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: PatientMoreScreen._primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color(0xFF1D2433),
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
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
