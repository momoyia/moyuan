import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/models/workout_action.dart';
import 'package:peiban_app/screens/featured/action_countdown_screen.dart';
import 'package:peiban_app/services/featured_interaction_service.dart';

class ActionDetailScreen extends StatefulWidget {
  const ActionDetailScreen({super.key, required this.action});

  final WorkoutAction action;

  @override
  State<ActionDetailScreen> createState() => _ActionDetailScreenState();
}

class _ActionDetailScreenState extends State<ActionDetailScreen> {
  bool _descExpanded = false;
  bool _wantTrain = false;
  bool _inCalendar = false;
  int _totalPractice = 0;
  bool _loading = true;

  WorkoutAction get action => widget.action;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final want = await FeaturedInteractionService.isActionWantTrain(action.id);
    final calendar = await FeaturedInteractionService.isActionInCalendar(action.id);
    final count = await FeaturedInteractionService.loadActionPracticeCount(action.id);
    if (!mounted) return;
    setState(() {
      _wantTrain = want;
      _inCalendar = calendar;
      _totalPractice = count;
      _loading = false;
    });
  }

  Future<void> _toggleWantTrain() async {
    final next = !_wantTrain;
    await FeaturedInteractionService.setActionWantTrain(action.id, next);
    if (!mounted) return;
    setState(() => _wantTrain = next);
    _showSnack(next ? '已加入想练清单' : '已移出想练清单');
  }

  Future<void> _toggleCalendar() async {
    final next = !_inCalendar;
    await FeaturedInteractionService.setActionInCalendar(action.id, next);
    if (!mounted) return;
    setState(() => _inCalendar = next);
    _showSnack(next ? '已添加到训练日历' : '已从日历移除');
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 1)),
    );
  }

  void _showSegments() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '动作分段',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.slate900),
            ),
            const SizedBox(height: 14),
            ...List.generate(action.tips.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.softPinkBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brandPink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        action.tips[index],
                        style: const TextStyle(fontSize: 13, color: AppColors.slate600, height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _openPractice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActionCountdownScreen(
          action: action,
          initialPractice: _totalPractice,
          onPracticeUpdated: (count) {
            setState(() => _totalPractice = count);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desc = action.description;
    final showExpand = desc.length > 48;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _CoverHeader(action: action, onSegments: _showSegments)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.slate50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFBBF24)),
                            const SizedBox(width: 4),
                            Text(
                              '${action.rating} 分',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        action.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.slate900,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _MetaItem(action.difficultyLabel),
                          _MetaDivider(),
                          _MetaItem('${action.durationMinutes} 分钟'),
                          _MetaDivider(),
                          _MetaItem('${action.caloriesMin} - ${action.caloriesMax} 千卡'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.softPinkBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.watch_later_outlined, size: 16, color: AppColors.brandPink),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '陌缘智能记录  精准追踪消耗',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brandPink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundImage: AssetImage(action.authorAvatar),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            action.authorName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: showExpand ? () => setState(() => _descExpanded = !_descExpanded) : null,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 13, color: AppColors.slate500, height: 1.6),
                            children: [
                              TextSpan(
                                text: _descExpanded || !showExpand ? desc : '${desc.substring(0, 48)}…',
                              ),
                              if (showExpand)
                                TextSpan(
                                  text: _descExpanded ? ' 收起' : ' 更多',
                                  style: const TextStyle(
                                    color: AppColors.brandPink,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 1, color: AppColors.slate100),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _InteractItem(
                            icon: Icons.playlist_add,
                            label: '想练',
                            active: _wantTrain,
                            onTap: _loading ? null : _toggleWantTrain,
                          ),
                          _InteractItem(
                            icon: Icons.calendar_today_outlined,
                            label: '加日历',
                            active: _inCalendar,
                            onTap: _loading ? null : _toggleCalendar,
                          ),
                          _InteractItem(
                            icon: Icons.history,
                            label: '练过',
                            badge: _totalPractice > 0 ? '$_totalPractice' : action.practicedLabel,
                            onTap: () => _showSnack('你已累计练习 $_totalPractice 组'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const _SectionTitle('标准要领'),
                      const SizedBox(height: 10),
                      ...action.tips.map(
                        (tip) => _BulletRow(icon: Icons.check_circle_outline, text: tip),
                      ),
                      const SizedBox(height: 20),
                      const _SectionTitle('目标肌群'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: action.targetMuscles.map((muscle) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.slate50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.slate100),
                            ),
                            child: Text(
                              muscle,
                              style: const TextStyle(fontSize: 12, color: AppColors.slate600),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const _SectionTitle('动作原理'),
                      const SizedBox(height: 8),
                      Text(
                        action.biomechanics,
                        style: const TextStyle(fontSize: 13, color: AppColors.slate600, height: 1.7),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    _NavIconButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomBar(onGoTap: _openPractice),
          ),
        ],
      ),
    );
  }
}

class _CoverHeader extends StatelessWidget {
  const _CoverHeader({required this.action, required this.onSegments});

  final WorkoutAction action;
  final VoidCallback onSegments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(action.imageAsset, fit: BoxFit.cover),
          Positioned(
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: onSegments,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '动作分段',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slate600),
    );
  }
}

class _MetaDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: AppColors.slate100,
    );
  }
}

class _InteractItem extends StatelessWidget {
  const _InteractItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.badge,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 22,
            color: active ? AppColors.brandPink : AppColors.slate600,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? AppColors.brandPink : AppColors.slate500,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (badge != null) ...[
            const SizedBox(height: 2),
            Text(
              badge!,
              style: TextStyle(
                fontSize: 9,
                color: active ? AppColors.brandPink : AppColors.slate400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onGoTap});

  final VoidCallback onGoTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      color: AppColors.white,
      child: Center(
        child: GestureDetector(
          onTap: onGoTap,
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              gradient: AppColors.brandGradient,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'GO',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
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
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.slate900),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.brandPink),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.slate600, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
