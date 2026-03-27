import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // 👈 ضيفي هذا

import 'Features/auth/Presentation/login_screen.dart';
import 'Features/Patients/Presentation/patient_home_screen.dart';
import 'Features/auth/Presentation/forgot_password_screen.dart';
import 'Features/auth/Presentation/SignUpScreen.dart';
import 'Features/nurse_verification/nurse_pending_screen.dart';
import 'Features/nurse_verification/nurse_rejected_screen.dart';
import 'package:nurse_app/Features/nurse_verification/nurse_resubmission_screen.dart';
import 'package:nurse_app/Features/Nurse/nurse_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  Stripe.publishableKey =
      'pk_test_51TF0QgRsR0nCyJlO3Orz01hLZltiXv47BanvNiRDnGNpqFKRry9wnQkUefK0skZntq7zxMtaDcJzpPoXsN7QBEk900OJTMJ2Pt';

  await Stripe.instance.applySettings();

  runApp(const NurseApp());
}

class NurseApp extends StatelessWidget {
  const NurseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NurseDashboardScreen(),
      routes: {
        "/login": (_) => const LoginScreen(),
        "/Signup": (_) => const SignUpScreen(),
        "/patientHome": (_) => const PatientHomeScreen(),
        "/ForgotPassword": (_) => const ForgotPasswordScreen(),
        "/NurseDashboard": (_) => const NurseDashboardScreen(),
        "/NursePending": (_) => const NursePendingScreen(),
        "/NurseRejected": (_) => const NurseRejectedScreen(),
        "/NurseResubmit": (_) => const NurseResubmissionScreen(),
        
      },
    );
  }
}


