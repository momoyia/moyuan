import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/services/app_state.dart';

Future<void> showCheckInSheet({
  required BuildContext context,
  required AppState appState,
  required VoidCallback onStateChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _CheckInSheet(
      appState: appState,
      onStateChanged: onStateChanged,
    ),
  );
}

class _CheckInSheet extends StatefulWidget {
  const _CheckInSheet({
    required this.appState,
    required this.onStateChanged,
  });

  final AppState appState;
  final VoidCallback onStateChanged;

  @override
  State<_CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends State<_CheckInSheet> {
  bool _loading = false;

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  bool get _checkedToday => widget.appState.stats.checkInDates.contains(_todayKey());

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

  Future<void> _handleCheckIn() async {
    if (_checkedToday || _loading) return;
    setState(() => _loading = true);
    await widget.appState.checkInToday();
    widget.onStateChanged();
    setState(() => _loading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('打卡成功，继续保持！')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.appState.stats;
    final weekDays = _recentWeekDays();
    final weekChecked = weekDays.where(_isCheckedIn).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          24 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.slate100,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.softPinkBg,
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: AppColors.brandPink,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '连续打卡 ${stats.streakDays} 天',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.slate900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '坚持训练，遇见更好的自己',
              style: TextStyle(fontSize: 13, color: AppColors.slate500.withOpacity(0.9)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '本周记录',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),
                Text(
                  '$weekChecked / 7 天',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandPink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
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
                    const SizedBox(height: 8),
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: checked ? AppColors.softPinkBg : AppColors.slate50,
                        border: Border.all(
                          color: checked
                              ? AppColors.brandPink
                              : (isToday ? AppColors.brandPink : AppColors.slate100),
                          width: checked || isToday ? 1.5 : 1,
                        ),
                      ),
                      child: checked
                          ? const Icon(Icons.check, size: 18, color: AppColors.brandPink)
                          : Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                color: isToday ? AppColors.brandPink : AppColors.slate400,
                              ),
                            ),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkedToday ? null : _handleCheckIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPink,
                  disabledBackgroundColor: AppColors.slate100,
                  disabledForegroundColor: AppColors.slate400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _checkedToday ? '今日已打卡' : '立即打卡',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _checkedToday ? '明天继续加油 💪' : '完成今日训练后记得打卡',
              style: const TextStyle(fontSize: 12, color: AppColors.slate400),
            ),
          ],
        ),
      ),
    );
  }
}
