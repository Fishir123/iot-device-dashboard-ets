import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/device_model.dart';

class DeviceApiService {
  static const String _apiBaseUrlFromEnv =
      String.fromEnvironment('API_BASE_URL');

  String get baseUrl {
    if (_apiBaseUrlFromEnv.isNotEmpty) {
      return _apiBaseUrlFromEnv;
    }

    if (kIsWeb) {
      return 'http://localhost:3000/api/devices';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api/devices';
    }

    return 'http://localhost:3000/api/devices';
  }

  Future<List<DeviceModel>> fetchDevices() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => DeviceModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Gagal mengambil data device (${response.statusCode})');
  }
}
