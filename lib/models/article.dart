import 'package:peiban_app/models/article_section.dart';

class Article {
  const Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.readCount,
    required this.likeCount,
    required this.category,
    required this.keyTakeaways,
    required this.sections,
    required this.references,
  });

  final String id;
  final String title;
  final String summary;
  final String content;
  final String readCount;
  final int likeCount;
  final String category;
  final List<String> keyTakeaways;
  final List<ArticleSection> sections;
  final List<String> references;
}
