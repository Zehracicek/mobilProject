// Auth Provider - Auth ekibi bu dosyayı geliştirecek
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  // Auth ekibi bu metodları implement edecek
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: API çağrısı yapılacak
      // TODO: Kullanıcı bilgileri alınacak
      // TODO: SharedPreferences'a token kaydedilecek

      // Şimdilik demo veri
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = User(
        id: 1,
        name: 'Demo User',
        email: email,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      _isLoggedIn = true;

      // Token'ı kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'demo_token_123');
      await prefs.setString('user_email', email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: API çağrısı yapılacak
      // TODO: Kullanıcı oluşturulacak

      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    // TODO: API'ye logout isteği gönderilecek

    _currentUser = null;
    _isLoggedIn = false;

    // Token'ı temizle
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_email');

    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    // TODO: Token kontrolü yapılacak
    // TODO: Token geçerliyse kullanıcı bilgileri alınacak

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      // Token varsa kullanıcı giriş yapmış sayılır
      final email = prefs.getString('user_email') ?? '';
      _currentUser = User(
        id: 1,
        name: 'Demo User',
        email: email,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Şifre sıfırlama API çağrısı
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
