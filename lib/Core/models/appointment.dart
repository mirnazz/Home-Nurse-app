import 'package:nurse_app/Core/enums/appointment_status.dart';

class Appointment {
  final String id;
  final String patientName;
  final String nurseName;
  final String serviceName;
  final DateTime dateTime;
  final String location;
  final AppointmentStatus status;
  final double price;
  final int? durationMinutes;
  final String? patientPhone;
  final String? nursePhone;
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

  factory Appointment.fromPatientJson(Map<String, dynamic> json) {
    return Appointment(
      id: (json['bookingId'] ?? '').toString(),
      patientName: '',
      nurseName: (json['nurseName'] ?? '').toString(),
      serviceName: (json['serviceName'] ?? '').toString(),
      dateTime: DateTime.parse('${json['date']}T${json['time']}'),
      location: (json['address'] ?? '').toString(),
      status: _mapStatus((json['status'] ?? '').toString()),
      price: (json['totalPrice'] ?? 0).toDouble(),
      durationMinutes: null,
      patientPhone: null,
      nursePhone: null,
      nurseSpecialty: null,
    );
  }

  factory Appointment.fromPatientDetailsJson(Map<String, dynamic> json) {
    return Appointment(
      id: (json['bookingId'] ?? '').toString(),
      patientName: '',
      nurseName: (json['nurseName'] ?? '').toString(),
      serviceName: (json['serviceName'] ?? '').toString(),
      dateTime: DateTime.parse('${json['date']}T${json['time']}'),
      location: (json['address'] ?? '').toString(),
      status: _mapStatus((json['status'] ?? '').toString()),
      price: (json['totalPrice'] ?? 0).toDouble(),
      durationMinutes: json['durationInMinutes'] is num
          ? (json['durationInMinutes'] as num).toInt()
          : null,
      patientPhone: null,
      nursePhone: json['phoneNumber']?.toString(),
      nurseSpecialty: null,
    );
  }

  static AppointmentStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppointmentStatus.pending;
      case 'accepted':
        return AppointmentStatus.confirmed;
      case 'active':
        return AppointmentStatus.paid;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'rejected':
        return AppointmentStatus.rejected;
      default:
        return AppointmentStatus.pending;
    }
  }
  factory Appointment.fromNurseJson(Map<String, dynamic> json) {
  return Appointment(
    id: (json['bookingId'] ?? '').toString(),
    patientName: (json['patientName'] ?? '').toString(),
    nurseName: '',
    serviceName: (json['serviceName'] ?? '').toString(),
    dateTime: DateTime.parse('${json['date']}T${json['time']}'),
    location: (json['address'] ?? '').toString(),
    status: _mapStatus((json['status'] ?? '').toString()),
    price: (json['totalPrice'] ?? 0).toDouble(),
    durationMinutes: null,
    patientPhone: null,
    nursePhone: null,
    nurseSpecialty: null,
  );
}

factory Appointment.fromNurseDetailsJson(Map<String, dynamic> json) {
  return Appointment(
    id: (json['bookingId'] ?? '').toString(),
    patientName: (json['patientName'] ?? '').toString(),
    nurseName: '',
    serviceName: (json['serviceName'] ?? '').toString(),
    dateTime: DateTime.parse('${json['date']}T${json['time']}'),
    location: (json['address'] ?? '').toString(),
    status: _mapStatus((json['status'] ?? '').toString()),
    price: (json['totalPrice'] ?? 0).toDouble(),
    durationMinutes: json['durationInMinutes'] is num
        ? (json['durationInMinutes'] as num).toInt()
        : null,
    patientPhone: json['phoneNumber']?.toString(),
    nursePhone: null,
    nurseSpecialty: json['additionalNotes']?.toString(),
  );
}
}