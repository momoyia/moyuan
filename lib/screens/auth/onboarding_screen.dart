import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/data/mock_data.dart';
import 'package:peiban_app/screens/main_screen.dart';
import 'package:peiban_app/services/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.appState});

  final AppState appState;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final _heightController = TextEditingController(text: '165');
  final _weightController = TextEditingController(text: '60');
  final _targetWeightController = TextEditingController(text: '55');

  int _step = 0;
  final Set<String> _selectedInterests = {};
  String _selectedPlanId = MockData.fitnessPlans.first['id']!;

  @override
  void dispose() {
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    switch (_step) {
      case 0:
        final height = double.tryParse(_heightController.text);
        final weight = double.tryParse(_weightController.text);
        if (height == null || height < 100 || height > 230) {
          _showTip('请输入有效的身高（100–230 cm）');
          return false;
        }
        if (weight == null || weight < 30 || weight > 200) {
          _showTip('请输入有效的体重（30–200 kg）');
          return false;
        }
        return true;
      case 1:
        final target = double.tryParse(_targetWeightController.text);
        if (target == null || target < 30 || target > 200) {
          _showTip('请输入有效的目标体重（30–200 kg）');
          return false;
        }
        return true;
      case 2:
        if (_selectedInterests.isEmpty) {
          _showTip('请至少选择一个感兴趣的项目');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showTip(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;
    if (_step < 3) {
      setState(() => _step++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    _finish();
  }

  void _prevStep() {
    if (_step == 0) return;
    setState(() => _step--);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    await widget.appState.completeOnboarding(
      heightCm: double.parse(_heightController.text),
      weightKg: double.parse(_weightController.text),
      targetWeightKg: double.parse(_targetWeightController.text),
      interests: _selectedInterests.toList(),
      planId: _selectedPlanId,
    );
    if (!mounted) return;

    final enableTeenMode = await _showTeenModeDialog();
    if (!mounted) return;

    await widget.appState.setTeenMode(enableTeenMode == true);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainScreen(appState: widget.appState),
      ),
    );
  }

  Future<bool?> _showTeenModeDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '开启青少年模式',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '青少年模式下将限制部分功能，营造更健康、更安心的使用环境。是否现在开启？',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.slate600),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.slate600,
                      side: const BorderSide(color: AppColors.slate100),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '暂不开启',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '开启',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  if (_step > 0)
                    IconButton(
                      onPressed: _prevStep,
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    )
                  else
                    const SizedBox(width: 32),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        final active = index <= _step;
                        return Container(
                          width: index == _step ? 20 : 8,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: active ? AppColors.brandPink : AppColors.slate100,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 32),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _BodyMetricsStep(
                    title: '填写身体数据',
                    subtitle: '帮助我们为你定制更合适的训练方案',
                    heightController: _heightController,
                    weightController: _weightController,
                  ),
                  _TargetWeightStep(
                    targetWeightController: _targetWeightController,
                    currentWeight: _weightController.text,
                  ),
                  _InterestsStep(
                    selected: _selectedInterests,
                    onToggle: (item) {
                      setState(() {
                        if (_selectedInterests.contains(item)) {
                          _selectedInterests.remove(item);
                        } else {
                          _selectedInterests.add(item);
                        }
                      });
                    },
                  ),
                  _PlanStep(
                    selectedPlanId: _selectedPlanId,
                    onSelect: (id) => setState(() => _selectedPlanId = id),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _step == 3 ? '开始训练之旅' : '下一步',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyMetricsStep extends StatelessWidget {
  const _BodyMetricsStep({
    required this.title,
    required this.subtitle,
    required this.heightController,
    required this.weightController,
  });

  final String title;
  final String subtitle;
  final TextEditingController heightController;
  final TextEditingController weightController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.5),
          ),
          const SizedBox(height: 32),
          _MetricField(label: '身高', unit: 'cm', controller: heightController),
          const SizedBox(height: 16),
          _MetricField(label: '体重', unit: 'kg', controller: weightController),
        ],
      ),
    );
  }
}

class _TargetWeightStep extends StatelessWidget {
  const _TargetWeightStep({
    required this.targetWeightController,
    required this.currentWeight,
  });

  final TextEditingController targetWeightController;
  final String currentWeight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '设定目标体重',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '设定一个合理的目标，我们会帮你追踪变化',
            style: TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.5),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.slate100),
            ),
            child: Text(
              '当前体重：${currentWeight.isEmpty ? '--' : '$currentWeight kg'}',
              style: const TextStyle(fontSize: 14, color: AppColors.slate600),
            ),
          ),
          const SizedBox(height: 20),
          _MetricField(label: '目标体重', unit: 'kg', controller: targetWeightController),
        ],
      ),
    );
  }
}

class _InterestsStep extends StatelessWidget {
  const _InterestsStep({
    required this.selected,
    required this.onToggle,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;

  static const _icons = [
    Icons.local_fire_department_outlined,
    Icons.fitness_center_outlined,
    Icons.self_improvement_outlined,
    Icons.directions_run_outlined,
    Icons.spa_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '感兴趣的健身项目',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '可多选，我们将为你推荐相关内容',
            style: TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.5),
          ),
          const SizedBox(height: 24),
          ...List.generate(MockData.onboardingInterests.length, (index) {
            final item = MockData.onboardingInterests[index];
            final isSelected = selected.contains(item);
            return GestureDetector(
              onTap: () => onToggle(item),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.softPinkBg : AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.brandPink : AppColors.slate100,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _icons[index % _icons.length],
                      size: 20,
                      color: isSelected ? AppColors.brandPink : AppColors.slate400,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.slate900 : AppColors.slate600,
                        ),
                      ),
                    ),
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      size: 20,
                      color: isSelected ? AppColors.brandPink : AppColors.slate400,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PlanStep extends StatelessWidget {
  const _PlanStep({
    required this.selectedPlanId,
    required this.onSelect,
  });

  final String selectedPlanId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择健身计划',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '根据你的目标，选择最适合的训练周期',
            style: TextStyle(fontSize: 14, color: AppColors.slate500, height: 1.5),
          ),
          const SizedBox(height: 24),
          ...MockData.fitnessPlans.map((plan) {
            final selected = selectedPlanId == plan['id'];
            return GestureDetector(
              onTap: () => onSelect(plan['id']!),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected ? AppColors.softPinkBg : AppColors.slate50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? AppColors.brandPink : AppColors.slate100,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: selected ? AppColors.brandPink : AppColors.slate400,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan['title']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plan['subtitle']!,
                            style: const TextStyle(fontSize: 12, color: AppColors.slate500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MetricField extends StatelessWidget {
  const _MetricField({
    required this.label,
    required this.unit,
    required this.controller,
  });

  final String label;
  final String unit;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.slate600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: '请输入$label',
            suffixText: unit,
            filled: true,
            fillColor: AppColors.slate50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.slate100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.slate100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.brandPink),
            ),
          ),
        ),
      ],
    );
  }
}
