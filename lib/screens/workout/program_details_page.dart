import 'package:flutter/material.dart';
import 'package:on_time/services/appwrite_service.dart';
import '../../widgets/misc/cell.dart';
import 'add_exercise_page.dart';

class ProgramDetailsPage extends StatefulWidget {
  final String programName;

  const ProgramDetailsPage({required this.programName, super.key});

  @override
  State<ProgramDetailsPage> createState() => _ProgramDetailsPageState();
}

class _ProgramDetailsPageState extends State<ProgramDetailsPage> {
  List<Map<String, dynamic>> _exercises = [];
  final AppwriteService _appwriteService = AppwriteService();
  String get programName => widget.programName;

  @override
  void initState() {
    super.initState();
    _assignExercisesValue();
  }

  void _assignExercisesValue() async {
    final userId = await _appwriteService.getCurrentUserId();
    final exercises = await _appwriteService.getExercises(userId);
    setState(() {
      _exercises = exercises.map((doc) => doc.data).toList();
    });
  }

  void _addExercise(Map<String, dynamic> exercise) async {
    try {
      exercise['userId'] = await _appwriteService.getCurrentUserId();

      await _appwriteService.addExercise(exercise);
      setState(() {
        _exercises.add(exercise);
      });
    } catch (e) {
      print("Adding error: $e");
      rethrow;
    }
  }
  
  void _deleteExercise(String exId) async {
    try {
      await _appwriteService.deleteExercise(exId);
      setState(() {
        _exercises.removeWhere((exercise) => exercise['id'] == exId);
      });
    } catch (e) {
      print("Delete error: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.of(context).pop(_exercises);
      },
      child: Scaffold(
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
                  return Dismissible(
                    key: Key(exercise['id']),
                    background: Container(color: Colors.red),
                    onDismissed: (_) => _deleteExercise(exercise['id']),
                    child: Cell(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: ListTile(
                        title: Text(exercise['name']),
                        subtitle: Text('${exercise['sets']} sets × ${exercise['reps']} reps × ${exercise['weight']}kg'),
                        trailing: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ),
                    ),
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
      ),
    );
  }
}