enum NurseServiceRequestStatus { pending, accepted, declined }

enum NurseRequestsFilter { all, pending, accepted, declined }

class NurseServiceRequestItem {
  final String requestId;
  final String patientId;
  final String nurseId;
  final String patientName;
  final String phone;
  final String serviceName;
  final int durationMinutes;
  final num priceJod;
  final DateTime dateTime;
  final String address;
  final String notes;
  final NurseServiceRequestStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NurseServiceRequestItem({
    required this.requestId,
    required this.patientId,
    required this.nurseId,
    required this.patientName,
    required this.phone,
    required this.serviceName,
    required this.durationMinutes,
    required this.priceJod,
    required this.dateTime,
    required this.address,
    required this.notes,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory NurseServiceRequestItem.fromApiJson(Map<String, dynamic> json) {
  final bookingId = ((json['bookingId'] ?? 0) as num).toInt();
  final patientName = (json['patientName'] ?? '').toString();
  final phone = (json['patientPhone'] ?? '').toString();
  final serviceName = (json['serviceName'] ?? '').toString();
  final durationMinutes = ((json['durationInMinutes'] ?? 0) as num).toInt();
  final priceJod = ((json['totalPrice'] ?? 0) as num);
  final address = (json['location'] ?? '').toString();
  final notes = (json['notes'] ?? '').toString();

  final dateRaw = (json['date'] ?? '').toString();
  final timeRaw = (json['time'] ?? '').toString();

  DateTime parsedDateTime;
  try {
    if (dateRaw.isNotEmpty && timeRaw.isNotEmpty) {
      final normalizedTime = timeRaw.length == 5 ? '$timeRaw:00' : timeRaw;
      parsedDateTime = DateTime.parse('${dateRaw.split('T').first}T$normalizedTime');
    } else if (dateRaw.isNotEmpty) {
      parsedDateTime = DateTime.parse(dateRaw);
    } else {
      parsedDateTime = DateTime.now();
    }
  } catch (_) {
    parsedDateTime = DateTime.now();
  }

  final statusRaw = (json['status'] ?? '').toString().toLowerCase();
final status = switch (statusRaw) {
  'accepted' => NurseServiceRequestStatus.accepted,
  'declined' || 'rejected' => NurseServiceRequestStatus.declined,
  _ => NurseServiceRequestStatus.pending,
};

  return NurseServiceRequestItem(
    requestId: bookingId.toString(),
    patientId: '',
    nurseId: '',
    patientName: patientName,
    phone: phone,
    serviceName: serviceName,
    durationMinutes: durationMinutes,
    priceJod: priceJod,
    dateTime: parsedDateTime,
    address: address,
    notes: notes,
    status: status,
    createdAt: null,
    updatedAt: null,
  );
}
NurseServiceRequestItem copyWith({
  String? requestId,
  String? patientId,
  String? nurseId,
  String? patientName,
  String? phone,
  String? serviceName,
  int? durationMinutes,
  num? priceJod,
  DateTime? dateTime,
  String? address,
  String? notes,
  NurseServiceRequestStatus? status,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return NurseServiceRequestItem(
    requestId: requestId ?? this.requestId,
    patientId: patientId ?? this.patientId,
    nurseId: nurseId ?? this.nurseId,
    patientName: patientName ?? this.patientName,
    phone: phone ?? this.phone,
    serviceName: serviceName ?? this.serviceName,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    priceJod: priceJod ?? this.priceJod,
    dateTime: dateTime ?? this.dateTime,
    address: address ?? this.address,
    notes: notes ?? this.notes,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}}
