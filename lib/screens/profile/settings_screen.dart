import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/screens/profile/about_screen.dart';
import 'package:peiban_app/screens/profile/feedback_screen.dart';
import 'package:peiban_app/screens/profile/user_list_screen.dart';
import 'package:peiban_app/services/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.appState,
    required this.onStateChanged,
  });

  final AppState appState;
  final VoidCallback onStateChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _toggleTeenMode(bool value) async {
    await widget.appState.setTeenMode(value);
    setState(() {});
    widget.onStateChanged();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? '青少年模式已开启' : '青少年模式已关闭'),
        ),
      );
    }
  }

  Future<void> _openBlockList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserListScreen(
          title: '拉黑名单',
          emptyHint: '暂无拉黑用户',
          actionLabel: '取消拉黑',
          users: widget.appState.blockedUsers,
          onRemove: (userId) async {
            await widget.appState.unblockUser(userId);
            widget.onStateChanged();
            if (mounted) setState(() {});
          },
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _openMuteList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserListScreen(
          title: '屏蔽名单',
          emptyHint: '暂无屏蔽用户',
          actionLabel: '取消屏蔽',
          users: widget.appState.mutedUsers,
          onRemove: (userId) async {
            await widget.appState.unmuteUser(userId);
            widget.onStateChanged();
            if (mounted) setState(() {});
          },
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final blockCount = widget.appState.blockedUsers.length;
    final muteCount = widget.appState.mutedUsers.length;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.slate900,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const _SectionHeader('通用'),
          _SettingsSwitchTile(
            title: '青少年模式',
            subtitle: '限制部分功能，营造健康使用环境',
            value: widget.appState.teenModeEnabled,
            onChanged: _toggleTeenMode,
          ),
          const _SectionHeader('隐私与安全'),
          _SettingsNavTile(
            title: '拉黑名单',
            trailing: blockCount > 0 ? '$blockCount 人' : null,
            onTap: _openBlockList,
          ),
          _SettingsNavTile(
            title: '屏蔽名单',
            trailing: muteCount > 0 ? '$muteCount 人' : null,
            onTap: _openMuteList,
          ),
          const _SectionHeader('帮助与反馈'),
          _SettingsNavTile(
            title: '意见反馈',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FeedbackScreen()),
              );
            },
          ),
          _SettingsNavTile(
            title: '关于我们',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.slate400,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.slate900,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.slate400),
      ),
      value: value,
      activeColor: AppColors.brandPink,
      onChanged: onChanged,
    );
  }
}

class _SettingsNavTile extends StatelessWidget {
  const _SettingsNavTile({
    required this.title,
    this.trailing,
    required this.onTap,
  });

  final String title;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.slate900,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing!,
              style: const TextStyle(fontSize: 13, color: AppColors.slate400),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 20, color: AppColors.slate400),
        ],
      ),
      onTap: onTap,
    );
  }
}
