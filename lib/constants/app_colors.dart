import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color brandPink = Color(0xFFFD375E);
  static const Color brandMagenta = Color(0xFFF73DD0);
  static const Color softPinkBg = Color(0xFFFFF1F4);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color white = Color(0xFFFFFFFF);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandPink, brandMagenta],
  );
}
