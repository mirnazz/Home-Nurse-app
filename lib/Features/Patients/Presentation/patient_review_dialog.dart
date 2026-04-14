import 'package:flutter/material.dart';
import 'package:nurse_app/l10n/app_localizations.dart';
import 'package:nurse_app/Core/theme/app_colors.dart';
import 'package:nurse_app/Features/Patients/Presentation/patient_review_models.dart';

/// Blocking, centered review modal. Not dismissible by outside tap or system back.
Future<PatientReviewDialogResult?> showPatientReviewModal(
  BuildContext context, {
  required PatientPendingReviewItem request,
}) {
  return showDialog<PatientReviewDialogResult>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    builder: (context) => PatientReviewDialog(request: request),
  );
}

class PatientReviewDialog extends StatefulWidget {
  const PatientReviewDialog({super.key, required this.request});

  final PatientPendingReviewItem request;

  @override
  State<PatientReviewDialog> createState() => _PatientReviewDialogState();
}

class _PatientReviewDialogState extends State<PatientReviewDialog> {
  final TextEditingController _reviewController = TextEditingController();

  int _overallRating = 0;
  int _professionalismRating = 0;
  int _punctualityRating = 0;
  int _communicationRating = 0;
  int _serviceQualityRating = 0;

  static const _border = Color(0xFFE8ECF2);
  static const _text = Color(0xFF1D2433);
  static const _muted = Color(0xFF6B7280);

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_overallRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.patientReviewSetRatingFirstSnack,
          ),
        ),
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

    Navigator.of(context).pop(PatientReviewDialogResult.submitted(draft));
  }

  void _later() {
    Navigator.of(context).pop(const PatientReviewDialogResult.later());
  }

  void _closeForever() {
    Navigator.of(context).pop(const PatientReviewDialogResult.dismissedForever());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = AppColors.primary;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return PopScope(
      canPop: false,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
              maxHeight: MediaQuery.sizeOf(context).height * 0.88,
            ),
            child: AnimatedPadding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x28000000),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(primary, l10n),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                l10n.patientReviewOverallRating,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: _text,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: _StarPicker(
                                  rating: _overallRating,
                                  onChanged: (v) =>
                                      setState(() => _overallRating = v),
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: Text(
                                  l10n.patientReviewTapToRate,
                                  style: const TextStyle(
                                    color: _muted,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                l10n.patientReviewRateSpecificAreas,
                                style: const TextStyle(
                                  color: _text,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _RatingLine(
                                label: l10n.patientReviewProfessionalism,
                                value: _professionalismRating,
                                onChanged: (v) => setState(
                                  () => _professionalismRating = v,
                                ),
                              ),
                              _RatingLine(
                                label: l10n.patientReviewPunctuality,
                                value: _punctualityRating,
                                onChanged: (v) =>
                                    setState(() => _punctualityRating = v),
                              ),
                              _RatingLine(
                                label: l10n.patientReviewCommunication,
                                value: _communicationRating,
                                onChanged: (v) =>
                                    setState(() => _communicationRating = v),
                              ),
                              _RatingLine(
                                label: l10n.patientReviewServiceQuality,
                                value: _serviceQualityRating,
                                onChanged: (v) =>
                                    setState(() => _serviceQualityRating = v),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.patientReviewTextOptional,
                                style: const TextStyle(
                                  color: _text,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _reviewController,
                                maxLength: 500,
                                maxLines: 4,
                                minLines: 3,
                                buildCounter: (
                                  context, {
                                  required currentLength,
                                  required isFocused,
                                  maxLength,
                                }) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '$currentLength / $maxLength',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _muted,
                                      ),
                                    ),
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: l10n.patientReviewTextHint,
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.all(14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide:
                                        const BorderSide(color: _border),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide:
                                        const BorderSide(color: _border),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: primary,
                                      width: 1.6,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _later,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: _muted,
                                        side: const BorderSide(color: _border),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Text(
                                        l10n.patientReviewLater,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton(
                                      onPressed: _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primary,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Text(
                                        l10n.patientReviewSubmit,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    Color primary,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.patientRateExperienceTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.request.serviceName.isEmpty
                      ? l10n.patientReviewServiceShort
                      : l10n.patientReviewServiceLine(
                          widget.request.serviceName,
                        ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.request.nurseName.isEmpty
                      ? l10n.patientReviewNurseShort
                      : l10n.patientReviewNurseLine(widget.request.nurseName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _closeForever,
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
              hoverColor: Colors.white24,
            ),
            icon: const Icon(Icons.close_rounded, size: 24),
            tooltip: l10n.patientReviewCloseTooltip,
          ),
        ],
      ),
    );
  }
}

class _RatingLine extends StatelessWidget {
  const _RatingLine({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

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
                fontSize: 13,
              ),
            ),
          ),
          _StarPicker(
            rating: value,
            onChanged: onChanged,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _StarPicker extends StatelessWidget {
  const _StarPicker({
    required this.rating,
    required this.onChanged,
    required this.size,
  });

  final int rating;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final selected = starValue <= rating;

        return IconButton(
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          splashRadius: 20,
          onPressed: () => onChanged(starValue),
          icon: Icon(
            selected ? Icons.star_rounded : Icons.star_border_rounded,
            size: size,
            color: selected ? const Color(0xFFFFB020) : const Color(0xFFD1D5DB),
          ),
        );
      }),
    );
  }
}


