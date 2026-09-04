class Course {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tag,
    required this.tagColor,
    required this.durationMinutes,
    required this.calories,
    required this.imageAsset,
    required this.difficulty,
    required this.steps,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String tag;
  final int tagColor;
  final int durationMinutes;
  final int calories;
  final String imageAsset;
  final String difficulty;
  final List<String> steps;

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? tag,
    int? tagColor,
    int? durationMinutes,
    int? calories,
    String? imageAsset,
    String? difficulty,
    List<String>? steps,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      tag: tag ?? this.tag,
      tagColor: tagColor ?? this.tagColor,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      calories: calories ?? this.calories,
      imageAsset: imageAsset ?? this.imageAsset,
      difficulty: difficulty ?? this.difficulty,
      steps: steps ?? this.steps,
    );
  }
}
