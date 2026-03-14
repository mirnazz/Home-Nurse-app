import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Nurse/Registration/Presentation/nurse_registration_screen.dart';
import 'package:nurse_app/core/theme/api/api_service.dart';

enum UserRole { patient, nurse }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  UserRole selectedRole = UserRole.patient;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  static const Color _bg = Color(0xFFF6F8FA);
  static const Color _text = Color(0xFF1E293B); // أسود مريح
  static const Color _muted = Color(0xFF64748B);
  static const Color _border = Color(0xFFE2E8F0);
  static const Color _soft = Color(0xFFF1F5F9);

  Color get _primary => AppColors.primary;

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
    final bool isNurse = selectedRole == UserRole.nurse;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackToLogin(context),

                const SizedBox(height: 26),

                Center(
                  child: Column(
                    children: [
                      Text(
                        isNurse ? "Create Nurse Account" : "Create Account",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: _text,
                          height: 1.15,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isNurse
                            ? "Complete nurse registration in two steps"
                            : "Sign up to get started",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: _muted,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _border),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 18,
                        offset: Offset(0, 10),
                        color: Color(0x12000000),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "I am a:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _text,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildRoleSelector(),

                      const SizedBox(height: 18),

                      _buildInputField(
                        controller: fullNameController,
                        label: "Full Name",
                        hint: "Enter your full name",
                        textInputAction: TextInputAction.next,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? "Full name is required"
                                    : null,
                      ),

                      const SizedBox(height: 14),

                      _buildInputField(
                        controller: emailController,
                        label: "Email Address",
                        hint: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator:
                            (value) =>
                                value == null || !value.contains('@')
                                    ? "Enter valid email"
                                    : null,
                      ),

                      const SizedBox(height: 14),

                      _buildInputField(
                        controller: passwordController,
                        label: "Password",
                        hint: "Create a password",
                        obscureText: obscurePassword,
                        textInputAction: TextInputAction.next,
                        suffixIcon: IconButton(
                          splashRadius: 18,
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: _muted,
                          ),
                          onPressed: () {
                            setState(() => obscurePassword = !obscurePassword);
                          },
                        ),
                        validator:
                            (value) =>
                                value == null || value.length < 6
                                    ? "Minimum 6 characters"
                                    : null,
                      ),

                      const SizedBox(height: 14),

                      _buildInputField(
                        controller: confirmPasswordController,
                        label: "Confirm Password",
                        hint: "Confirm your password",
                        obscureText: obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          splashRadius: 18,
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: _muted,
                          ),
                          onPressed: () {
                            setState(
                              () =>
                                  obscureConfirmPassword =
                                      !obscureConfirmPassword,
                            );
                          },
                        ),
                        validator:
                            (value) =>
                                value != passwordController.text
                                    ? "Passwords do not match"
                                    : null,
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isLoading ? null : _submit,
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
                                  : Text(
                                    isNurse ? "Continue" : "Sign Up",
                                    style: const TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Center(
                        child: Text(
                          isNurse
                              ? "You will complete verification in the next step."
                              : "Create your account to continue.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12.8,
                            color: _muted,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLogin(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacementNamed(context, "/patientLogin");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _muted),
            SizedBox(width: 6),
            Text(
              "Back to Login",
              style: TextStyle(
                color: _muted,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    final bool patientSelected = selectedRole == UserRole.patient;
    final bool nurseSelected = selectedRole == UserRole.nurse;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _soft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _roleChip(
              title: "Patient",
              selected: patientSelected,
              onTap: () => setState(() => selectedRole = UserRole.patient),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _roleChip(
              title: "Nurse",
              selected: nurseSelected,
              onTap: () => setState(() => selectedRole = UserRole.nurse),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleChip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _primary.withOpacity(0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _primary : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? _primary : _muted,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
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
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 0),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: _text, // ✅ أسود مريح
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: _primary, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final bool isNurse = selectedRole == UserRole.nurse;
    setState(() => isLoading = true);

    try {
      if (isNurse) {
        await ApiService.registerNurse(
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        await ApiService.login(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) =>
                    NurseRegistrationScreen(email: emailController.text.trim()),
          ),
        );
      } else {
        await ApiService.registerPatient(
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        await ApiService.login(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, "/patientHome");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
