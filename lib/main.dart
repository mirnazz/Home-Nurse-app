import 'package:flutter/material.dart';

import 'splash_screen.dart';
import 'patient_auth_screen.dart';
import 'patient_login_screen.dart';
import 'patient_home_screen.dart';
import 'patient_forgot_password_screen.dart';
import 'patient_signup_screen.dart';

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
        "/patientAuth": (_) => const PatientAuthScreen(),
        "/patientLogin": (_) => const PatientLoginScreen(),
        "/patientSignup": (_) => const Placeholder(),
        "/patientHome": (_) => const PatientHomeScreen(),
        "/patientForgot": (_) => const PatientForgotPasswordScreen(),
        "/patientSignup": (_) => const PatientSignupScreen(),
      },
    );
  }
}
