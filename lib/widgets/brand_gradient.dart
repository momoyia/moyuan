import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';

class BrandGradientBox extends StatelessWidget {
  const BrandGradientBox({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandPink.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class BrandGradientText extends StatelessWidget {
  const BrandGradientText({
    super.key,
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
      child: Text(
        text,
        style: (style ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))
            .copyWith(color: Colors.white),
      ),
    );
  }
}
