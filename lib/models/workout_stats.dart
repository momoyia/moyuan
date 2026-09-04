class WorkoutStats {
  const WorkoutStats({
    required this.totalHours,
    required this.totalCalories,
    required this.completedLessons,
    required this.streakDays,
    required this.todayProgress,
    required this.todayCourseId,
    required this.activePlanId,
    required this.planDay,
    required this.weightRecords,
    required this.favoriteCourseIds,
    required this.checkInDates,
  });

  final double totalHours;
  final int totalCalories;
  final int completedLessons;
  final int streakDays;
  final double todayProgress;
  final String todayCourseId;
  final String activePlanId;
  final int planDay;
  final Map<String, double> weightRecords;
  final List<String> favoriteCourseIds;
  final List<String> checkInDates;

  WorkoutStats copyWith({
    double? totalHours,
    int? totalCalories,
    int? completedLessons,
    int? streakDays,
    double? todayProgress,
    String? todayCourseId,
    String? activePlanId,
    int? planDay,
    Map<String, double>? weightRecords,
    List<String>? favoriteCourseIds,
    List<String>? checkInDates,
  }) {
    return WorkoutStats(
      totalHours: totalHours ?? this.totalHours,
      totalCalories: totalCalories ?? this.totalCalories,
      completedLessons: completedLessons ?? this.completedLessons,
      streakDays: streakDays ?? this.streakDays,
      todayProgress: todayProgress ?? this.todayProgress,
      todayCourseId: todayCourseId ?? this.todayCourseId,
      activePlanId: activePlanId ?? this.activePlanId,
      planDay: planDay ?? this.planDay,
      weightRecords: weightRecords ?? this.weightRecords,
      favoriteCourseIds: favoriteCourseIds ?? this.favoriteCourseIds,
      checkInDates: checkInDates ?? this.checkInDates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalHours': totalHours,
      'totalCalories': totalCalories,
      'completedLessons': completedLessons,
      'streakDays': streakDays,
      'todayProgress': todayProgress,
      'todayCourseId': todayCourseId,
      'activePlanId': activePlanId,
      'planDay': planDay,
      'weightRecords': weightRecords.map((k, v) => MapEntry(k, v)),
      'favoriteCourseIds': favoriteCourseIds,
      'checkInDates': checkInDates,
    };
  }

  factory WorkoutStats.fromJson(Map<String, dynamic> json) {
    final weightRaw = json['weightRecords'];
    final Map<String, double> weights = {};
    if (weightRaw is Map) {
      weightRaw.forEach((key, value) {
        weights[key.toString()] = (value as num).toDouble();
      });
    }

    return WorkoutStats(
      totalHours: (json['totalHours'] as num?)?.toDouble() ?? 32.5,
      totalCalories: json['totalCalories'] as int? ?? 12480,
      completedLessons: json['completedLessons'] as int? ?? 48,
      streakDays: json['streakDays'] as int? ?? 12,
      todayProgress: (json['todayProgress'] as num?)?.toDouble() ?? 0.75,
      todayCourseId: json['todayCourseId'] as String? ?? 'course_hiit',
      activePlanId: json['activePlanId'] as String? ?? 'plan_21',
      planDay: json['planDay'] as int? ?? 8,
      weightRecords: weights.isEmpty
          ? {
              '2026-08-25': 62.5,
              '2026-08-28': 62.1,
              '2026-09-01': 61.8,
            }
          : weights,
      favoriteCourseIds: (json['favoriteCourseIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['course_hiit', 'course_abs'],
      checkInDates: (json['checkInDates'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
