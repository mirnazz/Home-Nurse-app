import 'package:flutter/material.dart';

import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_home_screen.dart';
import 'package:nurse_app/Features/nurse_verification/nurse_pending_screen.dart';
import 'package:nurse_app/Features/Nurse/nurse_dashboard_screen.dart';
import 'package:nurse_app/Features/nurse_verification/nurse_rejected_screen.dart';
import 'package:nurse_app/Core/theme/api/token_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscure = true;
  bool isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7F9);
    const primary = Color(0xFF2F7F8D);

    InputDecoration fieldDecoration({
      required String hint,
      required IconData icon,
      Widget? suffix,
    }) {
      return InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8ECF2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.2),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Center(
                  child: Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2F5D6E),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Sign in to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                const Text(
                  "Email Address",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2F5D6E),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: fieldDecoration(
                    hint: "your.email@example.com",
                    icon: Icons.email_outlined,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2F5D6E),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: obscure,
                  decoration: fieldDecoration(
                    hint: "Enter your password",
                    icon: Icons.lock_outline_rounded,
                    suffix: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed:
                        () => Navigator.pushNamed(context, "/ForgotPassword"),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 22),

                // ✅ إنشاء حساب (اختياري)
                Row(
                  children: const [
                    Expanded(
                      child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () {
                      // عدّلي الوجهة حسب شاشتك
                      Navigator.pushNamed(context, "/Signup");
                      // أو:
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primary, width: 1.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Create New Account",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
  final email = emailController.text.trim();
  final pass = passwordController.text;

  if (email.isEmpty || !email.contains('@')) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a valid email")),
    );
    return;
  }

  if (pass.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter your password")),
    );
    return;
  }

  setState(() => isLoading = true);

  try {
    await TokenStorage.clearToken();

    await ApiService.login(email: email, password: pass);

    final me = await ApiService.getMe();

    if (!mounted) return;

    final role = (me['role'] ?? '').toString().trim();
    final verificationStatus =
        (me['verificationStatus'] ?? '').toString().trim();

    debugPrint('GET ME => $me');
    debugPrint('ROLE => $role');
    debugPrint('STATUS => $verificationStatus');

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

      if (verificationStatus == 'Approved') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NurseDashboardScreen()),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unknown nurse verification status: $verificationStatus",
          ),
        ),
      );
      return;
    }

    if (role == 'Patient') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Unknown role: $role")),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}
  }

