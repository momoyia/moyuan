import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/models/featured_topic.dart';
import 'package:peiban_app/screens/featured/topic_detail_screen.dart';

class TopicRecommendLoadingScreen extends StatefulWidget {
  const TopicRecommendLoadingScreen({super.key, required this.topic});

  final FeaturedTopic topic;

  @override
  State<TopicRecommendLoadingScreen> createState() => _TopicRecommendLoadingScreenState();
}

class _TopicRecommendLoadingScreenState extends State<TopicRecommendLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _fadeAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _openTopicDetail();
  }

  Future<void> _openTopicDetail() async {
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => TopicDetailScreen(topic: widget.topic),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.softPinkBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        color: AppColors.brandPink,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  '正在为你匹配特训专题',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.topic.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 32),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.brandPink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
