class User {
  final int? id;
  final String email;
  final String password;
  final String? name;
  final String? avatarPath;
  final DateTime? memberSince;
  final bool hasCompletedSurvey; // Nuevo campo

  User({
    this.id,
    required this.email,
    required this.password,
    this.name,
    this.avatarPath,
    this.memberSince,
    this.hasCompletedSurvey = false, // Valor por defecto
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'avatarPath': avatarPath,
      'memberSince': memberSince?.toIso8601String(),
      'hasCompletedSurvey': hasCompletedSurvey ? 1 : 0, // Guardar como entero
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      email: map['email'] as String,
      password: map['password'] as String,
      name: map['name'] as String?,
      avatarPath: map['avatarPath'] as String?,
      memberSince:
          map['memberSince'] != null
              ? DateTime.parse(map['memberSince'] as String)
              : null,
      hasCompletedSurvey:
          (map['hasCompletedSurvey'] as int?) == 1, // Convertir a bool
    );
  }

  User copyWith({
    int? id,
    String? email,
    String? password,
    String? name,
    String? avatarPath,
    DateTime? memberSince,
    bool? hasCompletedSurvey,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      memberSince: memberSince ?? this.memberSince,
      hasCompletedSurvey: hasCompletedSurvey ?? this.hasCompletedSurvey,
    );
  }
}
