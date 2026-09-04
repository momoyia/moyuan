import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_assets.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/data/mock_data.dart';
import 'package:peiban_app/screens/profile/edit_profile_screen.dart';
import 'package:peiban_app/screens/profile/favorites_screen.dart';
import 'package:peiban_app/screens/profile/fitness_plan_screen.dart';
import 'package:peiban_app/screens/profile/progress_screen.dart';
import 'package:peiban_app/screens/profile/settings_screen.dart';
import 'package:peiban_app/services/app_state.dart';
import 'package:peiban_app/widgets/menu_tile.dart';
import 'package:peiban_app/widgets/stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

  final AppState appState;
  final VoidCallback onStateChanged;

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

  bool _isCheckedIn(DateTime day, List<String> checkInDates) {
    final key =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    return checkInDates.contains(key);
  }

  @override
  Widget build(BuildContext context) {
    final profile = appState.profile;
    final stats = appState.stats;
    final favoriteCount = stats.favoriteCourseIds.length;
    final planTitle = MockData.planTitle(stats.activePlanId);
    final planTotal = _planTotalDays(stats.activePlanId);
    final planProgress = (stats.planDay / planTotal).clamp(0.0, 1.0);
    final weekDays = _recentWeekDays();
    final weekChecked = weekDays.where((d) => _isCheckedIn(d, stats.checkInDates)).length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.brandPink, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 38,
                  backgroundImage: AssetImage(AppAssets.avatarAnimal),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.nickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile.bio,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.slate500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              appState: appState,
                              onStateChanged: onStateChanged,
                            ),
                          ),
                        );
                        onStateChanged();
                      },
                      child: const Text(
                        '编辑个人资料 →',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandPink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(
                            appState: appState,
                            onStateChanged: onStateChanged,
                          ),
                        ),
                      );
                      onStateChanged();
                    },
                    icon: const Icon(Icons.settings_outlined, size: 22, color: AppColors.slate600),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            '训练进度',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.slate100),
            ),
            child: Column(
              children: [
                _ProgressRow(
                  label: '今日',
                  value: '${(stats.todayProgress * 100).round()}%',
                  progress: stats.todayProgress,
                ),
                const SizedBox(height: 12),
                _ProgressRow(
                  label: '计划',
                  value: '${stats.planDay}/$planTotal',
                  progress: planProgress,
                ),
                const SizedBox(height: 12),
                Text(
                  '连续 ${stats.streakDays} 天 · 本周 $weekChecked/7',
                  style: const TextStyle(fontSize: 12, color: AppColors.slate500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const _SectionTitle(icon: Icons.bar_chart_rounded, title: '累计数据'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: '运动时长',
                  value: stats.totalHours.toStringAsFixed(1),
                  unit: '小时',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  label: '消耗热量',
                  value: _formatNumber(stats.totalCalories),
                  unit: 'kcal',
                  valueColor: AppColors.brandPink,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  label: '完成课程',
                  value: '${stats.completedLessons}',
                  unit: '节',
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const _SectionTitle(icon: Icons.apps_rounded, title: '更多功能'),
          const SizedBox(height: 12),
          MenuTile(
            icon: Icons.favorite_border,
            iconColor: AppColors.brandPink,
            iconBgColor: AppColors.softPinkBg,
            title: '收藏的健身教程',
            subtitle: '已收藏 $favoriteCount 个视频课程',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesScreen(
                    appState: appState,
                    onStateChanged: onStateChanged,
                  ),
                ),
              );
              onStateChanged();
            },
          ),
          const SizedBox(height: 10),
          MenuTile(
            icon: Icons.calendar_month_outlined,
            iconColor: const Color(0xFF6366F1),
            iconBgColor: const Color(0xFFEEF2FF),
            title: '制定个人健身计划',
            subtitle: '当前执行：$planTitle',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FitnessPlanScreen(
                    appState: appState,
                    onStateChanged: onStateChanged,
                  ),
                ),
              );
              onStateChanged();
            },
          ),
          const SizedBox(height: 10),
          MenuTile(
            icon: Icons.show_chart_outlined,
            iconColor: const Color(0xFF10B981),
            iconBgColor: const Color(0xFFECFDF5),
            title: '运动的进程与数据追踪',
            subtitle: '体重变化曲线、身体维度追踪',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProgressScreen(
                    appState: appState,
                    onStateChanged: onStateChanged,
                  ),
                ),
              );
              onStateChanged();
            },
          ),
        ],
      ),
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k'.replaceAll('.0k', 'k');
    }
    return value.toString();
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.softPinkBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: AppColors.brandPink),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.slate900,
          ),
        ),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.progress,
  });

  final String label;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.slate600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.slate900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: AppColors.slate100,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandPink),
          ),
        ),
      ],
    );
  }
}
