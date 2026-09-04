import 'package:flutter/material.dart';

class PlanPhase {
  const PlanPhase({
    required this.title,
    required this.duration,
    required this.icon,
    required this.items,
  });

  final String title;
  final String duration;
  final IconData icon;
  final List<String> items;
}

class DailyPlanDetail {
  const DailyPlanDetail({
    required this.courseId,
    required this.focus,
    required this.equipment,
    required this.tips,
    required this.phases,
    required this.afterWorkoutTip,
    required this.targetCalories,
    required this.targetMinutes,
    required this.intensity,
    required this.heartRateZone,
    required this.mealSuggestion,
  });

  final String courseId;
  final String focus;
  final List<String> equipment;
  final List<String> tips;
  final List<PlanPhase> phases;
  final String afterWorkoutTip;
  final int targetCalories;
  final int targetMinutes;
  final String intensity;
  final String heartRateZone;
  final String mealSuggestion;
}
