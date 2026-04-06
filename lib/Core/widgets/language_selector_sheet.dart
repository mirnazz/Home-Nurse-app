import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nurse_app/Core/localization/app_language_prefs.dart';
import 'package:nurse_app/app_locale_scope.dart';

Future<void> showLanguageSelectorSheet(BuildContext context) async {
  final selected = Localizations.localeOf(context).languageCode;

  await showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      final sheetL10n = AppLocalizations.of(sheetContext)!;

      Future<void> handleSelect(String code) async {
        await AppLanguagePrefs.saveLanguage(code);
        if (!sheetContext.mounted) return;
        AppLocaleScope.of(sheetContext).setLocale(Locale(code));
        Navigator.of(sheetContext).pop();
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sheetL10n.languageSelectorTitle,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              ListTile(
                onTap: () => handleSelect('en'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.language),
                title: Text(sheetL10n.patientMoreLanguageEnglish),
                trailing: selected == 'en'
                    ? const Icon(Icons.check_rounded, color: Color(0xFF2F7F8D))
                    : null,
              ),
              ListTile(
                onTap: () => handleSelect('ar'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.language),
                title: Text(sheetL10n.patientMoreLanguageArabic),
                trailing: selected == 'ar'
                    ? const Icon(Icons.check_rounded, color: Color(0xFF2F7F8D))
                    : null,
              ),
            ],
          ),
        ),
      );
    },
  );
}
