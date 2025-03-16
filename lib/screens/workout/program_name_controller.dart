import 'package:flutter/material.dart';

class CreateProgramDialog extends StatelessWidget {
  final TextEditingController _programNameController = TextEditingController();

  CreateProgramDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Program'),
      content: TextField(
        controller: _programNameController,
        decoration: const InputDecoration(hintText: 'Enter program name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_programNameController.text.isNotEmpty) {
              Navigator.pop(context, _programNameController.text);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Program name cannot be empty!")),
              );
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}