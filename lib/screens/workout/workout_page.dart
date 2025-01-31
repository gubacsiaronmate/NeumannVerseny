import 'package:flutter/material.dart';
import 'package:on_time/common/common.dart';
import 'package:on_time/screens/workout/program_details_page.dart';
import 'package:on_time/screens/workout/program_name_controller.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
import 'package:on_time/widgets/forms/custom_text_form_field.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final List<String> _workoutPrograms = [];

  void _createNewProgram(String programName) {
    setState(() {
      _workoutPrograms.add(programName);
    });
  }

  void _navigateToCreateProgram(BuildContext context) async {
    final programName = await showDialog<String>(
      context: context,
      builder: (context) => CreateProgramDialog(),
    );
    if (programName != null && programName.isNotEmpty) {
      _createNewProgram(programName);
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
                return ListTile(
                  title: Text(_workoutPrograms[index]),
                  onTap: () {
                    // Navigate to the program details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProgramDetailsPage(
                          programName: _workoutPrograms[index],
                        ),
                      ),
                    );
                  },
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