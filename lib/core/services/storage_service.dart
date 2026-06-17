import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/explore/data/providers/daily_ayah_provider.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Keys
  static const String _userNameKey = 'user_name';
  static const String _themeModeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _notificationsEnabledKey = 'notifications_enabled';

  // Getters
  String get userName => _prefs.getString(_userNameKey) ?? 'أحمد المسلم';
  String get themeMode => _prefs.getString(_themeModeKey) ?? 'light';
  String get language => _prefs.getString(_languageKey) ?? 'ar';
  bool get notificationsEnabled => _prefs.getBool(_notificationsEnabledKey) ?? true;

  // Setters
  Future<void> setUserName(String name) async {
    await _prefs.setString(_userNameKey, name);
  }

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }

  Future<void> setLanguage(String lang) async {
    await _prefs.setString(_languageKey, lang);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsEnabledKey, enabled);
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StorageService(prefs);
});
