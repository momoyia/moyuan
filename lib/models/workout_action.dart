class WorkoutAction {
  const WorkoutAction({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.sets,
    required this.imageAsset,
    required this.tips,
    required this.targetMuscles,
    required this.biomechanics,
    required this.commonMistakes,
    required this.breathingGuide,
    required this.intensityGuide,
    required this.scienceBenefits,
    required this.rating,
    required this.difficultyLabel,
    required this.durationMinutes,
    required this.caloriesMin,
    required this.caloriesMax,
    required this.authorName,
    required this.authorAvatar,
    required this.description,
    required this.commentCount,
    required this.practicedLabel,
    required this.equipment,
  });

  final String id;
  final String name;
  final String subtitle;
  final String sets;
  final String imageAsset;
  final List<String> tips;
  final List<String> targetMuscles;
  final String biomechanics;
  final List<String> commonMistakes;
  final List<String> breathingGuide;
  final String intensityGuide;
  final List<String> scienceBenefits;
  final double rating;
  final String difficultyLabel;
  final int durationMinutes;
  final int caloriesMin;
  final int caloriesMax;
  final String authorName;
  final String authorAvatar;
  final String description;
  final int commentCount;
  final String practicedLabel;
  final List<String> equipment;
}
