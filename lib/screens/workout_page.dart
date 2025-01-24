import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          Text('Workout Page Content'),
          SizedBox(height: 1000),
          Text('test'),
        ],
      ),
    );
  }
}
