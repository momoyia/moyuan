import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/models/featured_topic.dart';
import 'package:peiban_app/models/topic_science_phase.dart';
import 'package:peiban_app/screens/featured/topic_countdown_screen.dart';
import 'package:peiban_app/services/featured_interaction_service.dart';

class TopicDetailScreen extends StatefulWidget {
  const TopicDetailScreen({super.key, required this.topic});

  final FeaturedTopic topic;

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  bool _joined = false;
  late List<bool> _phaseDone;
  bool _loading = true;

  FeaturedTopic get topic => widget.topic;

  int get _completedCount => _phaseDone.where((done) => done).length;

  @override
  void initState() {
    super.initState();
    _phaseDone = List.filled(topic.phases.length, false);
    _loadState();
  }

  Future<void> _loadState() async {
    final joined = await FeaturedInteractionService.isTopicJoined(topic.id);
    final phases = await FeaturedInteractionService.loadTopicPhases(
      topic.id,
      topic.phases.length,
    );
    if (!mounted) return;
    setState(() {
      _joined = joined;
      _phaseDone = phases;
      _loading = false;
    });
  }

  Future<void> _openTraining() async {
    final nextIndex = _phaseDone.indexWhere((done) => !done);
    final startIndex = nextIndex == -1 ? 0 : nextIndex;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TopicCountdownScreen(
          topic: topic,
          initialPhaseIndex: startIndex,
          phaseDone: List<bool>.from(_phaseDone),
          onComplete: (phases, joined) {
            setState(() {
              _phaseDone = phases;
              _joined = joined;
            });
          },
        ),
      ),
    );
  }

  Future<void> _togglePhase(int index) async {
    setState(() => _phaseDone[index] = !_phaseDone[index]);
    await FeaturedInteractionService.saveTopicPhases(topic.id, _phaseDone);
    if (_phaseDone.every((done) => done) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('恭喜！你已完成全部训练阶段 🎉'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = topic.phases.isEmpty ? 0.0 : _completedCount / topic.phases.length;

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: ElevatedButton(
            onPressed: _loading ? null : _openTraining,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text(
              '开始训练',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(topic.imageAsset, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.brandPink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            topic.badge,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          topic.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.slate50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.slate100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '阶段进度 $_completedCount/${topic.phases.length}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate900,
                              ),
                            ),
                            Text(
                              '${(progress * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.brandPink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: AppColors.slate100,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandPink),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _joined ? '点击阶段卡片标记完成' : '完成训练后可记录阶段进度',
                          style: const TextStyle(fontSize: 11, color: AppColors.slate400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: topic.facts.map((fact) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: fact == topic.facts.last ? 0 : 8,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.slate100),
                          ),
                          child: Column(
                            children: [
                              Text(
                                fact.label,
                                style: const TextStyle(fontSize: 10, color: AppColors.slate400),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                fact.value,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.slate900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle('科学原理'),
                  const SizedBox(height: 10),
                  Text(
                    topic.scienceIntro,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.slate600,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...topic.principles.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.science_outlined, size: 16, color: AppColors.brandPink),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.slate600,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle('阶段适应模型'),
                  const SizedBox(height: 6),
                  const Text(
                    '点击阶段标记完成，记录你的训练进度',
                    style: TextStyle(fontSize: 12, color: AppColors.slate400),
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(topic.phases.length, (index) {
                    return _PhaseCard(
                      phase: topic.phases[index],
                      done: _phaseDone[index],
                      enabled: _joined,
                      onTap: () => _togglePhase(index),
                    );
                  }),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _TagPanel(
                          title: '适用人群',
                          items: topic.suitableFor,
                          icon: Icons.person_outline,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TagPanel(
                          title: '注意事项',
                          items: topic.cautions,
                          icon: Icons.warning_amber_outlined,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.softPinkBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb_outline, size: 18, color: AppColors.brandPink),
                            SizedBox(width: 8),
                            Text(
                              '专家解读',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          topic.expertTip,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.slate600,
                            height: 1.6,
                          ),
                        ),
                      ],
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

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({
    required this.phase,
    required this.done,
    required this.enabled,
    required this.onTap,
  });

  final TopicSciencePhase phase;
  final bool done;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: done ? AppColors.softPinkBg : AppColors.slate50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: done ? AppColors.brandPink.withOpacity(0.3) : AppColors.slate100,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: done ? AppColors.brandPink : AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: done ? AppColors.brandPink : AppColors.slate100,
                ),
              ),
              child: Icon(
                done ? Icons.check : Icons.radio_button_unchecked,
                size: 16,
                color: done ? Colors.white : AppColors.slate400,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          phase.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: done ? AppColors.slate400 : AppColors.slate900,
                            decoration: done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      Text(
                        phase.duration,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.brandPink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    phase.focus,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    phase.explanation,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.slate500,
                      height: 1.5,
                    ),
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

class _TagPanel extends StatelessWidget {
  const _TagPanel({
    required this.title,
    required this.items,
    required this.icon,
    required this.color,
  });

  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '· $item',
                style: const TextStyle(fontSize: 11, color: AppColors.slate500, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
