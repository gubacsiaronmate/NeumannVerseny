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
  final List<Map<String, dynamic>> _tasks = [];
  final AppwriteService appwriteService = AppwriteService();

  void _addTask() async {
    Map<String, dynamic> task = {
      'title': _taskController.text.isNotEmpty ? _taskController.text : null,
      'is_completed': false,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    };
    setState(() {
      _tasks.add(task);
      _taskController.clear();
    });

    try {
      appwriteService.addTask(task);
    } catch (e) {
      print("Update Error: $e");
      rethrow;
    }
  }

  void _deleteTask(String id) async {
    setState(() {
      _tasks.removeWhere((task) => task['id'] == id);
    });

    try {
      appwriteService.deleteTask(id);
    } catch (e) {
      print("Update Error: $e");
      rethrow;
    }
  }

  void _toggleCompletion(String id) async {
    final task = _tasks.firstWhere((t) => t['id'] == id);

    setState(() {
      final i = _tasks.indexOf(task);
      _tasks[i]["is_completed"] = !_tasks[i]["is_completed"];
    });

    try {
      appwriteService.updateTask(task);
    } catch (e) {
      print("Update Error: $e");
      rethrow;
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
                style: common.titleTheme.copyWith(color: textColor),
              ),
              const SizedBox(height: 20),
              // Task Input Row
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
                    color: common.maincolor,
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
              // Task List
              Expanded(
                child: _tasks.isEmpty
                    ? Center(
                  child: Text(
                    'No tasks yet!\nStart by adding one.',
                    style: common.mediumThemeblack,
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
                            value: task['isCompleted'],
                            onChanged: (value) => _toggleCompletion(task['id']),
                            activeColor: common.maincolor,
                          ),
                          title: Text(
                            task['title'],
                            style: common.semiboldblack.copyWith(
                              decoration: task['isCompleted']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: Icon(
                            Icons.delete_outline,
                            color: common.maincolor,
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