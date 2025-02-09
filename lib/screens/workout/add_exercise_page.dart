import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddExercisePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onExerciseAdded;

  const AddExercisePage({required this.onExerciseAdded, super.key});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _addExercise() {
    if (_nameController.text.isNotEmpty &&
        _setsController.text.isNotEmpty &&
        _repsController.text.isNotEmpty &&
        _weightController.text.isNotEmpty) {
      widget.onExerciseAdded({
        'name': _nameController.text,
        'sets': _setsController.text,
        'reps': _repsController.text,
        'weight': _weightController.text,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Exercise Name'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _setsController,
              decoration: const InputDecoration(hintText: 'Sets'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _repsController,
              decoration: const InputDecoration(hintText: 'Reps'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(hintText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addExercise,
              child: const Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}