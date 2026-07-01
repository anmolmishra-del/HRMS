enum NotificationType {
  interview,
  offer,
  application,
  feedback,
}

class NotificationModel {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;

  const NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });

  NotificationModel copyWith({
    bool? isRead,
  }) {
    return NotificationModel(
      title: title,
      message: message,
      time: time,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}
