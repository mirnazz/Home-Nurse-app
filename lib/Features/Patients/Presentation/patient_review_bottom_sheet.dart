import 'package:flutter/material.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_review_models.dart';

class PatientReviewBottomSheet extends StatefulWidget {
  final PatientPendingReviewItem request;

  const PatientReviewBottomSheet({
    super.key,
    required this.request,
  });

  @override
  State<PatientReviewBottomSheet> createState() => _PatientReviewBottomSheetState();
}

class _PatientReviewBottomSheetState extends State<PatientReviewBottomSheet> {
  final TextEditingController _reviewController = TextEditingController();
  int _overallRating = 0;
  int _professionalismRating = 0;
  int _punctualityRating = 0;
  int _communicationRating = 0;
  int _serviceQualityRating = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_overallRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set your overall rating first.')),
      );
      return;
    }

    final draft = PatientRatingSubmissionDraft(
      requestId: widget.request.requestId,
      appointmentId: widget.request.appointmentId,
      overallRating: _overallRating,
      professionalismRating: _professionalismRating,
      punctualityRating: _punctualityRating,
      communicationRating: _communicationRating,
      serviceQualityRating: _serviceQualityRating,
      reviewText: _reviewController.text,
    );

    Navigator.of(context).pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Rate Your Experience',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(999),
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Service: ${widget.request.serviceName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nurse: ${widget.request.nurseName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Overall Rating',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: _StarPicker(
                  rating: _overallRating,
                  onChanged: (value) => setState(() => _overallRating = value),
                  size: 31,
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Tap to rate',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Rate Specific Areas',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              _RatingLine(
                label: 'Professionalism',
                value: _professionalismRating,
                onChanged: (value) => setState(() => _professionalismRating = value),
              ),
              _RatingLine(
                label: 'Punctuality',
                value: _punctualityRating,
                onChanged: (value) => setState(() => _punctualityRating = value),
              ),
              _RatingLine(
                label: 'Communication',
                value: _communicationRating,
                onChanged: (value) => setState(() => _communicationRating = value),
              ),
              _RatingLine(
                label: 'Service Quality',
                value: _serviceQualityRating,
                onChanged: (value) => setState(() => _serviceQualityRating = value),
              ),
              const SizedBox(height: 10),
              const Text(
                'Write Review (Optional)',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reviewController,
                maxLength: 500,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Share your experience with other patients...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Review',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
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

class _RatingLine extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _RatingLine({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
          _StarPicker(
            rating: value,
            onChanged: onChanged,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _StarPicker extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  final double size;

  const _StarPicker({
    required this.rating,
    required this.onChanged,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final selected = index < rating;
        return IconButton(
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          padding: const EdgeInsets.symmetric(horizontal: 1),
          splashRadius: 18,
          onPressed: () => onChanged(index + 1),
          icon: Icon(
            selected ? Icons.star_rounded : Icons.star_border_rounded,
            size: size,
            color: selected ? const Color(0xFFFFB000) : const Color(0xFFD1D5DB),
          ),
        );
      }),
    );
  }
}
