import 'package:flutter/material.dart';
import 'role_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  bool animate = true;

  final List<_OnboardingPage> pages = const [
    _OnboardingPage(
      title: "Professional Home\nNursing Care",
      description:
          "Connect with verified registered nurses\nfor quality healthcare services in the\ncomfort of your home",
      image: "assets/onboarding/care.png",
    ),
    _OnboardingPage(
      title: "Verified & Trusted\nNurses",
      description:
          "All nurses are licensed professionals,\nbackground-checked and verified by\nour admin team",
      image: "assets/onboarding/verified.png",
    ),
    _OnboardingPage(
      title: "Book Anytime,\nAnywhere",
      description:
          "Schedule nursing services 24/7 with\ninstant booking confirmations and\nreal-time updates",
      image: "assets/onboarding/booking.png",
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      animate = false;
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() => animate = true);
      }
    });
  }

  void _goToRoles() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentIndex == pages.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final page = pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 400),
                          opacity: animate ? 1.0 : 0.0,
                          curve: Curves.easeOut,
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 400),
                            scale: animate ? 1.0 : 0.95,
                            curve: Curves.easeOut,
                            child: SizedBox(
                              width: 220,
                              height: 220,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Image.asset(page.image),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 350),
                          opacity: animate ? 1.0 : 0.0,
                          curve: Curves.easeOut,
                          child: AnimatedSlide(
                            duration: const Duration(milliseconds: 350),
                            offset:
                                animate ? Offset.zero : const Offset(0, 0.08),
                            curve: Curves.easeOut,
                            child: Column(
                              children: [
                                Text(
                                  page.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2F5D6E),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  page.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: const Color(
                                      0xFF2F5D6E,
                                    ).withOpacity(0.65),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                final isActive = currentIndex == index;
                final size = isActive ? 10.0 : 8.0;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isActive
                            ? const Color(0xFF2F5D6E)
                            : Colors.grey.shade400,
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!isLastPage) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _goToRoles();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2F5D6E), Color(0xFF9EC3D1)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isLastPage ? "Get started" : "Next  >",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            if (!isLastPage)
              TextButton(
                onPressed: _goToRoles,
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2F5D6E),
                  ),
                ),
              )
            else
              const SizedBox(height: 48),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String description;
  final String image;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });
}
