import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/models/workout_action.dart';
import 'package:peiban_app/services/featured_interaction_service.dart';

class ActionCountdownScreen extends StatefulWidget {
  const ActionCountdownScreen({
    super.key,
    required this.action,
    required this.initialPractice,
    required this.onPracticeUpdated,
  });

  final WorkoutAction action;
  final int initialPractice;
  final ValueChanged<int> onPracticeUpdated;

  @override
  State<ActionCountdownScreen> createState() => _ActionCountdownScreenState();
}

class _ActionCountdownScreenState extends State<ActionCountdownScreen> {
  Timer? _timer;
  late int _remainingSeconds;
  int _currentSet = 1;
  int _currentTipIndex = 0;
  bool _isRunning = false;
  bool _isFinished = false;

  static const int _targetSets = 4;

  WorkoutAction get action => widget.action;

  int get _totalSeconds => action.durationMinutes * 60;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _totalSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _toggleTimer() {
    if (_isFinished) return;
    setState(() => _isRunning = !_isRunning);
    if (_isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_remainingSeconds <= 0) {
          _finishWorkout();
          return;
        }
        setState(() => _remainingSeconds--);
      });
    } else {
      _timer?.cancel();
    }
  }

  Future<void> _finishWorkout() async {
    _timer?.cancel();
    final nextTotal = widget.initialPractice + 1;
    await FeaturedInteractionService.saveActionPracticeCount(action.id, nextTotal);
    widget.onPracticeUpdated(nextTotal);
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isFinished = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('动作训练完成，已记录练习数据！')),
    );
  }

  void _nextSegment() {
    if (_currentTipIndex < action.tips.length - 1) {
      setState(() => _currentTipIndex++);
      return;
    }
    if (_currentSet < _targetSets) {
      setState(() {
        _currentSet++;
        _currentTipIndex = 0;
      });
    }
  }

  void _prevSegment() {
    if (_currentTipIndex > 0) {
      setState(() => _currentTipIndex--);
      return;
    }
    if (_currentSet > 1) {
      setState(() {
        _currentSet--;
        _currentTipIndex = action.tips.length - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remainingSeconds / _totalSeconds);
    final currentTip = action.tips[_currentTipIndex];
    final breathing = _currentTipIndex < action.breathingGuide.length
        ? action.breathingGuide[_currentTipIndex]
        : null;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.slate900,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '动作精讲',
              style: TextStyle(fontSize: 11, color: AppColors.slate400, fontWeight: FontWeight.w500),
            ),
            Text(
              action.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.slate900),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.asset(action.imageAsset, height: 160, width: double.infinity, fit: BoxFit.cover),
                        Positioned(
                          left: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              action.sets,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _InfoChip(label: action.difficultyLabel),
                      const SizedBox(width: 8),
                      _InfoChip(label: '${action.caloriesMin}-${action.caloriesMax} 千卡'),
                      const SizedBox(width: 8),
                      _InfoChip(label: '评分 ${action.rating}'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: CircularProgressIndicator(
                              value: _isFinished ? 1.0 : progress.clamp(0.0, 1.0),
                              strokeWidth: 10,
                              backgroundColor: AppColors.slate100,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandPink),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isFinished ? '00:00' : _formatTime(_remainingSeconds),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.slate900,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isFinished ? '已完成' : '剩余时间',
                                style: const TextStyle(fontSize: 12, color: AppColors.slate400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_targetSets, (index) {
                      final done = index < _currentSet - 1;
                      final active = index == _currentSet - 1;
                      return Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: done
                              ? AppColors.brandPink
                              : (active ? AppColors.brandMagenta : AppColors.slate100),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      '第 $_currentSet / $_targetSets 组 · 要领 ${_currentTipIndex + 1}/${action.tips.length}',
                      style: const TextStyle(fontSize: 12, color: AppColors.slate500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.slate50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.slate100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.fitness_center, size: 16, color: AppColors.brandPink),
                            SizedBox(width: 6),
                            Text(
                              '标准要领',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentTip,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate900,
                            height: 1.5,
                          ),
                        ),
                        if (breathing != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.softPinkBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.air, size: 16, color: AppColors.brandPink),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    breathing,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.slate600,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: action.targetMuscles.take(4).map((muscle) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.slate100),
                        ),
                        child: Text(
                          muscle,
                          style: const TextStyle(fontSize: 11, color: AppColors.slate500),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.slate100)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _prevSegment,
                  icon: const Icon(Icons.chevron_left, color: AppColors.slate600),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _isFinished ? null : _toggleTimer,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: _isFinished ? null : AppColors.brandGradient,
                        color: _isFinished ? AppColors.slate100 : null,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isFinished
                                ? Icons.check_circle
                                : (_isRunning ? Icons.pause : Icons.play_arrow),
                            color: _isFinished ? AppColors.slate500 : Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isFinished ? '训练完成' : (_isRunning ? '暂停' : '开始跟练'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _isFinished ? AppColors.slate500 : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _nextSegment,
                  icon: const Icon(Icons.chevron_right, color: AppColors.slate600),
                ),
              ],
            ),
          ),
          if (!_isFinished)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton(
                onPressed: _finishWorkout,
                child: const Text('提前完成', style: TextStyle(color: AppColors.slate400)),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.softPinkBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.brandPink),
      ),
    );
  }
}
