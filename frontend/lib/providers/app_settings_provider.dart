import 'package:flutter/material.dart';

import '../services/app_preferences_service.dart';

class AppSettingsProvider extends ChangeNotifier {
  final AppPreferencesService _preferencesService = AppPreferencesService();

  String _username = 'Operator';
  ThemeMode _themeMode = ThemeMode.light;
  bool _isReady = false;

  String get username => _username;
  ThemeMode get themeMode => _themeMode;
  bool get isReady => _isReady;

  Future<void> init() async {
    _username = await _preferencesService.getUsername();
    final mode = await _preferencesService.getThemeMode();
    _themeMode = mode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _isReady = true;
    notifyListeners();
  }

  Future<void> updateUsername(String value) async {
    final name = value.trim().isEmpty ? 'Operator' : value.trim();
    _username = name;
    await _preferencesService.saveUsername(name);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _preferencesService
        .saveThemeMode(mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}
