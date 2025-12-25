import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/user_model.dart';
import 'http_service.dart';
import 'local_storage_service.dart';
import 'database_helper.dart';

class AuthService {
  static final AuthService instance = AuthService._init();

  final HttpService _httpService = HttpService.instance;
  final LocalStorageService _localStorage = LocalStorageService.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  AuthService._init();

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch,
        username: username,
        email: email,
        createdAt: DateTime.now(),
      );
      final token = 'mock_token_${newUser.id}';

      if (kIsWeb) {
        final users = await _localStorage.getObjectList('web_users');
        
        final exists = users.any((u) => u['email'] == email);
        if (exists) throw Exception('Bu e-posta adresi zaten kayıtlı.');

        final userMap = newUser.toMap();
        userMap['password'] = password;
        
        users.add(userMap);
        await _localStorage.setObjectList('web_users', users);

        await _saveUserSession(newUser.copyWith(token: token), token);
        return newUser;
      }

      await _dbHelper.createUser({
        'username': username,
        'email': email,
        'password': password,
        'createdAt': DateTime.now().toIso8601String(),
      });

      await _saveUserSession(newUser.copyWith(token: token), token);

      return newUser;
    } catch (e) {
      throw Exception('Kayıt başarısız: $e');
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      if (kIsWeb) {
        await Future.delayed(const Duration(milliseconds: 500));
        
        final users = await _localStorage.getObjectList('web_users');
        final userMap = users.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
          orElse: () => {},
        );

        if (userMap.isEmpty) {
           throw Exception('Kullanıcı bulunamadı veya şifre hatalı.');
        }

        final user = UserModel.fromMap(userMap);
        final token = 'web_token_${user.id}';
        
        await _saveUserSession(user.copyWith(token: token), token);
        return user;
      }

      final localUser = await _dbHelper.getUserByEmail(email);
      
      if (localUser != null && localUser['password'] == password) {
        final user = UserModel(
          id: localUser['id'] as int,
          username: localUser['username'] as String,
          email: localUser['email'] as String,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            localUser['createdAt'] as int,
          ),
        );

        const fakeToken = 'local_token_123456';
        await _saveUserSession(user.copyWith(token: fakeToken), fakeToken);
        return user;
      }
      
      throw Exception('Kullanıcı bulunamadı veya şifre hatalı. Lütfen önce kayıt olun.');
    } catch (e) {
      throw Exception('Giriş başarısız: $e');
    }
  }

  Future<void> logout() async {
    try {
      final token = _localStorage.getString(LocalStorageService.keyAuthToken);

      if (token != null) {
        try {
          await _httpService.post(
            '/auth/logout',
            body: {},
            token: token,
          );
        } catch (e) {
        }
      }

      await _clearUserSession();
    } catch (e) {
      throw Exception('Çıkış başarısız: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    await _localStorage.init();
    return _localStorage.getBool(LocalStorageService.keyIsLoggedIn) ?? false;
  }

  Future<UserModel?> getCurrentUser() async {
    await _localStorage.init();
    final userMap = _localStorage.getObject(LocalStorageService.keyUserData);
    if (userMap == null) return null;
    return UserModel.fromMap(userMap);
  }

  String? getAuthToken() {
    return _localStorage.getString(LocalStorageService.keyAuthToken);
  }

  Future<void> _saveUserSession(UserModel user, String token) async {
    await _localStorage.setString(LocalStorageService.keyAuthToken, token);
    await _localStorage.setInt(LocalStorageService.keyUserId, user.id ?? 0);
    await _localStorage.setObject(LocalStorageService.keyUserData, user.toMap());
    await _localStorage.setBool(LocalStorageService.keyIsLoggedIn, true);
  }

  Future<void> _clearUserSession() async {
    await _localStorage.remove(LocalStorageService.keyAuthToken);
    await _localStorage.remove(LocalStorageService.keyUserId);
    await _localStorage.remove(LocalStorageService.keyUserData);
    await _localStorage.setBool(LocalStorageService.keyIsLoggedIn, false);
  }

  bool validatePassword(String password) {
    if (password.length < 6) return false;
    return true;
  }

  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
