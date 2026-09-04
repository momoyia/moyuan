import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peiban_app/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.brandPink,
        secondary: AppColors.brandMagenta,
        surface: AppColors.white,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.slate900,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.slate900,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      dividerColor: AppColors.slate100,
      splashColor: AppColors.brandPink.withOpacity(0.08),
      highlightColor: AppColors.brandPink.withOpacity(0.05),
    );
  }
}
