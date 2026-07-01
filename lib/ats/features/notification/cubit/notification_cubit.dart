import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/notification/model/model_class.dart';
import 'package:flutter_app/ats/features/notification/state/notification_state.dart';


class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsState.initial()) {
    loadNotifications();
  }

  void loadNotifications() {
    emit(
      state.copyWith(
        notifications: [
          const NotificationModel(
            title: "Interview Scheduled",
            message:
                "Your interview for Flutter Developer is scheduled on 20 May 2024 at 11:00 AM",
            time: "2m ago",
            type: NotificationType.interview,
            isRead: false,
          ),
          const NotificationModel(
            title: "Offer Accepted",
            message: "Arjun Mehta has accepted the offer",
            time: "1h ago",
            type: NotificationType.offer,
            isRead: false,
          ),
          const NotificationModel(
            title: "New Application",
            message:
                "You have received a new application for UI/UX Designer",
            time: "3h ago",
            type: NotificationType.application,
            isRead: true,
          ),
          const NotificationModel(
            title: "Feedback Pending",
            message: "Please provide feedback for Rohit Verma",
            time: "5h ago",
            type: NotificationType.feedback,
            isRead: true,
          ),
        ],
      ),
    );
  }

  void markAsRead(int index) {
    final updatedList = [...state.notifications];

    updatedList[index] =
        updatedList[index].copyWith(isRead: true);

    emit(
      state.copyWith(
        notifications: updatedList,
      ),
    );
  }

  void markAllAsRead() {
    final updatedList = state.notifications
        .map(
          (e) => e.copyWith(isRead: true),
        )
        .toList();

    emit(
      state.copyWith(
        notifications: updatedList,
      ),
    );
  }

  void deleteNotification(int index) {
    final updatedList = [...state.notifications];

    updatedList.removeAt(index);

    emit(
      state.copyWith(
        notifications: updatedList,
      ),
    );
  }
}
