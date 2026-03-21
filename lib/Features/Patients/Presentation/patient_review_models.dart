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
