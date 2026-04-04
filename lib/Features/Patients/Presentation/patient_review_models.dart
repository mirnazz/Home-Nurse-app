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

  String get bookingId => appointmentId;
}

/// How the patient closed the review modal.
enum PatientReviewModalAction {
  submitted,
  later,
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

  String get bookingId => appointmentId;

  Map<String, dynamic> toJson() {
    return {
      'bookingId': int.tryParse(bookingId),
      'rating': overallRating,
      'comment': reviewText.trim().isEmpty ? null : reviewText.trim(),
    };
  }
}

