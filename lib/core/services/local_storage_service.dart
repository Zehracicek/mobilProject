import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static final LocalStorageService instance = LocalStorageService._init();
  static SharedPreferences? _preferences;

  LocalStorageService._init();

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    await init();
    return await _preferences!.setString(key, value);
  }

  String? getString(String key) {
    return _preferences?.getString(key);
  }

  Future<bool> setInt(String key, int value) async {
    await init();
    return await _preferences!.setInt(key, value);
  }

  int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  Future<bool> setBool(String key, bool value) async {
    await init();
    return await _preferences!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  Future<bool> setObject(String key, Map<String, dynamic> object) async {
    await init();
    final jsonString = jsonEncode(object);
    return await _preferences!.setString(key, jsonString);
  }

  Map<String, dynamic>? getObject(String key) {
    final jsonString = _preferences?.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<bool> setObjectList(String key, List<Map<String, dynamic>> list) async {
    await init();
    final jsonString = jsonEncode(list);
    return await _preferences!.setString(key, jsonString);
  }

  Future<List<Map<String, dynamic>>> getObjectList(String key) async {
    await init();
    final jsonString = _preferences?.getString(key);
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<bool> remove(String key) async {
    await init();
    return await _preferences!.remove(key);
  }

  Future<bool> clear() async {
    await init();
    return await _preferences!.clear();
  }

  bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }

  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyThemeMode = 'theme_mode';
}
