/// Model representing a service offered by a nurse.
class NurseServiceItem {
  final String name;
  final int durationMinutes;
  final int priceJod;

  const NurseServiceItem({
    required this.name,
    required this.durationMinutes,
    required this.priceJod,
  });
}
