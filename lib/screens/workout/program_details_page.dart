import 'package:flutter/material.dart';
import 'package:on_time/services/appwrite_service.dart';
import 'add_exercise_page.dart';

class ProgramDetailsPage extends StatefulWidget {
  final String programName;

  const ProgramDetailsPage({required this.programName, super.key});

  @override
  State<ProgramDetailsPage> createState() => _ProgramDetailsPageState();
}

class _ProgramDetailsPageState extends State<ProgramDetailsPage> {
  final List<Map<String, dynamic>> _exercises = [];
  final AppwriteService appwriteService = AppwriteService();
  String get programName => widget.programName;

  void _addExercise(Map<String, dynamic> exercise) {
    setState(() {
      _exercises.add(exercise);
    });

    try {
      appwriteService.addExercises(programName, _exercises);
    } catch (e) {
      print("Update Error: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.programName),
      ),
      body: Column(
        children: [
          Expanded(
            child: _exercises.isEmpty
                ? const Center(child: Text('No exercises added yet.'))
                : ListView.builder(
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                final exercise = _exercises[index];
                return ListTile(
                  title: Text(exercise['name']),
                  subtitle: Text('${exercise['sets']} sets × ${exercise['reps']} reps × ${exercise['weight']}kg'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddExercisePage(
                    onExerciseAdded: _addExercise,
                  ),
                ),
              );
            },
            child: const Text('Add Exercise'),
          ),
        ],
      ),
    );
  }
}