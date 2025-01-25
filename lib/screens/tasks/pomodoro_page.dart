import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For vibration support
import 'package:audioplayers/audioplayers.dart'; // For sound effects
import 'package:on_time/common/common.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  static const int workDuration = 25; // 25 minutes
  static const int breakDuration = 5; // 5 minutes

  Timer? _timer;
  int _remainingTime = workDuration;
  bool _isWorking = true;
  bool _isPaused = false;
  int _completedWorkSessions = 0;
  int _completedBreakSessions = 0;

  final Common common = Common();
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
          setState(() {
            if (_remainingTime > 0) {
              _remainingTime--;
            } else {
              _playNotification();
              if (_isWorking) {
                _completedWorkSessions++;
              } else {
                _completedBreakSessions++;
              }
              _isWorking = !_isWorking;
              _remainingTime = _isWorking ? workDuration : breakDuration;
            }
          });
        },
      );
    }
  }

  void _pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      setState(() {
        _isPaused = true;
      });
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      _startTimer();
      setState(() {
        _isPaused = false;
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isWorking = true;
      _remainingTime = workDuration;
      _isPaused = false;
    });
  }

  Future<void> _playNotification() async {
    await _audioPlayer.play(
      AssetSource('assets/sounds/notification.mp3'),
    );
    HapticFeedback.vibrate();
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _calculateEndTime() {
    final DateTime now = DateTime.now();
    final DateTime endTime = now.add(Duration(seconds: _remainingTime));
    return '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  double _getProgress() {
    final int totalDuration = _isWorking ? workDuration : breakDuration;
    return _remainingTime / totalDuration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Space between the top and bottom sections
        children: [
          // Centered part
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isWorking ? 'Work Time' : 'Break Time',
                    style: common.titleTheme.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: AnimatedCircularProgressIndicator(
                            value: _getProgress(),
                            strokeWidth: 20,
                            color: textColor,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatTime(_remainingTime),
                              style: common.titleTheme.copyWith(
                                  color: textColor),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.notifications_rounded, color: textColor),
                                const SizedBox(width: 5),
                                Text(
                                  _calculateEndTime(),
                                  style: common.mediumTheme.copyWith(
                                      color: textColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom part
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: CustomElevatedButton(
                      message: _isPaused ? 'Resume' : 'Start',
                      icon: _isPaused ? Icons.play_arrow : Icons.play_arrow,
                      function: _isPaused ? _resumeTimer : _startTimer,
                      color: common.black,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        fixedSize: MaterialStateProperty.all(const Size(130, 50)),
                        side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: CustomElevatedButton(
                      message: 'Pause',
                      icon: Icons.pause,
                      function: _pauseTimer,
                      color: common.black,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        fixedSize: MaterialStateProperty.all(const Size(130, 50)),
                        side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: CustomElevatedButton(
                      message: 'Reset',
                      icon: Icons.refresh,
                      function: _resetTimer,
                      color: common.black,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        fixedSize: MaterialStateProperty.all(const Size(130, 50)),
                        side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedCircularProgressIndicator extends StatelessWidget {
  final double value;
  final double strokeWidth;
  final Color color;

  const AnimatedCircularProgressIndicator({
    Key? key,
    required this.value,
    required this.strokeWidth,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: value),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return CircularProgressIndicator(
          value: value,
          strokeWidth: strokeWidth,
          color: color,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeCap: StrokeCap.round,
        );
      },
    );
  }
}