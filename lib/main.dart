import 'package:flutter/material.dart';
// TEMPORARY: uncomment when flutter_stripe is enabled again (removes analyzer red lines).
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/localization/app_language_prefs.dart';

import 'package:nurse_app/app_locale_scope.dart';
import 'Features/auth/Presentation/login_screen.dart';
import 'Features/onboarding/Presentation/splash_screen.dart';
import 'Features/Patients/Presentation/patient_home_screen.dart';
import 'Features/auth/Presentation/forgot_password_screen.dart';
import 'Features/auth/Presentation/SignUpScreen.dart';
import 'Features/nurse_verification/nurse_pending_screen.dart';
import 'Features/nurse_verification/nurse_rejected_screen.dart';
import 'package:nurse_app/Features/nurse_verification/nurse_resubmission_screen.dart';
import 'package:nurse_app/Features/Nurse/nurse_dashboard_screen.dart';
import 'Features/Nurse/Presentation/nurse_appointments_screen.dart';
import 'Features/Nurse/Presentation/nurse_requests_screen.dart';
import 'Features/Patients/Presentation/patient_appointments_screen.dart';
import 'Features/Shared/Presentation/notifications_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TEMPORARY: Stripe init commented — restore with import above when ready.
  // Stripe.publishableKey =
  //     'pk_test_51TF0QgRsR0nCyJlO3Orz01hLZltiXv47BanvNiRDnGNpqFKRry9wnQkUefK0skZntq7zxMtaDcJzpPoXsN7QBEk900OJTMJ2Pt';
  // await Stripe.instance.applySettings();

  final code = await AppLanguagePrefs.getLanguage();
  runApp(NurseApp(initialLocale: Locale(code)));
}

class NurseApp extends StatefulWidget {
  const NurseApp({super.key, required this.initialLocale});

  final Locale initialLocale;

  @override
  State<NurseApp> createState() => _NurseAppState();
}

class _NurseAppState extends State<NurseApp> {
  late Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void _setLocale(Locale? locale) => setState(() => _locale = locale);

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      locale: _locale,
      setLocale: _setLocale,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          if (_locale != null) return _locale;
          if (deviceLocale != null) {
            for (final supported in supportedLocales) {
              if (supported.languageCode == deviceLocale.languageCode) {
                return supported;
              }
            }
          }
          return const Locale('en');
        },
        // Dev: skip signup step 1 — patient onboarding steps 2–4.
        // initialPageIndex: 0 = step 2 (personal), 1 = step 3 (address), 2 = step 4 (medical)
        home: const SplashScreen(),
        routes: {
          "/login": (_) => const LoginScreen(),
          "/Signup": (_) => const SignUpScreen(),
          "/patientHome": (_) => const PatientHomeScreen(),
          "/ForgotPassword": (_) => const ForgotPasswordScreen(),
          "/NurseDashboard": (_) => const NurseDashboardScreen(),
          "/NursePending": (_) => const NursePendingScreen(),
          "/NurseRejected": (_) => const NurseRejectedScreen(),
          "/NurseResubmit": (_) => const NurseResubmissionScreen(),
          "/nurse-appointments": (_) => const NurseAppointmentsScreen(),
          "/nurse-requests": (_) => const NurseRequestsScreen(),
          "/patient-appointments": (_) => const PatientAppointmentsScreen(),
          "/notifications": (_) =>
              const NotificationsScreen(audience: NotificationAudience.nurse),
        },
      ),
    );
  }
}
