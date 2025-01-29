import 'package:flutter/material.dart';
import 'package:on_time/common/common.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';
import 'package:on_time/widgets/forms/custom_text_form_field.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final Common common = Common();
  final List<Map<String, dynamic>> _workouts = [];
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _addWorkout() {
    if (_exerciseController.text.isNotEmpty) {
      setState(() {
        _workouts.add({
          'exercise': _exerciseController.text,
          'sets': _setsController.text,
          'reps': _repsController.text,
          'weight': _weightController.text,
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'isCompleted': false,
        });
        _clearInputs();
      });
    }
  }

  void _clearInputs() {
    _exerciseController.clear();
    _setsController.clear();
    _repsController.clear();
    _weightController.clear();
  }

  void _deleteWorkout(String id) {
    setState(() {
      _workouts.removeWhere((workout) => workout['id'] == id);
    });
  }

  void _toggleCompletion(String id) {
    setState(() {
      final workout = _workouts.firstWhere((w) => w['id'] == id);
      workout['isCompleted'] = !workout['isCompleted'];
    });
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
                'Workout Tracker',
                style: common.titleTheme.copyWith(color: textColor),
              ),
              const SizedBox(height: 20),

              // Input Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hinttext: 'Exercise Name',
                        obsecuretext: false,
                        controller: _exerciseController,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              hinttext: 'Sets',
                              obsecuretext: false,
                              controller: _setsController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              hinttext: 'Reps',
                              obsecuretext: false,
                              controller: _repsController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              hinttext: 'Weight (kg)',
                              obsecuretext: false,
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      CustomElevatedButton(
                        message: 'Add Exercise',
                        icon: Icons.fitness_center,
                        function: _addWorkout,
                        color: common.maincolor,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          fixedSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Workout List
              Expanded(
                child: _workouts.isEmpty
                    ? Center(
                  child: Text(
                    'No exercises logged!\nStart your workout!',
                    style: common.mediumThemeblack,
                    textAlign: TextAlign.center,
                  ),
                )
                    : ListView.builder(
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    final workout = _workouts[index];
                    return Dismissible(
                      key: Key(workout['id']),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) => _deleteWorkout(workout['id']),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: workout['isCompleted'],
                            onChanged: (value) => _toggleCompletion(workout['id']),
                            activeColor: common.maincolor,
                          ),
                          title: Text(
                            workout['exercise'],
                            style: common.semiboldblack.copyWith(
                              decoration: workout['isCompleted']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(
                            '${workout['sets']} sets × ${workout['reps']} reps × ${workout['weight']}kg',
                            style: common.mediumThemeblack,
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