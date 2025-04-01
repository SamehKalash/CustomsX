class ShipmentStatus {
  final String event;
  final String date;
  final String time;
  final bool isCompleted;
  final bool isCurrent;

  const ShipmentStatus({
    required this.event,
    required this.date,
    required this.time,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}
