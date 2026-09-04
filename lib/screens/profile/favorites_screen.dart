import 'package:flutter/material.dart';
import 'package:peiban_app/data/mock_data.dart';
import 'package:peiban_app/screens/home/course_detail_screen.dart';
import 'package:peiban_app/services/app_state.dart';
import 'package:peiban_app/widgets/course_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

  final AppState appState;
  final VoidCallback onStateChanged;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final favorites = MockData.courses
        .where((course) => widget.appState.isFavorite(course.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('收藏的健身教程')),
      body: favorites.isEmpty
          ? const Center(child: Text('还没有收藏课程'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final course = favorites[index];
                return CourseCard(
                  course: course,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailScreen(
                          course: course,
                          appState: widget.appState,
                          onStateChanged: () {
                            _refresh();
                            widget.onStateChanged();
                          },
                        ),
                      ),
                    );
                    _refresh();
                    widget.onStateChanged();
                  },
                );
              },
            ),
    );
  }
}
