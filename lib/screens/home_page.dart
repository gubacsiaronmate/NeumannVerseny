import 'package:flutter/material.dart';
import '../widgets/app_bar/app_bar.dart';
import '../widgets/navigation/end_drawer.dart';
import 'tasks/tasks_page.dart' as tasks;
import 'workout/workout_page.dart' as workout;
import 'tasks/pomodoro_page.dart' as pomodoro;
import '../widgets/misc/page_content.dart';
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final unselectedItemColor = isDarkMode ? Colors.white70 : common.black;

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
                    style: common.titleTheme,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: common.white,
        selectedItemColor: common.maincolor,
        unselectedItemColor: unselectedItemColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Pomodoro',
          ),
        ],
      ),
    );
  }
}