import 'package:flutter/material.dart';
import 'package:peiban_app/constants/app_colors.dart';
import 'package:peiban_app/models/social_user_entry.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({
    super.key,
    required this.title,
    required this.emptyHint,
    required this.actionLabel,
    required this.users,
    required this.onRemove,
  });

  final String title;
  final String emptyHint;
  final String actionLabel;
  final List<SocialUserEntry> users;
  final Future<void> Function(String userId) onRemove;

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late List<SocialUserEntry> _users;

  @override
  void initState() {
    super.initState();
    _users = List<SocialUserEntry>.from(widget.users);
  }

  Future<void> _confirmRemove(SocialUserEntry user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.actionLabel),
        content: Text('确定将「${user.nickname}」${widget.actionLabel}吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(widget.actionLabel),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.onRemove(user.id);
      setState(() {
        _users = _users.where((item) => item.id != user.id).toList();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已${widget.actionLabel}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.slate900,
        elevation: 0,
      ),
      body: _users.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 48, color: AppColors.slate400.withOpacity(0.5)),
                  const SizedBox(height: 12),
                  Text(
                    widget.emptyHint,
                    style: const TextStyle(fontSize: 14, color: AppColors.slate400),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _users.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 72, color: AppColors.slate100),
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(user.avatarAsset),
                  ),
                  title: Text(
                    user.nickname,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate900,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () => _confirmRemove(user),
                    child: Text(
                      widget.actionLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandPink,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
