import 'package:nurse_app/core/enums/appointment_status.dart';

/// UI model for appointment list & details.
/// TODO(backend): Map from API DTO (JSON) in a repository layer.
class Appointment {
  final String id;
  final String patientName;
  final String nurseName;
  final String serviceName;
  final DateTime dateTime;
  final String location;
  final AppointmentStatus status;
  final double price;

  /// Service duration for display, e.g. "2hr" in details. Null hides duration line.
  final int? durationMinutes;

  /// Patient contact for nurse appointment UI. TODO(backend): from booking API.
  final String? patientPhone;

  /// Nurse contact / profile (patient details). TODO(backend): from booking API.
  final String? nursePhone;

  /// Nurse specialty label on patient details. Falls back to [serviceName] if null.
  final String? nurseSpecialty;

  const Appointment({
    required this.id,
    required this.patientName,
    required this.nurseName,
    required this.serviceName,
    required this.dateTime,
    required this.location,
    required this.status,
    required this.price,
    this.durationMinutes,
    this.patientPhone,
    this.nursePhone,
    this.nurseSpecialty,
  });

  Appointment copyWith({
    String? id,
    String? patientName,
    String? nurseName,
    String? serviceName,
    DateTime? dateTime,
    String? location,
    AppointmentStatus? status,
    double? price,
    int? durationMinutes,
    String? patientPhone,
    String? nursePhone,
    String? nurseSpecialty,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      nurseName: nurseName ?? this.nurseName,
      serviceName: serviceName ?? this.serviceName,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      status: status ?? this.status,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      patientPhone: patientPhone ?? this.patientPhone,
      nursePhone: nursePhone ?? this.nursePhone,
      nurseSpecialty: nurseSpecialty ?? this.nurseSpecialty,
    );
  }
}
