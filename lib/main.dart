import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_info.dart';
import 'package:peiban_app/constants/app_theme.dart';
import 'package:peiban_app/screens/auth/splash_screen.dart';
import 'package:peiban_app/services/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = await AppState.load();
  runApp(PeibanApp(appState: appState));
}

class PeibanApp extends StatefulWidget {
  const PeibanApp({super.key, required this.appState});

  final AppState appState;

  @override
  State<PeibanApp> createState() => _PeibanAppState();
}

class _PeibanAppState extends State<PeibanApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: SplashScreen(appState: widget.appState),
    );
  }
}
