import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/data/mock_data.dart';

class WorkoutFocusDialog extends StatefulWidget {
  const WorkoutFocusDialog({super.key});

  @override
  State<WorkoutFocusDialog> createState() => _WorkoutFocusDialogState();
}

class _WorkoutFocusDialogState extends State<WorkoutFocusDialog> {
  String? _selectedId;

  void _confirm() {
    if (_selectedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择你想锻炼的部位')),
      );
      return;
    }
    Navigator.pop(context, _selectedId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '你想锻炼哪个部位？',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.slate900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '选择后将为你推荐匹配的特训专题',
              style: TextStyle(fontSize: 13, color: AppColors.slate500, height: 1.5),
            ),
            const SizedBox(height: 20),
            ...MockData.workoutFocusOptions.map((option) {
              final id = option['id'] as String;
              final selected = _selectedId == id;
              return GestureDetector(
                onTap: () => setState(() => _selectedId = id),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.softPinkBg : AppColors.slate50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? AppColors.brandPink : AppColors.slate100,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        option['icon'] as IconData,
                        size: 20,
                        color: selected ? AppColors.brandPink : AppColors.slate400,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option['label'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: selected ? AppColors.slate900 : AppColors.slate600,
                              ),
                            ),
                            Text(
                              option['subtitle'] as String,
                              style: const TextStyle(fontSize: 11, color: AppColors.slate400),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        selected ? Icons.check_circle : Icons.circle_outlined,
                        size: 20,
                        color: selected ? AppColors.brandPink : AppColors.slate400,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _confirm,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brandPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  '开始匹配',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
