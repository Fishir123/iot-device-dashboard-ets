import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesService {
  static const String _usernameKey = 'username';
  static const String _selectedDeviceKey = 'selected_device';
  static const String _themeModeKey = 'theme_mode';
  static const String _lastRefreshSourceKey = 'last_refresh_source';

  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? 'Operator';
  }

  Future<void> saveSelectedDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedDeviceKey, deviceId);
  }

  Future<String?> getSelectedDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedDeviceKey);
  }

  Future<void> saveThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, themeMode);
  }

  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey) ?? 'light';
  }

  Future<void> saveLastRefreshSource(String source) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRefreshSourceKey, source);
  }

  Future<String> getLastRefreshSource() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastRefreshSourceKey) ?? 'Online Data';
  }
}
