import 'package:flutter/material.dart';
import 'package:nurse_app/core/theme/appointment_ui_colors.dart';

/// Teal header + pill segmented control: "Upcoming (n)" / "Past (n)".
class AppointmentSegmentHeader extends StatelessWidget {
  final String title;
  final int upcomingCount;
  final int pastCount;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const AppointmentSegmentHeader({
    super.key,
    this.title = 'My Appointments',
    required this.upcomingCount,
    required this.pastCount,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: AppointmentUiColors.tealHeader,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SegmentPill(
                    label: 'Upcoming ($upcomingCount)',
                    selected: selectedIndex == 0,
                    onTap: () => onSelected(0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SegmentPill(
                    label: 'Past ($pastCount)',
                    selected: selectedIndex == 1,
                    onTap: () => onSelected(1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? AppointmentUiColors.tealHeader : Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          ),
        ),
      ),
    );
  }
}
