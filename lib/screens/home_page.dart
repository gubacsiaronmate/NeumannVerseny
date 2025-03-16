import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:on_time/models/notification_model.dart';
import 'package:on_time/notifications/notification_item.dart';
import '../common/common.dart';
import '../notifications/notifications_page.dart';
import '../services/appwrite_service.dart';
import '../widgets/app_bar/app_bar.dart';
import '../widgets/navigation/end_drawer.dart';
import 'tasks/tasks_page.dart' as tasks;
import 'workout/workout_page.dart' as workout;
import 'tasks/pomodoro_page.dart' as pomodoro;
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
  late final String username;
  late final Box<NotificationModel> _notifBox;

  final List<Widget> _pages = [
    Container(),
    const tasks.TasksPage(),
    const workout.WorkoutPage(),
    const pomodoro.PomodoroPage(),
  ];

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _checkSession();
    _notifBox = Hive.box<NotificationModel>('notifications');
  }

  Future<void> _setUsername() async {
    username = await _appwriteService.getUsername();
  }

  Future<void> _checkSession() async {
    final hasSession = await _appwriteService.hasActiveSession();
    await _setUsername();
    if (!hasSession && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const login.LoginPage()),
        (Route<dynamic> route) => false,
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

  Future<List<Map<String, dynamic>>> _loadTasks() async {
    try {
      final String userId = await _appwriteService.getCurrentUserId();
      final taskDocuments = await _appwriteService.getTasks(userId);
      return taskDocuments.map((task) => task.data).toList();
    } catch (e) {
      print("Error loading tasks: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final unselectedItemColor = isDarkMode
        ? Colors.white70
        : Theme.of(context).colorScheme.onSurface;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        SystemNavigator.pop();
      },

      child: Scaffold(
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Welcome $username",
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(color: textColor)),

                              const SizedBox(height: 16),
                              if (_notifBox.isNotEmpty)
                                NotificationItem(
                                  notification: _notifBox.values.toList().latest(),
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const NotificationScreen()),
                                    );

                                    if (mounted) { setState(() {}); }
                                  }
                                ),

                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("My Tasks",
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor)),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _currentIndex = 1;
                                      });
                                    },
                                    child: Text("View All",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold
                                        )),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              Flexible(
                                fit: FlexFit.loose,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _currentIndex = 1; // Switch to Tasks page index
                                    });
                                  },
                                  child: FutureBuilder<List<Map<String, dynamic>>>(
                                    future: _loadTasks(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                        return Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.surfaceContainer,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'No tasks yet. Tap to add some!',
                                              style: TextStyle(color: textColor.withOpacity(0.6)),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }

                                      return Container(
                                        height: 200,
                                        child: ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            final task = snapshot.data![index];
                                            return Card(
                                              margin: const EdgeInsets.symmetric(vertical: 4),
                                              elevation: 2,
                                              child: ListTile(
                                                leading: Icon(
                                                  task['is_completed'] ? Icons.check_circle : Icons.circle_outlined,
                                                  color: task['is_completed'] ? Colors.green : Colors.grey,
                                                ),
                                                title: Text(
                                                  task['title'],
                                                  style: TextStyle(
                                                    color: textColor,
                                                    decoration: task['is_completed'] ? TextDecoration.lineThrough : null,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

extension NotificationListExtension on List<NotificationModel> {
  NotificationModel latest() =>
      (this..sort((a, b) => b.time.compareTo(a.time))).first;
}