import 'package:peiban_app/data/mock_data.dart';
import 'package:peiban_app/models/social_user_entry.dart';
import 'package:peiban_app/models/user_profile.dart';
import 'package:peiban_app/models/workout_stats.dart';
import 'package:peiban_app/services/storage_service.dart';

class AppState {
  AppState({
    required this.profile,
    required this.stats,
    required this.notificationsEnabled,
    required this.dailyReminder,
    required this.teenModeEnabled,
    required this.blockedUsers,
    required this.mutedUsers,
  });

  UserProfile profile;
  WorkoutStats stats;
  bool notificationsEnabled;
  String dailyReminder;
  bool teenModeEnabled;
  List<SocialUserEntry> blockedUsers;
  List<SocialUserEntry> mutedUsers;

  static Future<AppState> load() async {
    final profile = await StorageService.loadProfile();
    final stats = await StorageService.loadStats();
    final notifications = await StorageService.loadNotificationsEnabled();
    final reminder = await StorageService.loadDailyReminder();
    var blockedUsers = await StorageService.loadBlockedUsers(seedIfMissing: true);
    var mutedUsers = await StorageService.loadMutedUsers(seedIfMissing: true);
    final teenMode = await StorageService.loadTeenModeEnabled();
    return AppState(
      profile: profile,
      stats: stats,
      notificationsEnabled: notifications,
      dailyReminder: reminder,
      teenModeEnabled: teenMode,
      blockedUsers: blockedUsers,
      mutedUsers: mutedUsers,
    );
  }

  Future<void> updateProfile(UserProfile value) async {
    profile = value;
    await StorageService.saveProfile(profile);
  }

  Future<void> updateStats(WorkoutStats value) async {
    stats = value;
    await StorageService.saveStats(stats);
  }

  Future<void> setNotifications(bool value) async {
    notificationsEnabled = value;
    await StorageService.saveNotificationsEnabled(value);
  }

  Future<void> setDailyReminder(String value) async {
    dailyReminder = value;
    await StorageService.saveDailyReminder(value);
  }

  Future<void> setTeenMode(bool value) async {
    teenModeEnabled = value;
    await StorageService.saveTeenModeEnabled(value);
  }

  Future<void> unblockUser(String userId) async {
    blockedUsers = blockedUsers.where((user) => user.id != userId).toList();
    await StorageService.saveBlockedUsers(blockedUsers);
  }

  Future<void> unmuteUser(String userId) async {
    mutedUsers = mutedUsers.where((user) => user.id != userId).toList();
    await StorageService.saveMutedUsers(mutedUsers);
  }

  bool isFavorite(String courseId) {
    return stats.favoriteCourseIds.contains(courseId);
  }

  Future<void> toggleFavorite(String courseId) async {
    final favorites = List<String>.from(stats.favoriteCourseIds);
    if (favorites.contains(courseId)) {
      favorites.remove(courseId);
    } else {
      favorites.add(courseId);
    }
    await updateStats(stats.copyWith(favoriteCourseIds: favorites));
  }

  Future<void> completeCourse({
    required String courseId,
    required int durationMinutes,
    required int calories,
  }) async {
    final today = _todayString();
    final checkIns = List<String>.from(stats.checkInDates);
    if (!checkIns.contains(today)) {
      checkIns.add(today);
    }

    final newProgress = (stats.todayProgress + 0.25).clamp(0.0, 1.0);
    final newStreak = _calculateStreak(checkIns);

    await updateStats(
      stats.copyWith(
        totalHours: stats.totalHours + durationMinutes / 60.0,
        totalCalories: stats.totalCalories + calories,
        completedLessons: stats.completedLessons + 1,
        todayProgress: newProgress,
        todayCourseId: courseId,
        streakDays: newStreak,
        checkInDates: checkIns,
        planDay: stats.planDay + 1,
      ),
    );
  }

  Future<void> checkInToday() async {
    final today = _todayString();
    final checkIns = List<String>.from(stats.checkInDates);
    if (!checkIns.contains(today)) {
      checkIns.add(today);
      await updateStats(
        stats.copyWith(
          streakDays: _calculateStreak(checkIns),
          checkInDates: checkIns,
        ),
      );
    }
  }

  Future<void> setActivePlan(String planId) async {
    await updateStats(
      stats.copyWith(activePlanId: planId, planDay: 1),
    );
  }

  Future<void> completeOnboarding({
    required double heightCm,
    required double weightKg,
    required double targetWeightKg,
    required List<String> interests,
    required String planId,
  }) async {
    await updateProfile(
      profile.copyWith(
        heightCm: heightCm,
        weightKg: weightKg,
        targetWeightKg: targetWeightKg,
        interestedCategories: interests,
      ),
    );
    await setActivePlan(planId);
    await addWeightRecord(weightKg);
    await StorageService.saveOnboardingCompleted(true);
  }

  Future<void> addWeightRecord(double weight) async {
    final records = Map<String, double>.from(stats.weightRecords);
    records[_todayString()] = weight;
    await updateStats(stats.copyWith(weightRecords: records));
  }

  Future<void> resetAllData() async {
    await StorageService.clearAll();
    profile = const UserProfile(
      nickname: '鸡蛋炒饭',
      bio: '自律给我自由，坚持遇见更好的自己 ✨',
      avatarIndex: 1,
      level: 4,
      heightCm: 165,
      weightKg: 60,
      targetWeightKg: 55,
      interestedCategories: [],
    );
    stats = WorkoutStats.fromJson({});
    notificationsEnabled = true;
    dailyReminder = '07:30';
    teenModeEnabled = false;
    blockedUsers = List<SocialUserEntry>.from(MockData.defaultBlockedUsers);
    mutedUsers = List<SocialUserEntry>.from(MockData.defaultMutedUsers);
    await StorageService.saveTeenModeEnabled(false);
    await StorageService.saveBlockedUsers(blockedUsers);
    await StorageService.saveMutedUsers(mutedUsers);
    await StorageService.saveOnboardingCompleted(false);
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  int _calculateStreak(List<String> dates) {
    if (dates.isEmpty) return 0;
    final sorted = dates.map(DateTime.parse).toList()
      ..sort((a, b) => b.compareTo(a));
    var streak = 0;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    for (final date in sorted) {
      final day = DateTime(date.year, date.month, date.day);
      final diff = todayDate.difference(day).inDays;
      if (streak == 0 && diff > 1) break;
      if (diff == streak || (streak == 0 && diff <= 1)) {
        streak++;
      } else {
        break;
      }
    }
    return streak > 0 ? streak : 1;
  }
}
