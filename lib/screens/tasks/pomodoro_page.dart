import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:on_time/common/common.dart';
import 'package:on_time/widgets/buttons/custom_elevated_button.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> with WidgetsBindingObserver {
  final int _workDuration = 25 * 60;  // 25 minutes in seconds
  final int _breakDuration = 5 * 60;  // 5 minutes in seconds

  Timer? _timer;
  int _remainingTime = 25 * 60;
  bool _isWorking = true;
  bool _isPaused = false;
  int _completedWorkSessions = 0;
  int _completedBreakSessions = 0;
  int _totalElapsed = 0;
  DateTime? _sessionStartTime;

  final Common common = Common();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remainingTime = _workDuration;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_timer == null || !_timer!.isActive) {
      setState(() {
        _isPaused = false;
        _sessionStartTime = DateTime.now().subtract(Duration(seconds: _totalElapsed));
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _totalElapsed += 1;
          _remainingTime = (_isWorking ? _workDuration : _breakDuration) - _totalElapsed;

          if (_remainingTime <= 0) {
            _handleTimerCompletion();
          }
        });
      });
    }
  }

  void _handleTimerCompletion() {
    _playNotification();
    _timer?.cancel();
    setState(() {
      if (_isWorking) {
        _completedWorkSessions++;
      } else {
        _completedBreakSessions++;
      }
      _isWorking = !_isWorking;
      _remainingTime = _isWorking ? _workDuration : _breakDuration;
      _isPaused = false;
      _totalElapsed = 0;
      _sessionStartTime = null;
    });
    _startTimer();
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isPaused = true);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isWorking = true;
      _remainingTime = _workDuration;
      _isPaused = false;
      _totalElapsed = 0;
      _sessionStartTime = null;
    });
  }

  Future<void> _playNotification() async {
    try {
      await _audioPlayer.play(AssetSource('assets/sounds/notification.mp3'));
      HapticFeedback.vibrate();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pauseTimer();
    }
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  String _calculateEndTime() {
    if (_isPaused || _sessionStartTime == null) {
      return '--:--';
    }
    final duration = _isWorking ? _workDuration : _breakDuration;
    final endTime = _sessionStartTime!.add(Duration(seconds: duration));
    return '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  double _getProgress() => _remainingTime / (_isWorking ? _workDuration : _breakDuration);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isWorking ? 'Work Time' : 'Break Time',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: AnimatedCircularProgressIndicator(
                          value: _getProgress(),
                          strokeWidth: 20,
                          color: _isPaused ? Colors.grey : textColor,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            _formatTime(_remainingTime),
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications, color: textColor),
                              const SizedBox(width: 5),
                              Text(
                                _calculateEndTime(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          if (_isPaused) ...[
                            const SizedBox(height: 10),
                            Text(
                              'Paused',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SessionCount(
                        label: 'Work Sessions',
                        count: _completedWorkSessions,
                        color: textColor,
                      ),
                      const SizedBox(width: 30),
                      _SessionCount(
                        label: 'Break Sessions',
                        count: _completedBreakSessions,
                        color: textColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0, left: 8, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    message: _isPaused ? 'Resume' : 'Start',
                    icon: _isPaused ? Icons.play_arrow : Icons.play_arrow,
                    function: _isPaused ? _startTimer : _startTimer,
                    color: Theme.of(context).colorScheme.onBackground,
                    style: _buttonStyle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomElevatedButton(
                    message: 'Pause',
                    icon: Icons.pause,
                    function: _pauseTimer,
                    color: Theme.of(context).colorScheme.onBackground,
                    style: _buttonStyle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomElevatedButton(
                    message: 'Reset',
                    icon: Icons.refresh,
                    function: _resetTimer,
                    color: Theme.of(context).colorScheme.onBackground,
                    style: _buttonStyle,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  final ButtonStyle _buttonStyle = ButtonStyle(
    shape: MaterialStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    )),
    minimumSize: MaterialStateProperty.all(const Size(0, 50)),
    maximumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
    side: MaterialStateProperty.all(const BorderSide(color: Colors.grey)),
  );
}

class _SessionCount extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SessionCount({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class AnimatedCircularProgressIndicator extends StatelessWidget {
  final double value;
  final double strokeWidth;
  final Color color;

  const AnimatedCircularProgressIndicator({
    super.key,
    required this.value,
    required this.strokeWidth,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return CircularProgressIndicator(
          value: value,
          strokeWidth: strokeWidth,
          color: color,
          backgroundColor: color.withOpacity(0.2),
          strokeCap: StrokeCap.round,
        );
      },
    );
  }
}