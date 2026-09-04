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
}
