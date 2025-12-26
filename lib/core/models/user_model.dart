class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;
  final String? token;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
    this.token,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      token: map['token'],
    );
  }

  Map<String, dynamic> toMap() {
    final m = {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
    if (token != null) m['token'] = token;
    return m;
  }

  // Compatibility aliases
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel.fromMap(json);
  Map<String, dynamic> toJson() => toMap();

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    DateTime? createdAt,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
    );
  }
}
