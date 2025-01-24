import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  static const int workDuration = 25 * 60; // 25 minutes
  static const int breakDuration = 5 * 60; // 5 minutes

  late Timer _timer;
  int _remainingTime = workDuration;
  bool _isWorking = true;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isWorking = !_isWorking;
          _remainingTime = _isWorking ? workDuration : breakDuration;
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _isWorking = true;
      _remainingTime = workDuration;
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double _getProgress() {
    final int totalDuration = _isWorking ? workDuration : breakDuration;
    return _remainingTime / totalDuration;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isWorking ? 'Work Time' : 'Break Time',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _getProgress(),
                    strokeWidth: 10,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _formatTime(_remainingTime),
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text('Start'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: const Text('Stop'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}