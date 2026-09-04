import 'package:flutter_test/flutter_test.dart';
import 'package:peiban_app/main.dart';
import 'package:peiban_app/models/user_profile.dart';
import 'package:peiban_app/models/workout_stats.dart';
import 'package:peiban_app/services/app_state.dart';

void main() {
  testWidgets('App launches home screen', (WidgetTester tester) async {
    final appState = AppState(
      profile: const UserProfile(
        nickname: '测试',
        bio: '测试',
        avatarIndex: 0,
        level: 1,
      ),
      stats: WorkoutStats.fromJson({}),
      notificationsEnabled: true,
      dailyReminder: '07:30',
    );

    await tester.pumpWidget(PeibanApp(appState: appState));
    await tester.pumpAndSettle();

    expect(find.text('今日燃脂计划 🔥'), findsOneWidget);
  });
}
