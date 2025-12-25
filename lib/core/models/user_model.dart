/// Kullanıcı veri modeli
/// Authentication ve kullanıcı yönetimi için kullanılacak
class UserModel {
  final int? id; // Kullanıcı ID'si
  final String username; // Kullanıcı adı
  final String email; // Email adresi
  final String? password; // Şifre (sadece kayıt/giriş sırasında kullanılır)
  final String? token; // Auth token (giriş sonrası)
  final DateTime? createdAt; // Kayıt tarihi

  UserModel({
    this.id,
    required this.username,
    required this.email,
    this.password,
    this.token,
    this.createdAt,
  });

  /// JSON'dan UserModel oluştur (API response için)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      token: json['token'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  /// UserModel'i JSON'a dönüştür (API request için)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'token': token,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Local storage için basit map dönüşümü
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  /// Map'den UserModel oluştur (local storage için)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      token: map['token'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }

  /// Kullanıcı kopyalama (güncelleme için kullanışlı)
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    String? token,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
