class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type;
  final int? bookingId;
  final bool isRead;
  final DateTime createdAt;
  final String? targetScreen;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.bookingId,
    required this.isRead,
    required this.createdAt,
    required this.targetScreen,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['notificationId'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      bookingId: json['bookingId'],
      isRead: json['isRead'],
   createdAt: DateTime.parse(json['createdAt'] + 'Z').toLocal(),
      targetScreen: json['targetScreen'],
    );
  }
}