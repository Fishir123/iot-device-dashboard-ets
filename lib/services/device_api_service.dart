import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/device_model.dart';

class DeviceApiService {
  // TODO: ganti dengan endpoint MockAPI kamu
  static const String baseUrl = 'https://mockapi.io/api/v1/devices';

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
