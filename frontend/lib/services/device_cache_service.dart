import 'package:hive/hive.dart';

import '../models/device_model.dart';

class DeviceCacheService {
  static const String _boxName = 'device_cache';
  static const String _key = 'devices';

  Future<void> saveDevices(List<DeviceModel> devices) async {
    final box = Hive.box(_boxName);
    final data = devices.map((d) => d.toJson()).toList();
    await box.put(_key, data);
  }

  List<DeviceModel> getDevices() {
    final box = Hive.box(_boxName);
    final raw = box.get(_key);

    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => DeviceModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return [];
  }
}
