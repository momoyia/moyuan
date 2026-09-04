import 'package:flutter/material.dart';
import 'package:peiban_app/data/mock_data.dart';
import 'package:peiban_app/models/course.dart';
import 'package:peiban_app/screens/home/course_detail_screen.dart';
import 'package:peiban_app/services/app_state.dart';
import 'package:peiban_app/widgets/course_card.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

  final AppState appState;
  final VoidCallback onStateChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('全部课程')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: MockData.courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final course = MockData.courses[index];
          return CourseCard(
            course: course,
            onTap: () => _openDetail(context, course),
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(
          course: course,
          appState: appState,
          onStateChanged: onStateChanged,
        ),
      ),
    );
  }
}
