import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/models/course.dart';
import 'package:peiban_app/services/app_state.dart';
import 'package:peiban_app/widgets/course_favorite_button.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  const WorkoutPlayerScreen({
    super.key,
    required this.course,
    required this.appState,
    required this.onCompleted,
  });

  final Course course;
  final AppState appState;
  final VoidCallback onCompleted;

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _currentStep = 0;
  bool _isRunning = false;
  bool _isFinished = false;

  int get _totalSeconds => widget.course.durationMinutes * 60;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isFinished) return;
    setState(() => _isRunning = !_isRunning);
    if (_isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_elapsedSeconds >= _totalSeconds) {
          _finishWorkout();
          return;
        }
        setState(() => _elapsedSeconds++);
      });
    } else {
      _timer?.cancel();
    }
  }

  Future<void> _finishWorkout() async {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isFinished = true;
    });
    await widget.appState.completeCourse(
      courseId: widget.course.id,
      durationMinutes: widget.course.durationMinutes,
      calories: widget.course.calories,
    );
    widget.onCompleted();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('训练完成，数据已记录！')),
      );
    }
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final progress = _elapsedSeconds / _totalSeconds;

    return Scaffold(
      backgroundColor: AppColors.slate900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(course.title, style: const TextStyle(fontSize: 14)),
        actions: [
          CourseFavoriteButton(
            courseId: course.id,
            appState: widget.appState,
            onStateChanged: widget.onCompleted,
            iconColor: Colors.white,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(course.imageAsset, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.55)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    _formatTime(_elapsedSeconds),
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '目标 ${_formatTime(_totalSeconds)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandPink),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '步骤 ${_currentStep + 1}/${course.steps.length}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.steps[_currentStep],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _currentStep > 0
                            ? () => setState(() => _currentStep--)
                            : null,
                        icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: _toggleTimer,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: AppColors.brandGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFinished
                                ? Icons.check
                                : (_isRunning ? Icons.pause : Icons.play_arrow),
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        onPressed: _currentStep < course.steps.length - 1
                            ? () => setState(() => _currentStep++)
                            : null,
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!_isFinished)
                    TextButton(
                      onPressed: _finishWorkout,
                      child: const Text(
                        '提前完成',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
