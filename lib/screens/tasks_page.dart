import 'package:flutter/material.dart';
import 'package:on_time/common/common.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

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
                  'Tasks Page Content',
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