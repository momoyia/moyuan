import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_assets.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/screens/auth/login_screen.dart';
import 'package:peiban_app/screens/auth/onboarding_screen.dart';
import 'package:peiban_app/screens/main_screen.dart';
import 'package:peiban_app/services/app_state.dart';
import 'package:peiban_app/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.appState});

  final AppState appState;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    final loggedIn = await StorageService.loadLoggedIn();
    if (!mounted) return;

    final Widget nextScreen;
    if (!loggedIn) {
      nextScreen = LoginScreen(appState: widget.appState);
    } else {
      final onboardingDone = await StorageService.loadOnboardingCompleted();
      if (!mounted) return;
      nextScreen = onboardingDone
          ? MainScreen(appState: widget.appState)
          : OnboardingScreen(appState: widget.appState);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            AppAssets.appIcon,
            width: 96,
            height: 96,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
