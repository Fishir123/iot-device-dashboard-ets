import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/device_model.dart';

class DeviceApiService {
  // Untuk Android Emulator: gunakan 10.0.2.2
  // Untuk device fisik/LAN: ganti ke IP server, contoh 192.168.1.20
  static const String baseUrl = 'http://10.0.2.2:3000/api/devices';

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
