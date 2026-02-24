import 'package:flutter/material.dart';

import 'Features/onboarding/Presentation/splash_screen.dart';
import 'Features/auth/Presentation/login_screen.dart';
import 'Features/Patients/Presentation/patient_home_screen.dart';
import 'Features/auth/Presentation/forgot_password_screen.dart';
import 'Features/auth/Presentation/patient_signup_screen.dart';

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
        "/patientSignup": (_) => const Placeholder(),
        "/patientHome": (_) => const PatientHomeScreen(),
        "/patientForgot": (_) => const PatientForgotPasswordScreen(),
        "/patientSignup": (_) => const SignUpScreen(),
      },
    );
  }
}
