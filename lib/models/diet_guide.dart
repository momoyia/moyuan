class DietGuideDay {
  const DietGuideDay({
    required this.day,
    required this.theme,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.calories,
  });

  final int day;
  final String theme;
  final String breakfast;
  final String lunch;
  final String dinner;
  final int calories;
}

class DietGuide {
  const DietGuide({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.imageAsset,
    required this.intro,
    required this.highlights,
    required this.dailyCalories,
    required this.proteinGrams,
    required this.durationDays,
    required this.principles,
    required this.days,
    required this.shoppingList,
    required this.tips,
    required this.avoidList,
    required this.relatedRecipeIds,
  });

  final String title;
  final String subtitle;
  final String badge;
  final String imageAsset;
  final String intro;
  final List<String> highlights;
  final int dailyCalories;
  final int proteinGrams;
  final int durationDays;
  final List<String> principles;
  final List<DietGuideDay> days;
  final List<String> shoppingList;
  final List<String> tips;
  final List<String> avoidList;
  final List<String> relatedRecipeIds;
}
