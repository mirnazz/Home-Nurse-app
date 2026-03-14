import 'package:flutter/material.dart';
import 'package:nurse_app/core/theme/api/app_storage.dart';
import 'package:nurse_app/core/theme/api/token_storage.dart';
import 'package:nurse_app/core/theme/api/api_service.dart';
import 'package:nurse_app/Features/onboarding/Presentation/onboarding_screen.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_home_screen.dart';
import 'package:nurse_app/Features/Nurse/nurse_home_screen.dart';
import 'package:nurse_app/Features/nurse_verification/nurse_rejected_screen.dart';
import 'package:nurse_app/Features/nurse_verification/nurse_pending_screen.dart';
import 'package:nurse_app/Features/auth/Presentation/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(milliseconds: 900));

    final token = await TokenStorage.getToken();
    final seenOnboarding = await AppStorage.hasSeenOnboarding();

    if (!mounted) return;

    // 1) No token -> onboarding once then login
    if (token == null || token.isEmpty) {
      if (!seenOnboarding) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
      return;
    }

    // 2) Token exists -> validate session with /me
    try {
      final me = await ApiService.getMe();
      if (!mounted) return;

      final roles = (me['roles'] as List?) ?? [];
      final role = roles.isNotEmpty ? roles.first.toString() : '';

      final verificationStatus = (me['verificationStatus'] ?? '').toString();

      if (role == 'Nurse') {
        if (verificationStatus == 'Pending') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const NursePendingScreen()),
          );
          return;
        }

        if (verificationStatus == 'Rejected') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const NurseRejectedScreen()),
          );
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NurseHomeScreen()),
        );
        return;
      }

      // Patient
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
      );
    } catch (_) {
      // token invalid / unauthorized / server down
      await TokenStorage.clearToken();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F5D6E),
      body: Center(child: Image.asset('assets/images/logo.png', width: 200)),
    );
  }
}
