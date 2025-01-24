import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/end_drawer.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../screens/tasks_page.dart' as tasks;
import '../screens/workout_page.dart' as workout;
import '../screens/pomodoro_page.dart' as pomodoro;
import '../widgets/page_content.dart';
import 'package:on_time/common/common.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final Common common = Common();

  final List<Widget> _pages = [
    const PageContent(content: 'Home Page Content'),
    const tasks.TasksPage(),
    const workout.WorkoutPage(),
    const pomodoro.PomodoroPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      endDrawer: const CustomEndDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentIndex == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Welcome Back!",
                    style: common.titelTheme.copyWith(color: common.black),
                  ),
                ),
              Expanded(
                child: Scrollbar(
                  child: _pages[_currentIndex],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}