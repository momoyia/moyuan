import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/models/article.dart';
import 'package:peiban_app/services/featured_interaction_service.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Article article;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool _liked = false;
  bool _bookmarked = false;
  late List<bool> _takeawayChecked;
  bool _loading = true;

  Article get article => widget.article;

  int get _displayLikeCount => article.likeCount + (_liked ? 1 : 0);

  @override
  void initState() {
    super.initState();
    _takeawayChecked = List.filled(article.keyTakeaways.length, false);
    _loadState();
  }

  Future<void> _loadState() async {
    final liked = await FeaturedInteractionService.isArticleLiked(article.id);
    final bookmarked = await FeaturedInteractionService.isArticleBookmarked(article.id);
    final takeaways = await FeaturedInteractionService.loadArticleTakeaways(
      article.id,
      article.keyTakeaways.length,
    );
    if (!mounted) return;
    setState(() {
      _liked = liked;
      _bookmarked = bookmarked;
      _takeawayChecked = takeaways;
      _loading = false;
    });
  }

  Future<void> _toggleLike() async {
    final next = !_liked;
    await FeaturedInteractionService.setArticleLiked(article.id, next);
    if (!mounted) return;
    setState(() => _liked = next);
  }

  Future<void> _toggleBookmark() async {
    final next = !_bookmarked;
    await FeaturedInteractionService.setArticleBookmarked(article.id, next);
    if (!mounted) return;
    setState(() => _bookmarked = next);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(next ? '已收藏文章' : '已取消收藏'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _toggleTakeaway(int index) async {
    setState(() => _takeawayChecked[index] = !_takeawayChecked[index]);
    await FeaturedInteractionService.saveArticleTakeaways(article.id, _takeawayChecked);
    if (_takeawayChecked.every((checked) => checked) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('核心要点已全部掌握 👏'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final takeawayProgress = _takeawayChecked.where((c) => c).length;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('科学解读'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.slate900,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loading ? null : _toggleBookmark,
            icon: Icon(
              _bookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _bookmarked ? AppColors.brandPink : AppColors.slate600,
            ),
          ),
          IconButton(
            onPressed: _loading ? null : _toggleLike,
            icon: Icon(
              _liked ? Icons.favorite : Icons.favorite_border,
              color: _liked ? AppColors.brandPink : AppColors.slate600,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _loading ? null : _toggleLike,
                  icon: Icon(
                    _liked ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: _liked ? AppColors.brandPink : AppColors.slate600,
                  ),
                  label: Text(
                    '$_displayLikeCount',
                    style: TextStyle(
                      color: _liked ? AppColors.brandPink : AppColors.slate600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.slate100),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _toggleBookmark,
                  icon: Icon(
                    _bookmarked ? Icons.bookmark : Icons.bookmark_add_outlined,
                    size: 18,
                  ),
                  label: Text(_bookmarked ? '已收藏' : '收藏文章'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.softPinkBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              article.category,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.brandPink,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            article.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '阅读 ${article.readCount} · 赞 $_displayLikeCount',
            style: const TextStyle(fontSize: 12, color: AppColors.slate400),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _SectionTitle('核心要点'),
              Text(
                '$takeawayProgress/${article.keyTakeaways.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandPink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '点击勾选，标记你已掌握的知识点',
            style: TextStyle(fontSize: 11, color: AppColors.slate400),
          ),
          const SizedBox(height: 12),
          ...List.generate(article.keyTakeaways.length, (index) {
            final checked = _takeawayChecked[index];
            return GestureDetector(
              onTap: () => _toggleTakeaway(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: checked ? AppColors.softPinkBg : AppColors.slate50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: checked ? AppColors.brandPink.withOpacity(0.3) : AppColors.slate100,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      checked ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 18,
                      color: checked ? AppColors.brandPink : AppColors.slate400,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        article.keyTakeaways[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: checked ? AppColors.slate400 : AppColors.slate600,
                          height: 1.5,
                          decoration: checked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          ...article.sections.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(section.title),
                  const SizedBox(height: 10),
                  Text(
                    section.body,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.slate600,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.slate900,
      ),
    );
  }
}
