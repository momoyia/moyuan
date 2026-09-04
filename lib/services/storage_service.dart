import 'dart:convert';

import 'package:peiban_app/data/mock_data.dart';
import 'package:peiban_app/models/social_user_entry.dart';
import 'package:peiban_app/models/user_profile.dart';
import 'package:peiban_app/models/workout_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();

  static const String _profileKey = 'user_profile';
  static const String _statsKey = 'workout_stats';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _reminderKey = 'daily_reminder';
  static const String _teenModeKey = 'teen_mode_enabled';
  static const String _blockedUsersKey = 'blocked_users';
  static const String _mutedUsersKey = 'muted_users';
  static const String _loggedInKey = 'is_logged_in';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  static Future<UserProfile> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null) {
      return const UserProfile(
        nickname: '鸡蛋炒饭',
        bio: '自律给我自由，坚持遇见更好的自己 ✨',
        avatarIndex: 1,
        level: 4,
        heightCm: 165,
        weightKg: 60,
        targetWeightKg: 55,
        interestedCategories: [],
      );
    }
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  static Future<WorkoutStats> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_statsKey);
    if (raw == null) {
      return WorkoutStats.fromJson({});
    }
    return WorkoutStats.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static Future<void> saveStats(WorkoutStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(stats.toJson()));
  }

  static Future<bool> loadNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  static Future<void> saveNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
  }

  static Future<String> loadDailyReminder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_reminderKey) ?? '07:30';
  }

  static Future<void> saveDailyReminder(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reminderKey, value);
  }

  static Future<bool> loadTeenModeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_teenModeKey) ?? false;
  }

  static Future<void> saveTeenModeEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_teenModeKey, value);
  }

  static Future<List<SocialUserEntry>> loadBlockedUsers({required bool seedIfMissing}) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_blockedUsersKey)) {
      if (seedIfMissing) {
        final users = List<SocialUserEntry>.from(MockData.defaultBlockedUsers);
        await saveBlockedUsers(users);
        return users;
      }
      return [];
    }
    final raw = prefs.getString(_blockedUsersKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => SocialUserEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveBlockedUsers(List<SocialUserEntry> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _blockedUsersKey,
      jsonEncode(users.map((user) => user.toJson()).toList()),
    );
  }

  static Future<List<SocialUserEntry>> loadMutedUsers({required bool seedIfMissing}) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_mutedUsersKey)) {
      if (seedIfMissing) {
        final users = List<SocialUserEntry>.from(MockData.defaultMutedUsers);
        await saveMutedUsers(users);
        return users;
      }
      return [];
    }
    final raw = prefs.getString(_mutedUsersKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => SocialUserEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveMutedUsers(List<SocialUserEntry> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _mutedUsersKey,
      jsonEncode(users.map((user) => user.toJson()).toList()),
    );
  }

  static Future<bool> loadLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> saveLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }

  static Future<bool> loadOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  static Future<void> saveOnboardingCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, value);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.remove(_statsKey);
    await prefs.remove(_notificationsKey);
    await prefs.remove(_reminderKey);
    await prefs.remove(_teenModeKey);
    await prefs.remove(_blockedUsersKey);
    await prefs.remove(_mutedUsersKey);
    await prefs.remove(_loggedInKey);
    await prefs.remove(_onboardingCompletedKey);
  }
}
