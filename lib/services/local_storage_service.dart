// Local Storage Service - Services ekibi bu dosyayı geliştirecek
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static SharedPreferences? _prefs;

  // Services ekibi bu metodları implement edecek

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('LocalStorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Auth related storage
  static Future<void> saveAuthToken(String token) async {
    await prefs.setString('auth_token', token);
  }

  static String? getAuthToken() {
    return prefs.getString('auth_token');
  }

  static Future<void> removeAuthToken() async {
    await prefs.remove('auth_token');
  }

  static Future<void> saveUserEmail(String email) async {
    await prefs.setString('user_email', email);
  }

  static String? getUserEmail() {
    return prefs.getString('user_email');
  }

  // User preferences
  static Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    await prefs.setString('user_preferences', jsonEncode(preferences));
  }

  static Map<String, dynamic>? getUserPreferences() {
    final prefsString = prefs.getString('user_preferences');
    if (prefsString != null) {
      return jsonDecode(prefsString);
    }
    return null;
  }

  // Theme settings
  static Future<void> saveThemeMode(String themeMode) async {
    await prefs.setString('theme_mode', themeMode);
  }

  static String getThemeMode() {
    return prefs.getString('theme_mode') ?? 'system';
  }

  // App settings
  static Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    await prefs.setString('app_settings', jsonEncode(settings));
  }

  static Map<String, dynamic> getAppSettings() {
    final settingsString = prefs.getString('app_settings');
    if (settingsString != null) {
      return jsonDecode(settingsString);
    }
    return {
      'notifications_enabled': true,
      'auto_save': true,
      'sync_enabled': true,
      'backup_frequency': 'daily',
    };
  }

  // Search history
  static Future<void> addSearchHistory(String query) async {
    final history = getSearchHistory();
    if (!history.contains(query)) {
      history.insert(0, query);
      // En fazla 10 arama geçmişi tut
      if (history.length > 10) {
        history.removeLast();
      }
      await prefs.setStringList('search_history', history);
    }
  }

  static List<String> getSearchHistory() {
    return prefs.getStringList('search_history') ?? [];
  }

  static Future<void> clearSearchHistory() async {
    await prefs.remove('search_history');
  }

  // Recent categories
  static Future<void> addRecentCategory(int categoryId) async {
    final recent = getRecentCategories();
    recent.removeWhere((id) => id == categoryId);
    recent.insert(0, categoryId);

    // En fazla 5 son kategori tut
    if (recent.length > 5) {
      recent.removeLast();
    }

    await prefs.setStringList('recent_categories',
        recent.map((id) => id.toString()).toList());
  }

  static List<int> getRecentCategories() {
    final recent = prefs.getStringList('recent_categories') ?? [];
    return recent.map((id) => int.parse(id)).toList();
  }

  // First launch check
  static bool isFirstLaunch() {
    return prefs.getBool('first_launch') ?? true;
  }

  static Future<void> setFirstLaunchComplete() async {
    await prefs.setBool('first_launch', false);
  }

  // Backup settings
  static Future<void> saveLastBackupDate(DateTime date) async {
    await prefs.setInt('last_backup_date', date.millisecondsSinceEpoch);
  }

  static DateTime? getLastBackupDate() {
    final timestamp = prefs.getInt('last_backup_date');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  // Statistics cache
  static Future<void> saveStatsCache(Map<String, int> stats) async {
    await prefs.setString('stats_cache', jsonEncode(stats));
    await prefs.setInt('stats_cache_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  static Map<String, int>? getStatsCache() {
    final cacheTimestamp = prefs.getInt('stats_cache_timestamp');
    if (cacheTimestamp != null) {
      final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTimestamp);
      final now = DateTime.now();

      // Cache 1 saatten eskiyse null döndür
      if (now.difference(cacheDate).inHours < 1) {
        final cacheString = prefs.getString('stats_cache');
        if (cacheString != null) {
          final decoded = jsonDecode(cacheString);
          return Map<String, int>.from(decoded);
        }
      }
    }
    return null;
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await prefs.clear();
  }

  // Export settings for backup
  static Map<String, dynamic> exportSettings() {
    final keys = prefs.getKeys();
    final settings = <String, dynamic>{};

    for (final key in keys) {
      if (!key.startsWith('auth_') && !key.startsWith('user_email')) {
        final value = prefs.get(key);
        settings[key] = value;
      }
    }

    return settings;
  }

  // Import settings from backup
  static Future<void> importSettings(Map<String, dynamic> settings) async {
    for (final entry in settings.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(key, value);
      }
    }
  }
}
