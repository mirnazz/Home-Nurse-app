import 'package:flutter/material.dart';
import 'patient_onboarding_constants.dart';

/// White field + white menu, rounded corners, shadow, teal highlight on selected item.
class PatientOnboardingStyledDropdown<T extends Object> extends StatelessWidget {
  const PatientOnboardingStyledDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.primary,
  });

  final T? value;
  final String hint;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final Color primary;

  static const _fieldTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: PatientOnboardingTokens.text,
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
        highlightColor: primary.withValues(alpha: 0.08),
        splashColor: primary.withValues(alpha: 0.12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(16),
          dropdownColor: Colors.white,
          menuMaxHeight: 280,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: primary, size: 26),
          hint: Text(
            hint,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          style: _fieldTextStyle,
          decoration: patientOnboardingOutlineDecoration(primary).copyWith(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
          ),
          selectedItemBuilder: (context) {
            return items.map((e) {
              return Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  e.toString(),
                  style: _fieldTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
          items: items.map((e) {
            final label = e.toString();
            final selected = value == e;
            return DropdownMenuItem<T>(
              value: e,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? primary.withValues(alpha: 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: PatientOnboardingTokens.text,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
