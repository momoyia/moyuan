import 'package:flutter/material.dart';
import 'package:peiban_app/screens/discover/discover_screen.dart';
import 'package:peiban_app/screens/featured/featured_screen.dart';
import 'package:peiban_app/screens/home/home_screen.dart';
import 'package:peiban_app/screens/profile/profile_screen.dart';
import 'package:peiban_app/services/app_state.dart';
import 'package:peiban_app/widgets/app_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.appState});

  final AppState appState;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        appState: widget.appState,
        onStateChanged: _onStateChanged,
      ),
      const DiscoverScreen(),
      const FeaturedScreen(),
      ProfileScreen(
        appState: widget.appState,
        onStateChanged: _onStateChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
