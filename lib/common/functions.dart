import 'package:hive/hive.dart';

import '../models/notification_model.dart';

List<NotificationModel> getSampleNotifs() {
  return [
    NotificationModel(
      title: "Work Session Completed",
      message: "Great job! You finished a 25-minute work session.",
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationModel(
      title: "Break Time!",
      message: "Time for a 5-minute break. Relax and recharge!",
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationModel(
      title: "Daily Goal Reached",
      message: "Congratulations! You've completed 4 work sessions today.",
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];
}

void addSampleNotifications(Box<NotificationModel> notifBox) {
  final notifications = getSampleNotifs();
  for (NotificationModel notification in notifications) {
    notifBox.add(notification);
  }
}