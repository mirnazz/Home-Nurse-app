import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_home_screen.dart';
import 'package:nurse_app/Features/nurse_verification/nurse_pending_screen.dart';
import 'package:nurse_app/Features/Nurse/nurse_dashboard_screen.dart';
import 'package:nurse_app/Features/nurse_verification/nurse_rejected_screen.dart';
import 'package:nurse_app/Core/theme/api/token_storage.dart';
import 'package:nurse_app/Core/widgets/language_selector_sheet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool obscure = true;
  bool isLoading = false;

  String? pageError;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _clearError() {
    if (pageError != null) {
      setState(() => pageError = null);
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8ECF2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE57373), width: 1.1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE57373), width: 1.2),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Tooltip(
                      message: l10n.patientMoreLanguage,
                      child: IconButton(
                        onPressed: () => showLanguageSelectorSheet(context),
                        icon: const Icon(Icons.language_rounded),
                        color: const Color(0xFF2F5D6E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      l10n.welcomeBackTitle,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2F5D6E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      l10n.signInToContinue,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),

                 if (pageError != null) ...[
  AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFFFD6D6)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: Color(0xFFE11D48),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sign in unsuccessful",
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                pageError!,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13.2,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
  const SizedBox(height: 18),
],

                  Text(
                    l10n.emailAddressLabel,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F5D6E),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _clearError(),
                    decoration: fieldDecoration(
                      hint: l10n.emailFieldHint,
                      icon: Icons.email_outlined,
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';

                      if (email.isEmpty) {
                        return "Email is required";
                      }

                      final emailRegex = RegExp(
                        r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$',
                      );

                      if (!emailRegex.hasMatch(email)) {
                        return "Please enter a valid email address";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  Text(
                    l10n.passwordLabel,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2F5D6E),
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: passwordController,
                    obscureText: obscure,
                    onChanged: (_) => _clearError(),
                    decoration: fieldDecoration(
                      hint: l10n.passwordFieldHint,
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
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return "Password is required";
                      }

                      return null;
                    },
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/ForgotPassword");
                      },
                      child: Text(
                        l10n.forgotPassword,
                        style: const TextStyle(
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
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.login,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.dontHaveAccount,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
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
                        Navigator.pushNamed(context, "/Signup");
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: primary, width: 1.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.createNewAccount,
                        style: const TextStyle(
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
      ),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    setState(() => pageError = null);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();
    final pass = passwordController.text;

    setState(() => isLoading = true);

    try {
      await TokenStorage.clearToken();

      await ApiService.login(email: email, password: pass);

      final me = await ApiService.getMe();

      if (!mounted) return;

      final role = (me['role_normalized'] ?? me['role'] ?? '').toString().trim();
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

        setState(() {
          pageError =
              "Your nurse account status is unknown. Please contact support.";
        });
        return;
      }

      if (role == 'Patient') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
        );
        return;
      }

      setState(() {
        pageError = "Unable to identify your account type. Please contact support.";
      });
    } catch (e, stackTrace) {
      debugPrint("LOGIN ERROR => $e");
      debugPrint("LOGIN STACK => $stackTrace");

      if (!mounted) return;

      setState(() {
       pageError =
    "We couldn't sign you in. Please review your email and password, then try again.";
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}
