import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/data/mock_data.dart';
import 'package:peiban_app/models/course.dart';
import 'package:peiban_app/screens/home/check_in_sheet.dart';
import 'package:peiban_app/screens/home/daily_plan_screen.dart';
import 'package:peiban_app/screens/home/course_detail_screen.dart';
import 'package:peiban_app/screens/home/course_list_screen.dart';
import 'package:peiban_app/screens/home/workout_player_screen.dart';
import 'package:peiban_app/services/app_state.dart';
import 'package:peiban_app/widgets/category_chip.dart';
import 'package:peiban_app/widgets/course_card.dart';
import 'package:peiban_app/widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

  final AppState appState;
  final VoidCallback onStateChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = '全部推荐';

  List<Course> get _filteredCourses {
    if (_selectedCategory == '全部推荐') {
      return MockData.courses;
    }
    return MockData.courses
        .where((course) => course.category == _selectedCategory)
        .toList();
  }

  Course get _todayCourse {
    return MockData.courseById(widget.appState.stats.todayCourseId) ??
        MockData.courses.first;
  }

  Future<void> _refreshState() async {
    widget.onStateChanged();
    setState(() {});
  }

  Future<void> _openCheckInSheet() async {
    await showCheckInSheet(
      context: context,
      appState: widget.appState,
      onStateChanged: _refreshState,
    );
    await _refreshState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.appState.profile;
    final stats = widget.appState.stats;
    final todayCourse = _todayCourse;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${profile.nickname}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '今日燃脂计划 🔥',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.slate900,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _openCheckInSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.softPinkBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFCE7F3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '连续打卡',
                            style: TextStyle(fontSize: 10, color: AppColors.slate400),
                          ),
                          Text(
                            '${stats.streakDays} 天',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.brandPink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DailyPlanScreen(
                    course: todayCourse,
                    appState: widget.appState,
                    onStateChanged: _refreshState,
                  ),
                ),
              );
            },
            child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    todayCourse.imageAsset,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.65),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '今日计划',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    todayCourse.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WorkoutPlayerScreen(
                                      course: todayCourse,
                                      appState: widget.appState,
                                      onCompleted: _refreshState,
                                    ),
                                  ),
                                );
                                await _refreshState();
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.22),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            _InfoChip(
                              Icons.schedule,
                              '${todayCourse.durationMinutes}分钟',
                            ),
                            const SizedBox(width: 12),
                            _InfoChip(
                              Icons.bolt,
                              '${todayCourse.calories} 千卡',
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
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.homeCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = MockData.homeCategories[index];
                return CategoryChip(
                  label: category,
                  selected: _selectedCategory == category,
                  onTap: () => setState(() => _selectedCategory = category),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(
            title: '为你定制精选课程',
            action: '查看全部',
            onActionTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseListScreen(
                    appState: widget.appState,
                    onStateChanged: _refreshState,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          ..._filteredCourses.map(
            (course) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: CourseCard(
                course: course,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseDetailScreen(
                        course: course,
                        appState: widget.appState,
                        onStateChanged: _refreshState,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white.withOpacity(0.9)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)),
        ),
      ],
    );
  }
}
