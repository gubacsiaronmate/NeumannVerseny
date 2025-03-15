import 'package:hive/hive.dart';
part 'notification_model.g.dart';

@HiveType(typeId: 1)
class NotificationModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final DateTime time;

  @HiveField(3)
  bool isRead;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}