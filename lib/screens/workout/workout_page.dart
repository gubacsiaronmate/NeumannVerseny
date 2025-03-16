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
  final AppwriteService _appwriteService = AppwriteService();
  List<Map<String, dynamic>> _workoutPrograms = [];

  @override
  void initState() {
    super.initState();
    _assignWorkoutProgramsValue();
  }

  void _assignWorkoutProgramsValue() async {
    final userId = await _appwriteService.getCurrentUserId();
    final workouts = await _appwriteService.getWorkouts(userId);
    setState(() {
      _workoutPrograms = workouts.map((doc) => doc.data).toList();
    });
  }

  Future<void> _createNewProgram(String programName) async {
    final userId = await _appwriteService.getCurrentUserId();

    final program = {
      "programName": programName,
      "userId": userId,
      "id": DateTime.now().millisecondsSinceEpoch.toString()
    };

    try {
      await _appwriteService.addWorkout(program);
      setState(() {
        _workoutPrograms.add(program);
      });
    } catch (e) {
      print("Adding Error: $e");
      rethrow;
    }
  }

  void _deleteWorkout(String workoutId) async {
    try {
      await _appwriteService.deleteWorkout(workoutId);
      _workoutPrograms.removeWhere((workout) => workout["id"] == workoutId);
    } catch (e) {
      print("Delete error: $e");
      rethrow;
    }
  }

  void _navigateToCreateProgram(BuildContext context) async {
    final programName = await showDialog<String>(
      context: context,
      builder: (context) => CreateProgramDialog(),
    );
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
                      onTap: () async {
                        final updatedExercises = await Navigator.push<List<Map<String, dynamic>>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramDetailsPage(
                              programName: _workoutPrograms[index]["programName"],
                            ),
                          ),
                        );

                        if (updatedExercises != null) {
                          for (var exercise in updatedExercises) {
                            if (!exercise.keys.contains("id")) {
                              exercise['id'] = DateTime.now().millisecondsSinceEpoch.toString();
                            }
                          }
                          
                          setState(() {
                            _workoutPrograms[index].addAll({"exercises": updatedExercises.map((exercise) => exercise['id']).toList()});
                          });

                          await _appwriteService.updateWorkout(_workoutPrograms[index]);
                        }
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