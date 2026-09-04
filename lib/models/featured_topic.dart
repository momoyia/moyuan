import 'package:peiban_app/models/topic_science_phase.dart';

class FeaturedTopic {
  const FeaturedTopic({
    required this.id,
    required this.title,
    required this.badge,
    required this.participants,
    required this.imageAsset,
    required this.description,
    required this.days,
    required this.scienceIntro,
    required this.principles,
    required this.suitableFor,
    required this.cautions,
    required this.phases,
    required this.facts,
    required this.expertTip,
  });

  final String id;
  final String title;
  final String badge;
  final String participants;
  final String imageAsset;
  final String description;
  final int days;
  final String scienceIntro;
  final List<String> principles;
  final List<String> suitableFor;
  final List<String> cautions;
  final List<TopicSciencePhase> phases;
  final List<ScienceFact> facts;
  final String expertTip;
}
