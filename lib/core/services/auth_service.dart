import '../models/user_model.dart';
import 'http_service.dart';
import 'local_storage_service.dart';
import 'database_helper.dart';

/// Authentication servisi
/// Kullanıcı giriş, çıkış ve oturum yönetimi için kullanılır
class AuthService {
  // Singleton instance
  static final AuthService instance = AuthService._init();

  final HttpService _httpService = HttpService.instance;
  final LocalStorageService _localStorage = LocalStorageService.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  AuthService._init();

  /// Kullanıcı kayıt ol (Register)
  /// TODO: Kişi 1 - Bu servisi login ekranında kullanın
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // API'ye kayıt isteği gönder
      final response = await _httpService.post(
        '/auth/register',
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      // Response'dan kullanıcı bilgilerini al
      final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final token = response['token'] as String;

      // Local database'e kullanıcıyı kaydet
      await _dbHelper.createUser({
        'username': username,
        'email': email,
        'password': password, // Normalde hash'lenmeli!
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Token ve kullanıcı bilgilerini local storage'a kaydet
      await _saveUserSession(user.copyWith(token: token), token);

      return user;
    } catch (e) {
      throw Exception('Kayıt başarısız: $e');
    }
  }

  /// Kullanıcı giriş yap (Login)
  /// TODO: Kişi 1 - Bu servisi login ekranında kullanın
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Önce local database'de kontrol et
      final localUser = await _dbHelper.getUserByEmail(email);
      
      if (localUser != null && localUser['password'] == password) {
        // Local giriş başarılı
        final user = UserModel(
          id: localUser['id'] as int,
          username: localUser['username'] as String,
          email: localUser['email'] as String,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            localUser['createdAt'] as int,
          ),
        );

        // Fake token oluştur (gerçek API'de backend'den gelecek)
        const fakeToken = 'local_token_123456';
        await _saveUserSession(user.copyWith(token: fakeToken), fakeToken);
        
        return user;
      }

      // Local'de yoksa API'ye istek gönder
      final response = await _httpService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      // Response'dan kullanıcı bilgilerini al
      final user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      final token = response['token'] as String;

      // Oturum bilgilerini kaydet
      await _saveUserSession(user.copyWith(token: token), token);

      return user;
    } catch (e) {
      throw Exception('Giriş başarısız: $e');
    }
  }

  /// Kullanıcı çıkış yap (Logout)
  /// TODO: Kişi 1 - Bu servisi çıkış butonunda kullanın
  Future<void> logout() async {
    try {
      // Token'ı al
      final token = _localStorage.getString(LocalStorageService.keyAuthToken);

      // API'ye logout isteği gönder (opsiyonel)
      if (token != null) {
        try {
          await _httpService.post(
            '/auth/logout',
            body: {},
            token: token,
          );
        } catch (e) {
          // API çağrısı başarısız olsa bile local'den temizle
        }

      }

      // Local storage'dan oturum bilgilerini temizle
      await _clearUserSession();
    } catch (e) {
      throw Exception('Çıkış başarısız: $e');
    }
  }

  /// Kullanıcının oturum açık mı kontrol et
  /// TODO: Kişi 1 - Uygulama başlangıcında bu kontrolü yapın
  Future<bool> isLoggedIn() async {
    await _localStorage.init();
    return _localStorage.getBool(LocalStorageService.keyIsLoggedIn) ?? false;
  }

  /// Mevcut kullanıcı bilgilerini al
  /// TODO: Kişi 1 - Profil ekranında kullanın
  Future<UserModel?> getCurrentUser() async {
    await _localStorage.init();
    final userMap = _localStorage.getObject(LocalStorageService.keyUserData);
    if (userMap == null) return null;
    return UserModel.fromMap(userMap);
  }

  /// Auth token'ı al
  String? getAuthToken() {
    return _localStorage.getString(LocalStorageService.keyAuthToken);
  }

  /// Kullanıcı oturum bilgilerini kaydet (private)
  Future<void> _saveUserSession(UserModel user, String token) async {
    await _localStorage.setString(LocalStorageService.keyAuthToken, token);
    await _localStorage.setInt(LocalStorageService.keyUserId, user.id ?? 0);
    await _localStorage.setObject(LocalStorageService.keyUserData, user.toMap());
    await _localStorage.setBool(LocalStorageService.keyIsLoggedIn, true);
  }

  /// Kullanıcı oturum bilgilerini temizle (private)
  Future<void> _clearUserSession() async {
    await _localStorage.remove(LocalStorageService.keyAuthToken);
    await _localStorage.remove(LocalStorageService.keyUserId);
    await _localStorage.remove(LocalStorageService.keyUserData);
    await _localStorage.setBool(LocalStorageService.keyIsLoggedIn, false);
  }

  /// Şifre doğrulama (basit kontrol)
  /// TODO: Kişi 1 - Register ekranında kullanın
  bool validatePassword(String password) {
    // En az 6 karakter olmalı
    if (password.length < 6) return false;
    // İsteğe bağlı: Büyük harf, küçük harf, rakam kontrolü eklenebilir
    return true;
  }

  /// Email doğrulama (basit kontrol)
  /// TODO: Kişi 1 - Register ve Login ekranlarında kullanın
  bool validateEmail(String email) {
    // Basit email regex kontrolü
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
