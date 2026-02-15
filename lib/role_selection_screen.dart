import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7F9);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
              const Text(
                "Welcome to Nurse Home",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2F5D6E),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "How would you like to use the app?",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F7F8D),
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    RoleCard(
                      icon: Icons.person_outline_rounded,
                      title: "I am a Patient",
                      subtitle:
                          "Book qualified nurses for home\nhealthcare services",
                      bullets: const [
                        "Book verified nurses instantly",
                        "Track appointments in real-time",
                        "Secure payment & ratings",
                      ],
                      cta: "Continue as Patient",
                      onTap: () {
                        Navigator.pushNamed(context, "/patientAuth");
                      },
                    ),
                    const SizedBox(height: 18),
                    RoleCard(
                      icon: Icons.home_outlined,
                      title: "I am a Nurse",
                      subtitle:
                          "Provide professional home nursing services\nand manage your work easily",
                      bullets: const [
                        "Receive & manage requests",
                        "Manage your schedule & availability",
                        "Secure payments & verified profiles",
                      ],
                      cta: "Continue as Nurse",
                      onTap: () {
                        Navigator.pushNamed(context, "/nurseAuth");
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> bullets;
  final String cta;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.bullets,
    required this.cta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF2F7F8D);
    const iconBox = Color(0xFF6FA7B3);
    const successGreen = Color(0xFF2E9C84);

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
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              children: [
                // ICON
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: iconBox,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: Colors.white, size: 30),
                  ),
                ),

                const SizedBox(height: 14),

                // TITLE + SUBTITLE (CENTERED PROPERLY)
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
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

                const SizedBox(height: 14),

                // BULLETS
                ...bullets.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      children: [
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.check_circle_rounded,
                          color: successGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            b,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // CTA (TEXT + ARROW ONLY)
                Row(
                  children: [
                    Text(
                      cta,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: teal,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: teal,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
