import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Local storage yönetimi için servis
/// SharedPreferences kullanarak key-value çiftlerini saklar
class LocalStorageService {
  // Singleton instance
  static final LocalStorageService instance = LocalStorageService._init();
  static SharedPreferences? _preferences;

  LocalStorageService._init();

  /// SharedPreferences instance'ını başlat
  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  /// String değer kaydet
  Future<bool> setString(String key, String value) async {
    await init();
    return await _preferences!.setString(key, value);
  }

  /// String değer oku
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  /// Int değer kaydet
  Future<bool> setInt(String key, int value) async {
    await init();
    return await _preferences!.setInt(key, value);
  }

  /// Int değer oku
  int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  /// Bool değer kaydet
  Future<bool> setBool(String key, bool value) async {
    await init();
    return await _preferences!.setBool(key, value);
  }

  /// Bool değer oku
  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  /// Map/Object kaydet (JSON olarak)
  Future<bool> setObject(String key, Map<String, dynamic> object) async {
    await init();
    final jsonString = jsonEncode(object);
    return await _preferences!.setString(key, jsonString);
  }

  /// Map/Object oku (JSON'dan)
  Map<String, dynamic>? getObject(String key) {
    final jsonString = _preferences?.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Belirli bir key'i sil
  Future<bool> remove(String key) async {
    await init();
    return await _preferences!.remove(key);
  }

  /// Tüm verileri temizle
  Future<bool> clear() async {
    await init();
    return await _preferences!.clear();
  }

  /// Key'in var olup olmadığını kontrol et
  bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }

  // Yaygın kullanılan key'ler için sabitler
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyThemeMode = 'theme_mode';
}
