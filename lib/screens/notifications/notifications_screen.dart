import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationModel> _notifications = [
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

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  void _toggleReadStatus(NotificationModel notification) {
    setState(() {
      notification.isRead = !notification.isRead;
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
      body: _notifications.isEmpty
          ? const Center(
        child: Text('No new notifications'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return NotificationItem(
            notification: notification,
            onTap: () => _toggleReadStatus(notification),
          );
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          alignment: Alignment.topCenter,
          child: Icon(
            Icons.circle,
            color: notification.isRead ? Colors.transparent : Colors.blue,
            size: 12,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, hh:mm a').format(notification.time),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class NotificationModel {
  final String title;
  final String message;
  final DateTime time;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}