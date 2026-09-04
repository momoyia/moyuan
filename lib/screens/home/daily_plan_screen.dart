import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/data/mock_data.dart';
import 'package:peiban_app/models/course.dart';
import 'package:peiban_app/models/daily_plan.dart';
import 'package:peiban_app/screens/home/course_detail_screen.dart';
import 'package:peiban_app/screens/home/workout_player_screen.dart';
import 'package:peiban_app/services/app_state.dart';
import 'package:peiban_app/widgets/course_favorite_button.dart';

class DailyPlanScreen extends StatefulWidget {
  const DailyPlanScreen({
    super.key,
    required this.course,
    required this.appState,
    required this.onStateChanged,
  });

  final Course course;
  final AppState appState;
  final VoidCallback onStateChanged;

  @override
  State<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends State<DailyPlanScreen> {
  late List<bool> _phaseDone;

  @override
  void initState() {
    super.initState();
    final plan = MockData.dailyPlanForCourse(widget.course);
    _phaseDone = List.filled(plan.phases.length, false);
  }

  int _planTotalDays(String planId) {
    switch (planId) {
      case 'plan_14':
        return 14;
      case 'plan_7':
        return 7;
      default:
        return 21;
    }
  }

  List<DateTime> _recentWeekDays() {
    final today = DateTime.now();
    final weekday = today.weekday;
    return List.generate(7, (index) {
      return today.subtract(Duration(days: weekday - 1 - index));
    });
  }

  bool _isCheckedIn(DateTime day) {
    final key =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    return widget.appState.stats.checkInDates.contains(key);
  }

  String _weekdayLabel(int weekday) {
    const labels = ['一', '二', '三', '四', '五', '六', '日'];
    return labels[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.appState.stats;
    final course = widget.course;
    final plan = MockData.dailyPlanForCourse(course);
    final planTitle = MockData.planTitle(stats.activePlanId);
    final planTotal = _planTotalDays(stats.activePlanId);
    final planProgress = stats.planDay / planTotal;
    final weekDays = _recentWeekDays();
    final completedPhases = _phaseDone.where((done) => done).length;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            actions: [
              CourseFavoriteButton(
                courseId: course.id,
                appState: widget.appState,
                onStateChanged: widget.onStateChanged,
                iconColor: Colors.white,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(course.imageAsset, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.75),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '今日燃脂计划',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('本周训练'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weekDays.map((day) {
                      final checked = _isCheckedIn(day);
                      final isToday = day.day == DateTime.now().day &&
                          day.month == DateTime.now().month &&
                          day.year == DateTime.now().year;
                      return Column(
                        children: [
                          Text(
                            _weekdayLabel(day.weekday),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                              color: isToday ? AppColors.brandPink : AppColors.slate400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: checked ? AppColors.softPinkBg : AppColors.slate50,
                              border: Border.all(
                                color: checked || isToday
                                    ? AppColors.brandPink
                                    : AppColors.slate100,
                              ),
                            ),
                            child: checked
                                ? const Icon(Icons.check, size: 16, color: AppColors.brandPink)
                                : Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                      color: isToday ? AppColors.brandPink : AppColors.slate400,
                                    ),
                                  ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  _PlanCard(
                    planTitle: planTitle,
                    planDay: stats.planDay,
                    planTotal: planTotal,
                    planProgress: planProgress.clamp(0.0, 1.0),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.speed_outlined,
                          label: '训练强度',
                          value: plan.intensity,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _InfoTile(
                          icon: Icons.favorite_outline,
                          label: '心率目标',
                          value: plan.heartRateZone,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle('今日训练重点'),
                  const SizedBox(height: 8),
                  Text(
                    plan.focus,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.slate600,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _SectionTitle('训练阶段'),
                      Text(
                        '$completedPhases/${plan.phases.length} 已完成',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandPink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(plan.phases.length, (index) {
                    return _PhaseTimelineItem(
                      phase: plan.phases[index],
                      isLast: index == plan.phases.length - 1,
                      done: _phaseDone[index],
                      onToggle: () {
                        setState(() => _phaseDone[index] = !_phaseDone[index]);
                      },
                    );
                  }),
                  const SizedBox(height: 24),
                  const _SectionTitle('所需器械'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: plan.equipment.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.slate100),
                        ),
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 12, color: AppColors.slate600),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle('训练贴士'),
                  const SizedBox(height: 10),
                  ...plan.tips.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.tips_and_updates_outlined,
                            size: 18,
                            color: AppColors.brandPink,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              tip,
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
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.softPinkBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.restaurant_outlined,
                                size: 18, color: AppColors.brandPink),
                            SizedBox(width: 8),
                            Text(
                              '饮食搭配',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          plan.mealSuggestion,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.slate600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          plan.afterWorkoutTip,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.slate500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseDetailScreen(
                              course: course,
                              appState: widget.appState,
                              onStateChanged: widget.onStateChanged,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.menu_book_outlined, size: 18),
                      label: const Text('查看课程详细介绍'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.slate500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutPlayerScreen(
                          course: course,
                          appState: widget.appState,
                          onCompleted: widget.onStateChanged,
                        ),
                      ),
                    );
                    widget.onStateChanged();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    stats.todayProgress >= 1 ? '再次训练' : '开始今日训练',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '约 ${plan.targetCalories} 千卡',
                style: const TextStyle(fontSize: 12, color: AppColors.slate400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.slate900,
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.brandPink),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.slate400)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.slate600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.planTitle,
    required this.planDay,
    required this.planTotal,
    required this.planProgress,
  });

  final String planTitle;
  final int planDay;
  final int planTotal;
  final double planProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_outlined, size: 18, color: AppColors.brandPink),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  planTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),
              ),
              Text(
                '第 $planDay / $planTotal 天',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandPink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: planProgress,
              minHeight: 4,
              backgroundColor: AppColors.slate100,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandPink),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseTimelineItem extends StatelessWidget {
  const _PhaseTimelineItem({
    required this.phase,
    required this.isLast,
    required this.done,
    required this.onToggle,
  });

  final PlanPhase phase;
  final bool isLast;
  final bool done;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: done ? AppColors.brandPink : AppColors.softPinkBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    done ? Icons.check : phase.icon,
                    size: 18,
                    color: done ? Colors.white : AppColors.brandPink,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.slate100,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          phase.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: done ? AppColors.slate400 : AppColors.slate900,
                            decoration: done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...phase.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('· ', style: TextStyle(color: AppColors.slate400)),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 13,
                                color: done ? AppColors.slate400 : AppColors.slate600,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
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
