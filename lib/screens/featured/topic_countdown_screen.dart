import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/models/featured_topic.dart';
import 'package:peiban_app/services/featured_interaction_service.dart';

class TopicCountdownScreen extends StatefulWidget {
  const TopicCountdownScreen({
    super.key,
    required this.topic,
    required this.initialPhaseIndex,
    required this.phaseDone,
    required this.onComplete,
  });

  final FeaturedTopic topic;
  final int initialPhaseIndex;
  final List<bool> phaseDone;
  final void Function(List<bool> phases, bool joined) onComplete;

  @override
  State<TopicCountdownScreen> createState() => _TopicCountdownScreenState();
}

class _TopicCountdownScreenState extends State<TopicCountdownScreen> {
  Timer? _timer;
  late int _remainingSeconds;
  late int _currentPhaseIndex;
  bool _isRunning = false;
  bool _isFinished = false;

  FeaturedTopic get topic => widget.topic;

  int get _phaseCount => topic.phases.length;

  int get _totalSeconds => _phaseCount == 0 ? 20 * 60 : _phaseCount * 5 * 60;

  int get _completedPhases => widget.phaseDone.where((done) => done).length;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _totalSeconds;
    _currentPhaseIndex = widget.initialPhaseIndex.clamp(0, _phaseCount > 0 ? _phaseCount - 1 : 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatPart(int seconds, {required bool minutes}) {
    final value = minutes ? seconds ~/ 60 : seconds % 60;
    return value.toString().padLeft(2, '0');
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
    final phases = List<bool>.from(widget.phaseDone);
    if (_phaseCount > 0 && _currentPhaseIndex < phases.length) {
      phases[_currentPhaseIndex] = true;
    }
    await FeaturedInteractionService.setTopicJoined(topic.id, true);
    await FeaturedInteractionService.saveTopicPhases(topic.id, phases);
    widget.onComplete(phases, true);
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isFinished = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('特训阶段完成，进度已更新！')),
    );
  }

  void _nextPhase() {
    if (_currentPhaseIndex < _phaseCount - 1) {
      setState(() => _currentPhaseIndex++);
    }
  }

  void _prevPhase() {
    if (_currentPhaseIndex > 0) {
      setState(() => _currentPhaseIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remainingSeconds / _totalSeconds);
    final phase = _phaseCount > 0 ? topic.phases[_currentPhaseIndex] : null;
    final dayIndex = (_completedPhases + 1).clamp(1, topic.days);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.slate900),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '特训挑战',
                          style: TextStyle(fontSize: 11, color: AppColors.slate400),
                        ),
                        Text(
                          topic.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.slate900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.brandPink,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      topic.badge,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.softPinkBg,
                    AppColors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFCE7F3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '第 $dayIndex / ${topic.days} 天',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brandPink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '已完成 $_completedPhases / $_phaseCount 个阶段',
                          style: const TextStyle(fontSize: 12, color: AppColors.slate500),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _TimeBox(
                        value: _isFinished ? '00' : _formatPart(_remainingSeconds, minutes: true),
                        unit: '分',
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.slate400)),
                      ),
                      _TimeBox(
                        value: _isFinished ? '00' : _formatPart(_remainingSeconds, minutes: false),
                        unit: '秒',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_phaseCount > 0)
              SizedBox(
                height: 36,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _phaseCount,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final done = widget.phaseDone[index];
                    final active = index == _currentPhaseIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _currentPhaseIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.brandPink
                              : (done ? AppColors.softPinkBg : AppColors.slate50),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: active || done ? AppColors.brandPink : AppColors.slate100,
                          ),
                        ),
                        child: Text(
                          '阶段${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: active
                                ? Colors.white
                                : (done ? AppColors.brandPink : AppColors.slate500),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (phase != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.slate100),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: List.generate(_phaseCount, (index) {
                                final done = widget.phaseDone[index] || index == _currentPhaseIndex;
                                final isLast = index == _phaseCount - 1;
                                return Column(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: done ? AppColors.brandPink : AppColors.slate100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        done ? Icons.check : Icons.circle,
                                        size: 12,
                                        color: done ? Colors.white : AppColors.slate400,
                                      ),
                                    ),
                                    if (!isLast)
                                      Container(
                                        width: 2,
                                        height: 40,
                                        color: done ? AppColors.brandPink.withOpacity(0.3) : AppColors.slate100,
                                      ),
                                  ],
                                );
                              }),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    phase.duration,
                                    style: const TextStyle(fontSize: 11, color: AppColors.brandPink, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    phase.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.slate900,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.slate50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '重点：${phase.focus}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.slate600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    phase.explanation,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.slate600,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _isFinished ? 1.0 : progress.clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: AppColors.slate100,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandPink),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isFinished ? '本阶段训练已完成' : (_isRunning ? '特训进行中...' : '点击开始本阶段训练'),
                      style: const TextStyle(fontSize: 12, color: AppColors.slate400),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (_phaseCount > 1)
                        IconButton(
                          onPressed: _prevPhase,
                          icon: const Icon(Icons.chevron_left, color: AppColors.slate600),
                        ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _isFinished ? null : _toggleTimer,
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: _isFinished ? AppColors.slate100 : AppColors.slate900,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _isFinished
                                  ? '阶段完成 ✓'
                                  : (_isRunning ? '暂停特训' : '开始本阶段'),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _isFinished ? AppColors.slate500 : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_phaseCount > 1)
                        IconButton(
                          onPressed: _nextPhase,
                          icon: const Icon(Icons.chevron_right, color: AppColors.slate600),
                        ),
                    ],
                  ),
                  if (!_isFinished)
                    TextButton(
                      onPressed: _finishWorkout,
                      child: const Text('提前完成本阶段', style: TextStyle(color: AppColors.slate400)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({required this.value, required this.unit});

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate100),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(unit, style: const TextStyle(fontSize: 10, color: AppColors.slate400)),
      ],
    );
  }
}
