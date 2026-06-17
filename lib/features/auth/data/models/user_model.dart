class UserModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String? uid;
  final String? photoUrl;
  final int? streakDays;
  final int? totalPoints;
  final String? level;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.uid,
    this.photoUrl,
    this.streakDays,
    this.totalPoints,
    this.level,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'uid': uid,
      'photoUrl': photoUrl,
      'streakDays': streakDays,
      'totalPoints': totalPoints,
      'level': level,
    };
  }

  Map<String, dynamic> toCloudMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'streakDays': streakDays ?? 0,
      'totalPoints': totalPoints ?? 0,
      'level': level ?? 'مبتدئ',
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      password: map['password'] as String,
      uid: map['uid'] as String?,
      photoUrl: map['photoUrl'] as String?,
      streakDays: map['streakDays'] as int?,
      totalPoints: map['totalPoints'] as int?,
      level: map['level'] as String?,
    );
  }

  factory UserModel.fromCloudMap(Map<String, dynamic> map, {String? uid}) {
    return UserModel(
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      password: '',
      uid: uid ?? map['uid'] as String?,
      photoUrl: map['photoUrl'] as String?,
      streakDays: map['streakDays'] as int?,
      totalPoints: map['totalPoints'] as int?,
      level: map['level'] as String?,
    );
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? uid,
    String? photoUrl,
    int? streakDays,
    int? totalPoints,
    String? level,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      streakDays: streakDays ?? this.streakDays,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
    );
  }
}
