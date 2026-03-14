import 'package:flutter/material.dart';

import 'package:nurse_app/Features/onboarding/screens/splash_screen.dart';
import 'package:nurse_app/Features/auth/screens/login_screen.dart';
import 'package:nurse_app/Features/auth/screens/signup_patient_screen.dart';
import 'package:nurse_app/Features/auth/screens/forgot_password_screen.dart';
import 'package:nurse_app/Features/patient/screens/patient_dashboard_screen.dart';
import 'package:nurse_app/Features/nurse/screens/nurse_dashboard_screen.dart';

void main() {
  runApp(const NurseApp());
}

class NurseApp extends StatelessWidget {
  const NurseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        "/patientLogin": (_) => const PatientLoginScreen(),
        "/patientSignup": (_) => const SignUpScreen(),
        "/patientHome": (_) => const PatientHomeScreen(),
        "/nurseHome": (_) => const NurseDashboardScreen(),
        "/patientForgot": (_) => const PatientForgotPasswordScreen(),
      },
    );
  }
}
