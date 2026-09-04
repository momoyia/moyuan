class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.category,
    required this.imageAsset,
    required this.ingredients,
    required this.steps,
  });

  final String id;
  final String title;
  final String description;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String category;
  final String imageAsset;
  final List<String> ingredients;
  final List<String> steps;
}
