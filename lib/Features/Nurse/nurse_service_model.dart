class NurseServiceItem {
  final int serviceId;
  final int serviceCatalogId;
  final String serviceName;
  final int durationInMinutes;
  final double price;

  NurseServiceItem({
    required this.serviceId,
    required this.serviceCatalogId,
    required this.serviceName,
    required this.durationInMinutes,
    required this.price,
  });

  factory NurseServiceItem.fromJson(Map<String, dynamic> json) {
    return NurseServiceItem(
      serviceId: json['serviceId'] as int,
      serviceCatalogId: json['serviceCatalogId'] as int,
      serviceName: json['serviceName'] as String,
      durationInMinutes: json['durationInMinutes'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
}
