class SocialUserEntry {
  const SocialUserEntry({
    required this.id,
    required this.nickname,
    required this.avatarAsset,
  });

  final String id;
  final String nickname;
  final String avatarAsset;

  factory SocialUserEntry.fromJson(Map<String, dynamic> json) {
    return SocialUserEntry(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      avatarAsset: json['avatarAsset'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'avatarAsset': avatarAsset,
    };
  }
}
