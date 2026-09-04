import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/services/app_state.dart';

class CourseFavoriteButton extends StatefulWidget {
  const CourseFavoriteButton({
    super.key,
    required this.courseId,
    required this.appState,
    this.onStateChanged,
    this.iconColor,
    this.activeColor = AppColors.brandPink,
  });

  final String courseId;
  final AppState appState;
  final VoidCallback? onStateChanged;
  final Color? iconColor;
  final Color activeColor;

  @override
  State<CourseFavoriteButton> createState() => _CourseFavoriteButtonState();
}

class _CourseFavoriteButtonState extends State<CourseFavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.appState.isFavorite(widget.courseId);
  }

  Future<void> _toggle() async {
    await widget.appState.toggleFavorite(widget.courseId);
    final nowFavorite = widget.appState.isFavorite(widget.courseId);
    setState(() => _isFavorite = nowFavorite);
    widget.onStateChanged?.call();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nowFavorite ? '已加入收藏，可在「我的」查看' : '已取消收藏'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inactive = widget.iconColor ?? AppColors.slate900;
    return IconButton(
      onPressed: _toggle,
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? widget.activeColor : inactive,
      ),
    );
  }
}
