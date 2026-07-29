import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/notification/cubit/notification_cubit.dart';
import 'package:flutter_app/ats/features/notification/model/model_class.dart';
import 'package:flutter_app/ats/features/notification/state/notification_state.dart';



class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context
                  .read<NotificationsCubit>()
                  .markAllAsRead();
            },
            child: const Text(
              "Mark all as read",
              style: TextStyle(
                color: Color(0xff5B3FFF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<
          NotificationsCubit,
          NotificationsState>(
        builder: (context, state) {
          if (state.notifications.isEmpty) {
            return const Center(
              child: Text(
                "No Notifications",
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.notifications.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final notification =
                  state.notifications[index];

              return Dismissible(
                key: ValueKey(index),
                direction:
                    DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding:
                      const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) {
                  context
                      .read<NotificationsCubit>()
                      .deleteNotification(index);
                },
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<NotificationsCubit>()
                        .markAsRead(index);
                  },
                  child: NotificationCard(
                    notification: notification,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : const Color(0xffF5F3FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xffEAEAEA),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: getColor().withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getIcon(),
              color: getColor(),
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),

                    if (!notification.isRead)
                      Container(
                        height: 8,
                        width: 8,
                        decoration:
                            const BoxDecoration(
                          color: Color(0xff5B3FFF),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  notification.time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData getIcon() {
    switch (notification.type) {
      case NotificationType.interview:
        return Icons.calendar_month_outlined;

      case NotificationType.offer:
        return Icons.check_circle_outline;

      case NotificationType.application:
        return Icons.description_outlined;

      case NotificationType.feedback:
        return Icons.error_outline;
    }
  }

  Color getColor() {
    switch (notification.type) {
      case NotificationType.interview:
        return Colors.blue;

      case NotificationType.offer:
        return Colors.green;

      case NotificationType.application:
        return Colors.orange;

      case NotificationType.feedback:
        return Colors.red;
    }
  }
}
