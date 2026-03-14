import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/nurse/screens/signup_nurse_screen.dart';

enum UserRole { patient, nurse }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  UserRole selectedRole = UserRole.patient;
  String role = "Patient";

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color cardBg = Color(0xFFF4F9FA);
    const String animationPath = "assets/animation/Medical App (1).json";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ── Header (gradient) ──────────────────────────────
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2F7F8D), Color(0xFF31A7BE)],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Back button
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),

                      

                      const SizedBox(height: 6),

                      // Lottie animation
                      SizedBox(
                        height: 240,
                        width: 240,
                        child: Lottie.asset(
                          animationPath,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Title
                      const Text(
                        "Get Started",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                          letterSpacing: 0.4,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Subtitle
                      const Text(
                        "Create your account today",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: 36),
                    ],
                  ),
                ),

                // ── Form Card ───────────────────────────────────────
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(26, 36, 26, 30),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Role selector label
                        const Text(
                          "I am a:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF374151),
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Role buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildRoleButton("Patient", UserRole.patient),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildRoleButton("Nurse", UserRole.nurse),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Full Name
                        _buildInputField(
                          controller: fullNameController,
                          label: "Full Name",
                          hint: "Enter your full name",
                          prefixIcon: Icons.person_outline_rounded,
                          validator: (value) => value == null || value.isEmpty
                              ? "Full name is required"
                              : null,
                        ),
                        const SizedBox(height: 18),

                        // Email
                        _buildInputField(
                          controller: emailController,
                          label: "Email Address",
                          hint: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) =>
                              value == null || !value.contains('@')
                                  ? "Enter a valid email"
                                  : null,
                        ),
                        const SizedBox(height: 18),

                        // Password
                        _buildInputField(
                          controller: passwordController,
                          label: "Password",
                          hint: "Create a password",
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF9CA3AF),
                              size: 21,
                            ),
                            onPressed: () =>
                                setState(() => obscurePassword = !obscurePassword),
                          ),
                          validator: (value) => value == null || value.length < 6
                              ? "Minimum 6 characters"
                              : null,
                        ),
                        const SizedBox(height: 18),

                        // Confirm Password
                        _buildInputField(
                          controller: confirmPasswordController,
                          label: "Confirm Password",
                          hint: "Confirm your password",
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF9CA3AF),
                              size: 21,
                            ),
                            onPressed: () => setState(
                                () => obscureConfirmPassword = !obscureConfirmPassword),
                          ),
                          validator: (value) => value != passwordController.text
                              ? "Passwords do not match"
                              : null,
                        ),

                        const SizedBox(height: 30),

                        // Sign Up button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 3,
                              shadowColor:
                                  AppColors.primary.withValues(alpha: 0.4),
                            ),
                            onPressed: _submit,
                            child: const Text(
                              "Sign Up  →",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Already have account row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                      ],
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (role == "Patient") {
      Navigator.pushReplacementNamed(context, '/patientHome');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NurseRegistrationScreen(),
        ),
      );
    }
  }

  Widget _buildRoleButton(String title, UserRole roleType) {
    final bool isSelected = selectedRole == roleType;

    return GestureDetector(
      onTap: () => setState(() {
        selectedRole = roleType;
        role = title;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 90,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFD0E4E8),
            width: isSelected ? 1.8 : 1.2,
          ),
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.check, size: 13, color: Colors.white),
                ),
              ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    title == "Patient"
                        ? Icons.person_outline_rounded
                        : Icons.medical_services_outlined,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFB0BEC5),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, color: AppColors.primary, size: 22),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFFD0E4E8), width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}