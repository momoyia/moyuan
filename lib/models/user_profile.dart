class UserProfile {
  const UserProfile({
    required this.nickname,
    required this.bio,
    required this.avatarIndex,
    required this.level,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.interestedCategories,
  });

  final String nickname;
  final String bio;
  final int avatarIndex;
  final int level;
  final double heightCm;
  final double weightKg;
  final double targetWeightKg;
  final List<String> interestedCategories;

  UserProfile copyWith({
    String? nickname,
    String? bio,
    int? avatarIndex,
    int? level,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
    List<String>? interestedCategories,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      bio: bio ?? this.bio,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      level: level ?? this.level,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      interestedCategories: interestedCategories ?? this.interestedCategories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'bio': bio,
      'avatarIndex': avatarIndex,
      'level': level,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'targetWeightKg': targetWeightKg,
      'interestedCategories': interestedCategories,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] as String? ?? '鸡蛋炒饭',
      bio: json['bio'] as String? ?? '自律给我自由，坚持遇见更好的自己 ✨',
      avatarIndex: json['avatarIndex'] as int? ?? 1,
      level: json['level'] as int? ?? 4,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 165,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 60,
      targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble() ?? 55,
      interestedCategories: (json['interestedCategories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
