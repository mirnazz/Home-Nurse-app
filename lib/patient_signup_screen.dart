import 'package:flutter/material.dart';
import 'patient_home_screen.dart';

class PatientSignupScreen extends StatefulWidget {
  const PatientSignupScreen({super.key});

  @override
  State<PatientSignupScreen> createState() => _PatientSignupScreenState();
}

class _PatientSignupScreenState extends State<PatientSignupScreen> {
  bool obscure1 = true;
  bool obscure2 = true;
  bool agree = false;

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

    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF2F5D6E),
        ),
      ),
    );

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
          "Create Account",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              const Center(
                child: Text(
                  "Join Nurse Home",
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
                  "Create your account to book nursing services",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              label("Full Name"),
              TextField(
                decoration: fieldDecoration(
                  hint: "John Doe",
                  icon: Icons.person_outline_rounded,
                ),
              ),
              const SizedBox(height: 18),

              label("Email Address"),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: fieldDecoration(
                  hint: "your.email@example.com",
                  icon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 18),

              label("Phone Number"),
              TextField(
                keyboardType: TextInputType.phone,
                decoration: fieldDecoration(
                  hint: "+962 7X XXX XXXX",
                  icon: Icons.phone_outlined,
                ),
              ),
              const SizedBox(height: 18),

              label("Address"),
              TextField(
                decoration: fieldDecoration(
                  hint: "Your address in Amman",
                  icon: Icons.location_on_outlined,
                ),
              ),
              const SizedBox(height: 18),

              label("Password"),
              TextField(
                obscureText: obscure1,
                decoration: fieldDecoration(
                  hint: "Create a strong password",
                  icon: Icons.lock_outline_rounded,
                  suffix: IconButton(
                    onPressed: () => setState(() => obscure1 = !obscure1),
                    icon: Icon(
                      obscure1
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              label("Confirm Password"),
              TextField(
                obscureText: obscure2,
                decoration: fieldDecoration(
                  hint: "Re-enter your password",
                  icon: Icons.lock_outline_rounded,
                  suffix: IconButton(
                    onPressed: () => setState(() => obscure2 = !obscure2),
                    icon: Icon(
                      obscure2
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: agree,
                    activeColor: primary,
                    onChanged: (v) => setState(() => agree = v ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                            height: 1.35,
                          ),
                          children: [
                            TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Terms of Service",
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    if (!agree) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please agree to the terms first."),
                        ),
                      );
                      return;
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PatientHomeScreen(),
                      ),
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
                    "Create Account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: const [
                  Expanded(
                    child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Already have an account?",
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
                    Navigator.pop(context); // يرجّعك لصفحة الـ Login
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primary, width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Login to Existing Account",
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
    );
  }
}
