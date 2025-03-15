import 'package:flutter/material.dart';
import 'package:on_time/services/appwrite_service.dart';
import 'package:on_time/screens/workout/program_details_page.dart';
import 'package:on_time/screens/workout/program_name_controller.dart';

import '../../widgets/misc/cell.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final List<Map<String, dynamic>> _workoutPrograms = [];
  final AppwriteService _appwriteService = AppwriteService();

  Future<void> _createNewProgram(String programName) async {
    final program = {
      "programName": programName,
      "userId": _appwriteService.getCurrentUserId(),
      "id": DateTime.now().millisecondsSinceEpoch.toString()
    };

    setState(() {
      _workoutPrograms.add(program);
    });

    try {
      await _appwriteService.addWorkout(program);
    } catch (e) {
      print("Update Error: $e");
      rethrow;
    }
  }

  void _deleteWorkout(String id) async {

  }

  void _navigateToCreateProgram(BuildContext context) async {
    final programName = await showDialog<String>(
      context: context,
      builder: (context) => CreateProgramDialog(),
    );
    print("""
    \n\n\n
    programName: $programName\n
    programName != null: ${programName != null}
    programName.isNotEmpty: ${programName != null ? programName.isNotEmpty : "programName is null"}\n
    \n\n\n
    """);
    if (programName != null && programName.isNotEmpty) {
      await _createNewProgram(programName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Library'),
      ),
      body: _workoutPrograms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No workout programs found.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _navigateToCreateProgram(context),
                    child: const Text('Create Your First Program'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _workoutPrograms.length,
              itemBuilder: (context, index) {
                final workoutId = _workoutPrograms[index]['id'];
                return Dismissible(
                  key: Key(workoutId),
                  background: Container(color: Colors.red),
                  onDismissed: (_) => _deleteWorkout(workoutId),
                  child: Cell(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: ListTile(
                      title: Text(_workoutPrograms[index]["programName"]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramDetailsPage(
                              programName: _workoutPrograms[index]["programName"],
                            ),
                          ),
                        );
                      },
                      trailing: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateProgram(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}