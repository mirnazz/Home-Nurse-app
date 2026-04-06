import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';

class _ReviewItem {
  final String patientName;
  final double rating;
  final String comment;
  final DateTime date;

  const _ReviewItem({
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

/// Nurse ratings & reviews (UI + placeholder data until API exists).
class NurseRatingsScreen extends StatelessWidget {
  const NurseRatingsScreen({super.key});

  static const _mockAverage = 4.7;
  static const _mockTotalReviews = 24;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFmt = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    final mockReviews = [
      _ReviewItem(
        patientName: l10n.nurseRatingsMockName1,
        rating: 5,
        comment: l10n.nurseRatingsMockComment1,
        date: DateTime(2026, 2, 2),
      ),
      _ReviewItem(
        patientName: l10n.nurseRatingsMockName2,
        rating: 5,
        comment: l10n.nurseRatingsMockComment2,
        date: DateTime(2026, 1, 28),
      ),
      _ReviewItem(
        patientName: l10n.nurseRatingsMockName3,
        rating: 4,
        comment: l10n.nurseRatingsMockComment3,
        date: DateTime(2026, 1, 15),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.nurseProfileRatingsTitle,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _mockAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1D2433),
                      ),
                    ),
                    Row(
                      children: List.generate(5, (i) {
                        final filled = i < _mockAverage.floor();
                        final half = i == _mockAverage.floor() &&
                            _mockAverage % 1 >= 0.5;
                        return Icon(
                          filled
                              ? Icons.star_rounded
                              : half
                                  ? Icons.star_half_rounded
                                  : Icons.star_outline_rounded,
                          color: const Color(0xFFF59E0B),
                          size: 22,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    l10n.nurseRatingsBasedOn(_mockTotalReviews),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            l10n.nurseRatingsRecentReviews,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1D2433),
            ),
          ),
          const SizedBox(height: 12),
          ...mockReviews.map((r) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              r.patientName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: Color(0xFF1D2433),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (i) {
                              return Icon(
                                i < r.rating.round()
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: const Color(0xFFF59E0B),
                                size: 18,
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        r.comment,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dateFmt.format(r.date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
