import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_assets.dart';
import 'package:peiban_app/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('关于我们'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.slate900,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                AppAssets.appIcon,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '相恋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.slate900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              '陪你练，也陪你变好',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.brandPink,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.slate100),
            ),
            child: const Text(
              '相恋是一款面向年轻用户的健身减脂应用，提供科学训练计划、轻食营养指南与运动数据追踪。我们希望用简洁好用的体验，陪你和 TA 一起坚持运动、管理身材、记录每一次进步。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.slate600,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 12, color: AppColors.slate400),
            ),
          ),
        ],
      ),
    );
  }
}
