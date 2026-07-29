import 'package:flutter_app/ats/features/notification/model/model_class.dart';

class NotificationsState {
  final List<NotificationModel> notifications;
  final bool isLoading;

  const NotificationsState({
    required this.notifications,
    required this.isLoading,
  });

  factory NotificationsState.initial() {
    return const NotificationsState(
      notifications: [],
      isLoading: false,
    );
  }

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
