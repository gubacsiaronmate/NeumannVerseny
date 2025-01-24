import 'package:flutter/material.dart';
import 'package:on_time/common/common.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Common common = Common();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workout Page Content',
                  style: common.titelTheme,
                ),
                const SizedBox(height: 1000),
                Text(
                  'test',
                  style: common.mediumThemeblack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}