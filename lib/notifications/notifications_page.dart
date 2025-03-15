import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../common/functions.dart';
import '../models/notification_model.dart';
import 'notification_item.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Box<NotificationModel> _notificationsBox;


  @override
  void initState() {
    super.initState();
    _notificationsBox = Hive.box<NotificationModel>('notifications');
  }

  void _markAllAsRead() {
    setState(() {
      for (NotificationModel? notif in _notificationsBox.values) {
        if (notif != null) {
          notif.isRead = true;
        } else {
          throw Exception("Notification is null or does not exist: $notif");
        }
      }
    });
  }

  void _toggleReadStatus(int index) {
    setState(() {
      final notif = _notificationsBox.getAt(index);
      if (notif != null) {
        notif.isRead = !notif.isRead;
      } else {
        throw Exception("Notification is null or does not exist at index: $index");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: _notificationsBox.values.isEmpty
          ? const Center(
        child: Text('No new notifications'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notificationsBox.values.length,
        itemBuilder: (context, index) {
          final notification = _notificationsBox.getAt(index);
          return NotificationItem(
            notification: notification ?? getSampleNotifs()[0] ,
            onTap: () => _toggleReadStatus(index),
          );
        },
      ),
    );
  }
}

