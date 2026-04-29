import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Nurse/Registration/Presentation/nurse_registration_screen.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Features/auth/Presentation/patient_onboarding/patient_onboarding_data.dart';
import 'package:nurse_app/Features/auth/Presentation/patient_onboarding/patient_onboarding_screen.dart';
import 'package:nurse_app/app_locale_scope.dart';

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
  final TextEditingController phoneController = TextEditingController();
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
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                Row(
                  children: [
                    Expanded(child: _buildBackToLogin(context, l10n)),
                    TextButton(
                      onPressed: () => AppLocaleScope.of(context)
                          .setLocale(const Locale('en')),
                      child: Text(l10n.patientMoreLanguageEnglish),
                    ),
                    TextButton(
                      onPressed: () => AppLocaleScope.of(context)
                          .setLocale(const Locale('ar')),
                      child: Text(l10n.patientMoreLanguageArabic),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                Center(
                  child: Column(
                    children: [
                      Text(
                        isNurse
                            ? l10n.signupCreateNurseAccount
                            : l10n.signupCreateAccount,
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
                            ? l10n.signupNurseSubtitle
                            : l10n.signupPatientSubtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: _muted,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                      if (!isNurse) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.signupStep1Of4,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: _primary,
                            ),
                          ),
                        ),
                      ],
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
                      Text(
                        l10n.signupIAmA,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _text,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildRoleSelector(l10n),

                      const SizedBox(height: 18),

                      _buildInputField(
                        controller: fullNameController,
                        label: l10n.fullNameLabel,
                        hint: l10n.fullNameHint,
                        textInputAction: TextInputAction.next,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? l10n.validationFullNameRequired
                                    : null,
                      ),

                      const SizedBox(height: 14),

                      _buildInputField(
                        controller: emailController,
                        label: l10n.signupEmailLabel,
                        hint: l10n.signupEmailHint,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator:
                            (value) =>
                                value == null || !value.contains('@')
                                    ? l10n.validationEmailInvalid
                                    : null,
                      ),

                      const SizedBox(height: 14),

                      if (!isNurse) ...[
                        _buildInputField(
                          controller: phoneController,
                          label: l10n.phoneNumberLabel,
                          hint: l10n.phoneNumberHint,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return l10n.validationPhoneRequired;
                            if (v.length < 8 || v.length > 15) {
                              return l10n.validationPhoneInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                      ],

                      _buildInputField(
                        controller: passwordController,
                        label: l10n.signupPasswordLabel,
                        hint: l10n.signupPasswordHint,
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
                                    ? l10n.validationPasswordMin
                                    : null,
                      ),

                      const SizedBox(height: 14),

                      _buildInputField(
                        controller: confirmPasswordController,
                        label: l10n.confirmPasswordLabel,
                        hint: l10n.confirmPasswordHint,
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
                                    ? l10n.validationPasswordsMismatch
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
                                    isNurse
                                        ? l10n.continueButton
                                        : l10n.signUp,
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
                              ? l10n.signupFooterNurse
                              : l10n.signupFooterPatient,
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

  Widget _buildBackToLogin(BuildContext context, AppLocalizations l10n) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacementNamed(context, "/login");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _muted),
            const SizedBox(width: 6),
            Text(
              l10n.backToLogin,
              style: const TextStyle(
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

  Widget _buildRoleSelector(AppLocalizations l10n) {
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
              title: l10n.rolePatient,
              selected: patientSelected,
              onTap: () => setState(() => selectedRole = UserRole.patient),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _roleChip(
              title: l10n.roleNurse,
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
    List<TextInputFormatter>? inputFormatters,
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
          inputFormatters: inputFormatters,
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
        final phone = phoneController.text.trim();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (_) => PatientOnboardingScreen(
              data: PatientOnboardingData(phoneNumber: phone),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.signUpErrorFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
