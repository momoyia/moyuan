class TopicSciencePhase {
  const TopicSciencePhase({
    required this.title,
    required this.duration,
    required this.focus,
    required this.explanation,
  });

  final String title;
  final String duration;
  final String focus;
  final String explanation;
}

class ScienceFact {
  const ScienceFact({
    required this.label,
    required this.value,
    required this.note,
  });

  final String label;
  final String value;
  final String note;
}
