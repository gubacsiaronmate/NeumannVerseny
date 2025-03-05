import 'package:flutter/material.dart';
import 'package:on_time/common/common.dart';
import 'package:on_time/services/appwrite_service.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
import 'package:on_time/widgets/forms/custom_text_form_field.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final Common common = Common();
  final TextEditingController _taskController = TextEditingController();
  final AppwriteService appwriteService = AppwriteService();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    assignTaskValue();
  }

  void assignTaskValue() async {
    final String userId = await appwriteService.getCurrentUserId();
    final taskList = await appwriteService.getTasks(userId);
    setState(() {
      _tasks = taskList.map((task) => task.data).toList();
    });
  }

  void _addTask() async {
    if (_taskController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title cannot be empty!')),
      );
      return;
    }

    String taskTitle = _taskController.text;
    String userId = await appwriteService.getCurrentUserId();

    Map<String, dynamic> task = {
      'title': taskTitle,
      'is_completed': false,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': userId,
    };

    try {
      await appwriteService.addTask(task);
      setState(() {
        _tasks.add(task);
        _taskController.clear();
      });
    } catch (e) {
      print("Adding Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: $e')),
      );
    }
  }

  void _deleteTask(String id) async {
    try {
      await appwriteService.deleteTask(id);
      setState(() {
        _tasks.removeWhere((task) => task['id'] == id);
      });
    } catch (e) {
      print("Delete Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $e')),
      );
    }
  }

  void _toggleCompletion(String id) async {
    final task = _tasks.firstWhere((t) => t['id'] == id);
    final updatedTask = {...task, 'is_completed': !task['is_completed']};

    try {
      await appwriteService.updateTask(updatedTask);
      setState(() {
        final index = _tasks.indexWhere((t) => t['id'] == id);
        _tasks[index] = updatedTask;
      });
    } catch (e) {
      print("Update Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Tasks',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(color: textColor),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      hinttext: 'Add new task...',
                      obsecuretext: false,
                      controller: _taskController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomElevatedButton(
                    message: 'Add',
                    icon: Icons.add,
                    function: _addTask,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      fixedSize: WidgetStateProperty.all(const Size(100, 50)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: _tasks.isEmpty
                    ? Center(
                  child: Text(
                    'No tasks yet!\nStart by adding one.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                )
                    : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Dismissible(
                      key: Key(task['id']),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) => _deleteTask(task['id']),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task['is_completed'] ?? false,
                            onChanged: (value) => _toggleCompletion(task['id']),
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            task['title'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              decoration: task['is_completed']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}