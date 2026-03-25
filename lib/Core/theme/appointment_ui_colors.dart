import 'package:flutter/material.dart';

/// Shared palette for appointment flows (matches nurse dashboard mockups).
class AppointmentUiColors {
  AppointmentUiColors._();

  static const Color tealHeader = Color(0xFF217C8A);
  static const Color pageBackground = Color(0xFFF5F7F9);
  static const Color detailRowFill = Color(0xFFF3F4F6);
  static const Color orangeBanner = Color(0xFFEA580C);
  static const Color orangeBannerDark = Color(0xFFC2410C);

  // —— Nurse Schedule: shared surfaces (Availability + Appointments lists) ——
  static const double scheduleCardRadius = 16;
  static const EdgeInsets scheduleCardPadding = EdgeInsets.all(16);
  static const double scheduleListHorizontalPadding = 16;
  static const double scheduleListVerticalGap = 12;

  static const List<BoxShadow> scheduleCardShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 14,
      offset: Offset(0, 6),
    ),
  ];

  static BoxDecoration scheduleCardDecoration({Color? backgroundColor}) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(scheduleCardRadius),
      boxShadow: scheduleCardShadow,
    );
  }
}
