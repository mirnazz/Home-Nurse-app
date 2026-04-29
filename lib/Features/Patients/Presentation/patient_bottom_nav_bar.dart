import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

class PatientBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const PatientBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2F7F8D);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: const Color(0xFF9CA3AF),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: l10n.patientNavHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.group_outlined),
            label: l10n.patientNavNurses,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            label: l10n.patientNavAppointments,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.payments_outlined),
            label: l10n.patientNavPayments,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_rounded),
            label: l10n.patientNavMore,
          ),
        ],
      ),
    );
  }
}
