enum NurseServiceRequestStatus { pending, accepted, declined }

enum NurseRequestsFilter { all, pending, accepted }

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
  }
}

