class PatientPendingReviewItem {
  final String requestId;
  final String appointmentId;
  final String serviceName;
  final String nurseName;
  final DateTime? completedAt;

  const PatientPendingReviewItem({
    required this.requestId,
    required this.appointmentId,
    required this.serviceName,
    required this.nurseName,
    required this.completedAt,
  });
}

/// How the patient closed the review modal (local UI only).
enum PatientReviewModalAction {
  /// Submitted ratings + optional text.
  submitted,

  /// Close for now; same booking may prompt again.
  later,

  /// User chose X — do not show this prompt again for this request.
  dismissedForever,
}

class PatientReviewDialogResult {
  const PatientReviewDialogResult._({
    required this.action,
    this.draft,
  });

  factory PatientReviewDialogResult.submitted(
    PatientRatingSubmissionDraft draft,
  ) =>
      PatientReviewDialogResult._(
        action: PatientReviewModalAction.submitted,
        draft: draft,
      );

  const PatientReviewDialogResult.later()
      : this._(action: PatientReviewModalAction.later);

  const PatientReviewDialogResult.dismissedForever()
      : this._(action: PatientReviewModalAction.dismissedForever);

  final PatientReviewModalAction action;
  final PatientRatingSubmissionDraft? draft;
}

class PatientRatingSubmissionDraft {
  final String requestId;
  final String appointmentId;
  final int overallRating;
  final int professionalismRating;
  final int punctualityRating;
  final int communicationRating;
  final int serviceQualityRating;
  final String reviewText;

  const PatientRatingSubmissionDraft({
    required this.requestId,
    required this.appointmentId,
    required this.overallRating,
    required this.professionalismRating,
    required this.punctualityRating,
    required this.communicationRating,
    required this.serviceQualityRating,
    required this.reviewText,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'appointmentId': appointmentId,
      'overallRating': overallRating,
      'professionalismRating': professionalismRating,
      'punctualityRating': punctualityRating,
      'communicationRating': communicationRating,
      'serviceQualityRating': serviceQualityRating,
      'reviewText': reviewText.trim(),
    };
  }
}
