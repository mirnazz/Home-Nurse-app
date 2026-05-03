import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  bool requestSent = false;
  String? pageError;

  static const Color bg = Color(0xFFF6F7F9);
  static const Color primary = Color(0xFF2F7F8D);
  static const Color text = Color(0xFF1D2433);
  static const Color muted = Color(0xFF6B7280);
  static const Color border = Color(0xFFE8ECF2);

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool _isValidNurseNowEmail(String email) {
    return RegExp(r'^[\w\.-]+@nursenow\.com$').hasMatch(email);
  }

  Future<void> handleForgotPassword() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();

    setState(() {
      isLoading = true;
      requestSent = false;
      pageError = null;
    });

    try {
      await ApiService.forgotPassword(email: email);

      if (!mounted) return;

      setState(() {
        requestSent = true;
      });
    } catch (e) {
      debugPrint("FORGOT PASSWORD ERROR => $e");

      if (!mounted) return;

      setState(() {
        pageError =
            "We couldn’t find an account with this email. Please check it and try again.";
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: "username@nursenow.com",
      prefixIcon: const Icon(
        Icons.email_outlined,
        color: Color(0xFF94A3B8),
      ),
      filled: true,
      fillColor: Colors.white,
      errorMaxLines: 2,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.3),
      ),
    );
  }

  Widget _softInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We’ll help you recover access",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: text,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Enter your registered NurseNow email. The Home Nurse team will review your request and contact you soon to help reset your password.",
                  style: TextStyle(
                    fontSize: 13.2,
                    fontWeight: FontWeight.w600,
                    color: muted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _successCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF6),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFC7EEDC)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF15803D),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Request received. The Home Nurse team will contact you soon to help reset your password.",
              style: TextStyle(
                color: Color(0xFF166534),
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard() {
    if (pageError == null) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFFD6D6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFE11D48),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              pageError!,
              style: const TextStyle(
                color: Color(0xFF9F1239),
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.forgotTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(24, 26, 24, bottomInset + 22),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF4F6),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFD7EBEF)),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: primary,
                        size: 38,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Center(
                    child: Text(
                      "Reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: text,
                        height: 1.15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      "No worries — we’ll help you recover your account safely.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: muted,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "Email address",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: text,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: _inputDecoration(),
                    onChanged: (_) {
                      if (pageError != null || requestSent) {
                        setState(() {
                          pageError = null;
                          requestSent = false;
                        });
                      }
                    },
                    validator: (value) {
                      final email = value?.trim() ?? "";

                      if (email.isEmpty) {
                        return "Email address is required";
                      }

                      if (!_isValidNurseNowEmail(email)) {
                        return "Please enter a valid NurseNow email address";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  _softInfoCard(),

                  if (pageError != null) ...[
                    const SizedBox(height: 14),
                    _errorCard(),
                  ],

                  if (requestSent) ...[
                    const SizedBox(height: 14),
                    _successCard(),
                  ],

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : handleForgotPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Request reset support",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Back to sign in",
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w800,
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
}
