import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_assets.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/models/user_profile.dart';
import 'package:peiban_app/services/app_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

  final AppState appState;
  final VoidCallback onStateChanged;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nicknameController;
  late TextEditingController _bioController;
  late int _avatarIndex;

  @override
  void initState() {
    super.initState();
    final profile = widget.appState.profile;
    _nicknameController = TextEditingController(text: profile.nickname);
    _bioController = TextEditingController(text: profile.bio);
    _avatarIndex = profile.avatarIndex;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final current = widget.appState.profile;
    final updated = current.copyWith(
      nickname: _nicknameController.text.trim().isEmpty
          ? '鸡蛋炒饭'
          : _nicknameController.text.trim(),
      bio: _bioController.text.trim(),
      avatarIndex: _avatarIndex,
    );
    await widget.appState.updateProfile(updated);
    widget.onStateChanged();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑个人资料'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('保存', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('选择头像', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(AppAssets.avatars.length, (index) {
              final selected = _avatarIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _avatarIndex = index),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? AppColors.brandPink : AppColors.slate100,
                      width: selected ? 3 : 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(AppAssets.avatars[index], fit: BoxFit.cover),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nicknameController,
            decoration: InputDecoration(
              labelText: '昵称',
              filled: true,
              fillColor: AppColors.slate50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bioController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: '个性签名',
              filled: true,
              fillColor: AppColors.slate50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}
