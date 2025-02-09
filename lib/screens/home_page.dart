import 'package:flutter/material.dart';
import '../appwrite/appwrite_service.dart';
import '../common/common.dart';
import '../services/appwrite_service.dart';
import '../widgets/app_bar/app_bar.dart';
import '../widgets/navigation/end_drawer.dart';
import 'tasks/tasks_page.dart' as tasks;
import 'workout/workout_page.dart' as workout;
import 'tasks/pomodoro_page.dart' as pomodoro;
import '../widgets/misc/page_content.dart';
import 'auth/login_page.dart' as login;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final Common common = Common();
  late final AppwriteService _appwriteService;
  bool _isCheckingSession = true;

  final List<Widget> _pages = [
    const PageContent(content: 'Home Page Content'),
    const tasks.TasksPage(),
    const workout.WorkoutPage(),
    const pomodoro.PomodoroPage(),
  ];

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final hasSession = await _appwriteService.hasActiveSession();
    if (!hasSession && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login.LoginPage()),
      );
    } else {
      setState(() => _isCheckingSession = false);
    }
  }

  void _handleLogout() async {
    try {
      final isAuthenticated = await _appwriteService.hasActiveSession();
      if (isAuthenticated) {
        await _appwriteService.logoutUser();
        if (mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const login.LoginPage()),
          );
        }
      } else {
        if (mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const login.LoginPage()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final unselectedItemColor = isDarkMode
        ? Colors.white70
        : Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      appBar: CustomAppBar(
        onLogout: _handleLogout,
      ),
      endDrawer: const CustomEndDrawer(),
      body: _isCheckingSession
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    Expanded(
                      child: Scrollbar(
                        child: IndexedStack(
                          index: _currentIndex,
                          children: _pages,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: unselectedItemColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_outlined),
            activeIcon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            activeIcon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer),
            label: 'Pomodoro',
          ),
        ],
      ),
    );
  }
}
