import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Text('Tasks Page Content'),
          SizedBox(height: 1000),
          Text('test'),
        ],
      ),
    );
  }
}
