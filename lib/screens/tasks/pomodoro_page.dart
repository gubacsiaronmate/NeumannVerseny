import 'dart:async';
import 'package:flutter/material.dart';
import 'package:on_time/common/common.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  static const int workDuration = 25 * 60; // 25 minutes
  static const int breakDuration = 5 * 60; // 5 minutes

  Timer? _timer;
  int _remainingTime = workDuration;
  bool _isWorking = true;
  int _completedWorkSessions = 0;
  int _completedBreakSessions = 0;

  final Common common = Common();

  void _startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
          setState(
                () {
              if (_remainingTime > 0) {
                _remainingTime--;
              } else {
                if (_isWorking) {
                  _completedWorkSessions++;
                } else {
                  _completedBreakSessions++;
                }
                _isWorking = !_isWorking;
                _remainingTime = _isWorking ? workDuration : breakDuration;
              }
            },
          );
        },
      );
    }
  }

  void _stopTimer() {
    _timer?.cancel();
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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isWorking ? 'Work Time' : 'Break Time',
              style: common.titleTheme.copyWith(color: textColor),
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
                    color: textColor,
                  ),
                ),
                Text(
                  _formatTime(_remainingTime),
                  style: common.titleTheme.copyWith(color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  style:
                  ElevatedButton.styleFrom(backgroundColor: common.black),
                  child: Text('Start', style: common.semiboldwhite),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopTimer,
                  style:
                  ElevatedButton.styleFrom(backgroundColor: common.black),
                  child: Text('Stop', style: common.semiboldwhite),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  style:
                  ElevatedButton.styleFrom(backgroundColor: common.black),
                  child: Text('Reset', style: common.semiboldwhite),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Completed Work Sessions: $_completedWorkSessions',
              style: common.mediumTheme.copyWith(color: textColor),
            ),
            Text(
              'Completed Break Sessions: $_completedBreakSessions',
              style: common.mediumTheme.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}