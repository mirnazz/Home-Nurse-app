import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse_app/Core/theme/api/api_service.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/l10n/app_localizations.dart';

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

class NurseRatingsScreen extends StatefulWidget {
 const NurseRatingsScreen({super.key});

  @override
  State<NurseRatingsScreen> createState() => _NurseRatingsScreenState();
}

class _NurseRatingsScreenState extends State<NurseRatingsScreen> {
  double _average = 0;
  int _totalReviews = 0;
  List<_ReviewItem> _reviews = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
       final data = await ApiService.getNurseReviews();

      final avg = (data["averageRating"] ?? 0).toDouble();
      final count = data["reviewsCount"] ?? 0;
      final list = data["reviews"] as List;

      final mapped = list.map((r) {
        return _ReviewItem(
          patientName: r["patientName"] ?? "",
          rating: (r["rating"] ?? 0).toDouble(),
          comment: r["comment"] ?? "",
          date: DateTime.parse(r["createdAt"]),
        );
      }).toList();

      setState(() {
        _average = avg;
        _totalReviews = count;
        _reviews = mapped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFmt =
        DateFormat.yMMMd(Localizations.localeOf(context).toString());

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.nurseProfileRatingsTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          /// Average Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _average.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < _average.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: const Color(0xFFF59E0B),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    l10n.nurseRatingsBasedOn(_totalReviews),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            l10n.nurseRatingsRecentReviews,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 12),

          if (_reviews.isEmpty)
            const Center(child: Text("No reviews yet")),

          ..._reviews.map((r) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(r.patientName)),
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < r.rating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 18,
                              color: const Color(0xFFF59E0B),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(r.comment),
                    const SizedBox(height: 6),
                    Text(
                      dateFmt.format(r.date),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}