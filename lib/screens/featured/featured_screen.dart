import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/data/mock_data.dart';
import 'package:peiban_app/models/article.dart';
import 'package:peiban_app/models/featured_topic.dart';
import 'package:peiban_app/models/workout_action.dart';
import 'package:peiban_app/screens/featured/action_detail_screen.dart';
import 'package:peiban_app/screens/featured/article_detail_screen.dart';
import 'package:peiban_app/screens/featured/topic_detail_screen.dart';
class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {
  int _selectedTab = 0;

  List<FeaturedTopic> get _topics => MockData.topics;
  List<WorkoutAction> get _actions => MockData.actions;
  List<Article> get _articles => MockData.articles;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          Row(
            children: List.generate(MockData.featuredTabs.length, (index) {
              final selected = _selectedTab == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = index),
                child: Container(
                  margin: EdgeInsets.only(right: index < 3 ? 16 : 0),
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: selected ? AppColors.brandPink : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    MockData.featuredTabs[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected ? AppColors.brandPink : AppColors.slate400,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          if (_selectedTab == 0) ...[
            const Text(
              '🔥 本周限时热门特训专题',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate900),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _topics.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final topic = _topics[index];
                  return _TopicCard(
                    topic: topic,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TopicDetailScreen(topic: topic),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '⚡ 高效减脂经典动作库',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate900),
            ),
            const SizedBox(height: 12),
            ..._actions.map(
              (action) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ActionRow(
                  action: action,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActionDetailScreen(action: action),
                      ),
                    );
                  },
                ),
              ),
            ),
          ] else if (_selectedTab == 1) ...[
            ..._articles.map(
              (article) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ArticleCard(
                  article: article,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                ),
              ),
            ),
          ] else if (_selectedTab == 2) ...[
            ..._actions.map(
              (action) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ActionRow(
                  action: action,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActionDetailScreen(action: action),
                      ),
                    );
                  },
                ),
              ),
            ),
          ] else ...[
            ..._topics.where((t) => t.badge.contains('拉伸') || t.id.contains('stretch')).map(
              (topic) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TopicCard(
                  topic: topic,
                  fullWidth: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TopicDetailScreen(topic: topic),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_topics.every((t) => !t.badge.contains('拉伸')))
              ..._topics.map(
                (topic) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TopicCard(
                    topic: topic,
                    fullWidth: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TopicDetailScreen(topic: topic),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
          if (_selectedTab == 0) ...[
            const SizedBox(height: 24),
            const Text(
              '📚 健身锻炼知识科学分享',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate900),
            ),
            const SizedBox(height: 12),
            if (_articles.isNotEmpty)
              _ArticleCard(
                article: _articles.first,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailScreen(article: _articles.first),
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.onTap,
    this.fullWidth = false,
  });

  final FeaturedTopic topic;
  final VoidCallback onTap;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : 192,
        decoration: BoxDecoration(
          color: AppColors.slate50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate100),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  topic.imageAsset,
                  height: fullWidth ? 140 : 112,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      topic.badge,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '已有 ${topic.participants} 人参与打卡',
                    style: const TextStyle(fontSize: 10, color: AppColors.slate400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.action, required this.onTap});

  final WorkoutAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.slate50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate100),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(action.imageAsset, width: 48, height: 48, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate900),
                  ),
                  Text(
                    action.subtitle,
                    style: const TextStyle(fontSize: 10, color: AppColors.slate500),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.softPinkBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                action.sets,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.brandPink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.onTap});

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.softPinkBg.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFCE7F3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.brandPink,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '荐',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    article.title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              article.summary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.slate600, height: 1.5),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '阅读 ${article.readCount} · 赞 ${article.likeCount}',
                  style: const TextStyle(fontSize: 10, color: AppColors.slate400),
                ),
                const Text(
                  '阅读全文 →',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.brandPink),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
