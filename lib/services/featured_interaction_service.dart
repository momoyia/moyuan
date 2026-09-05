import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FeaturedInteractionService {
  FeaturedInteractionService._();

  static const String _joinedTopicsKey = 'featured_joined_topics';
  static const String _topicPhasesKey = 'featured_topic_phases';
  static const String _likedArticlesKey = 'featured_liked_articles';
  static const String _bookmarkedArticlesKey = 'featured_bookmarked_articles';
  static const String _actionPracticeKey = 'featured_action_practice';
  static const String _articleTakeawaysKey = 'featured_article_takeaways';
  static const String _actionWantTrainKey = 'featured_action_want_train';
  static const String _actionCalendarKey = 'featured_action_calendar';

  static Future<List<String>> loadJoinedTopics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_joinedTopicsKey) ?? [];
  }

  static Future<void> setTopicJoined(String topicId, bool joined) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(prefs.getStringList(_joinedTopicsKey) ?? []);
    if (joined) {
      if (!list.contains(topicId)) list.add(topicId);
    } else {
      list.remove(topicId);
    }
    await prefs.setStringList(_joinedTopicsKey, list);
  }

  static Future<bool> isTopicJoined(String topicId) async {
    final list = await loadJoinedTopics();
    return list.contains(topicId);
  }

  static Future<List<bool>> loadTopicPhases(String topicId, int phaseCount) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_topicPhasesKey);
    if (raw == null) return List.filled(phaseCount, false);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final saved = (map[topicId] as List<dynamic>?)?.map((e) => e as bool).toList();
    if (saved == null || saved.length != phaseCount) {
      return List.filled(phaseCount, false);
    }
    return saved;
  }

  static Future<void> saveTopicPhases(String topicId, List<bool> phases) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_topicPhasesKey);
    final map = raw == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(raw) as Map<String, dynamic>);
    map[topicId] = phases;
    await prefs.setString(_topicPhasesKey, jsonEncode(map));
  }

  static Future<bool> isArticleLiked(String articleId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_likedArticlesKey) ?? []).contains(articleId);
  }

  static Future<void> setArticleLiked(String articleId, bool liked) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(prefs.getStringList(_likedArticlesKey) ?? []);
    if (liked) {
      if (!list.contains(articleId)) list.add(articleId);
    } else {
      list.remove(articleId);
    }
    await prefs.setStringList(_likedArticlesKey, list);
  }

  static Future<bool> isArticleBookmarked(String articleId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_bookmarkedArticlesKey) ?? []).contains(articleId);
  }

  static Future<void> setArticleBookmarked(String articleId, bool bookmarked) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(prefs.getStringList(_bookmarkedArticlesKey) ?? []);
    if (bookmarked) {
      if (!list.contains(articleId)) list.add(articleId);
    } else {
      list.remove(articleId);
    }
    await prefs.setStringList(_bookmarkedArticlesKey, list);
  }

  static Future<List<bool>> loadArticleTakeaways(String articleId, int count) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_articleTakeawaysKey);
    if (raw == null) return List.filled(count, false);
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final saved = (map[articleId] as List<dynamic>?)?.map((e) => e as bool).toList();
    if (saved == null || saved.length != count) {
      return List.filled(count, false);
    }
    return saved;
  }

  static Future<void> saveArticleTakeaways(String articleId, List<bool> checked) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_articleTakeawaysKey);
    final map = raw == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(raw) as Map<String, dynamic>);
    map[articleId] = checked;
    await prefs.setString(_articleTakeawaysKey, jsonEncode(map));
  }

  static Future<int> loadActionPracticeCount(String actionId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_actionPracticeKey);
    if (raw == null) return 0;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return (map[actionId] as num?)?.toInt() ?? 0;
  }

  static Future<void> saveActionPracticeCount(String actionId, int count) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_actionPracticeKey);
    final map = raw == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(raw) as Map<String, dynamic>);
    map[actionId] = count;
    await prefs.setString(_actionPracticeKey, jsonEncode(map));
  }

  static Future<bool> isActionWantTrain(String actionId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_actionWantTrainKey) ?? []).contains(actionId);
  }

  static Future<void> setActionWantTrain(String actionId, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(prefs.getStringList(_actionWantTrainKey) ?? []);
    if (value) {
      if (!list.contains(actionId)) list.add(actionId);
    } else {
      list.remove(actionId);
    }
    await prefs.setStringList(_actionWantTrainKey, list);
  }

  static Future<bool> isActionInCalendar(String actionId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_actionCalendarKey) ?? []).contains(actionId);
  }

  static Future<void> setActionInCalendar(String actionId, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final list = List<String>.from(prefs.getStringList(_actionCalendarKey) ?? []);
    if (value) {
      if (!list.contains(actionId)) list.add(actionId);
    } else {
      list.remove(actionId);
    }
    await prefs.setStringList(_actionCalendarKey, list);
  }
}
