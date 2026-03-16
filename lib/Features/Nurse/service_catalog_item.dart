class ServiceCatalogItem {
  final int serviceCatalogId;
  final String name;
  final int defaultDurationInMinutes;

  ServiceCatalogItem({
    required this.serviceCatalogId,
    required this.name,
    required this.defaultDurationInMinutes,
  });

  factory ServiceCatalogItem.fromJson(Map<String, dynamic> json) {
    return ServiceCatalogItem(
      serviceCatalogId: json['serviceCatalogId'] as int,
      name: json['name'] as String,
      defaultDurationInMinutes: json['defaultDurationInMinutes'] as int,
    );
  }
}
