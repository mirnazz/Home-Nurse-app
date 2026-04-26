class PatientServiceOption {
  final String id;
  final int catalogId;
  final String title;
  final String durationLabel;
  final num priceJod;

  const PatientServiceOption({
    required this.id,
    required this.catalogId,
    required this.title,
    required this.durationLabel,
    required this.priceJod,
  });
}

class PatientServiceRequestDraft {
  final String nurseId;
  final String nurseName;
  final String nurseSubtitle;
  final String nurseInitials;
  final PatientServiceOption service;
  final DateTime date;
  final String timeSlot;
  final String address;
  final String notes;

  const PatientServiceRequestDraft({
    required this.nurseId,
    required this.nurseName,
    required this.nurseSubtitle,
    required this.nurseInitials,
    required this.service,
    required this.date,
    required this.timeSlot,
    required this.address,
    required this.notes,
  });
}
