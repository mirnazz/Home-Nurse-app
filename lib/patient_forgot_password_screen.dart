import 'package:flutter/material.dart';

class PatientForgotPasswordScreen extends StatelessWidget {
  const PatientForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7F9);
    const primary = Color(0xFF2F7F8D);

    InputDecoration deco() {
      return InputDecoration(
        hintText: "your.email@example.com",
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF9CA3AF)),
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
        title: const Text(
          "Forgot Password",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Reset your password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2F5D6E),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your email and we’ll send you a link to reset your password.",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 26),

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
                keyboardType: TextInputType.emailAddress,
                decoration: deco(),
              ),

              const SizedBox(height: 18),
              const Text(
                "We’ll send a reset link to your email.",
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // بعدين لما نربط Firebase رح نحط sendEmail هون
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Reset link sent (demo).")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Send Reset Link",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
