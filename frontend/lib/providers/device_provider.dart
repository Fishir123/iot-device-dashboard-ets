import 'package:flutter/material.dart';

import '../models/device_model.dart';
import '../services/app_preferences_service.dart';
import '../services/device_api_service.dart';
import '../services/device_cache_service.dart';

class DeviceProvider extends ChangeNotifier {
  final DeviceApiService _apiService = DeviceApiService();
  final DeviceCacheService _cacheService = DeviceCacheService();
  final AppPreferencesService _preferencesService = AppPreferencesService();

  List<DeviceModel> _devices = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _usingCache = false;
  String _lastRefreshSource = 'Online Data';
  String? _selectedDeviceId;

  List<DeviceModel> get devices => _devices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get usingCache => _usingCache;
  String get lastRefreshSource => _lastRefreshSource;
  String? get selectedDeviceId => _selectedDeviceId;

  Future<void> initPreferences() async {
    _selectedDeviceId = await _preferencesService.getSelectedDeviceId();
    _lastRefreshSource = await _preferencesService.getLastRefreshSource();
    notifyListeners();
  }

  Future<void> selectDevice(String deviceId) async {
    _selectedDeviceId = deviceId;
    await _preferencesService.saveSelectedDeviceId(deviceId);
    notifyListeners();
  }

  Future<void> fetchDevices() async {
    _isLoading = true;
    _errorMessage = null;
    _usingCache = false;
    notifyListeners();

    try {
      final apiData = await _apiService.fetchDevices();
      _devices = apiData;
      _usingCache = false;
      _lastRefreshSource = 'Online Data';
      await _cacheService.saveDevices(apiData);
      await _preferencesService.saveLastRefreshSource(_lastRefreshSource);
    } catch (e) {
      _devices = _cacheService.getDevices();
      _usingCache = _devices.isNotEmpty;
      _lastRefreshSource = _usingCache ? 'Cached Data' : 'Online Data';
      _errorMessage = _usingCache
          ? 'Koneksi gagal, menampilkan data cache.'
          : 'Gagal memuat data dan cache kosong.';
      await _preferencesService.saveLastRefreshSource(_lastRefreshSource);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
