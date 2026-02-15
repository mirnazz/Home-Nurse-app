import 'package:flutter/material.dart';

class PatientAuthScreen extends StatelessWidget {
  const PatientAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7F9);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 120),

              const Text(
                "Continue as Patient",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2F5D6E),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please login or create a new account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 50),

              AuthCard(
                icon: Icons.login_rounded,
                title: "Login",
                subtitle: "Already have an\naccount? Sign in here",
                onTap: () {
                  Navigator.pushNamed(context, "/patientLogin");
                },
              ),
              const SizedBox(height: 18),
              AuthCard(
                icon: Icons.person_add_alt_1_rounded,
                title: "Sign Up",
                subtitle: "New here? Create your\naccount now",
                onTap: () {
                  Navigator.pushNamed(context, "/patientSignup");
                },
              ),

              const Spacer(),

              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Color(0xFF2F7F8D),
                ),
                label: const Text(
                  "Back to Role Selection",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2F7F8D),
                  ),
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AuthCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF2F7F8D);
    const iconBg = Color(0xFFEAF4F6);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 10),
              ),
            ],
            border: Border.all(color: Color(0xFFE8ECF2)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accent, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
