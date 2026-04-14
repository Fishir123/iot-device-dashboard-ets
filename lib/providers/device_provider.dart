import 'package:flutter/material.dart';

import '../models/device_model.dart';
import '../services/device_api_service.dart';
import '../services/device_cache_service.dart';

class DeviceProvider extends ChangeNotifier {
  final DeviceApiService _apiService = DeviceApiService();
  final DeviceCacheService _cacheService = DeviceCacheService();

  List<DeviceModel> _devices = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _usingCache = false;

  List<DeviceModel> get devices => _devices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get usingCache => _usingCache;

  Future<void> fetchDevices() async {
    _isLoading = true;
    _errorMessage = null;
    _usingCache = false;
    notifyListeners();

    try {
      final apiData = await _apiService.fetchDevices();
      _devices = apiData;
      await _cacheService.saveDevices(apiData);
    } catch (e) {
      _devices = _cacheService.getDevices();
      _usingCache = _devices.isNotEmpty;
      _errorMessage = _usingCache
          ? 'Koneksi gagal, menampilkan data cache.'
          : 'Gagal memuat data dan cache kosong.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
