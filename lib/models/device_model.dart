class DeviceModel {
  final String id;
  final String deviceName;
  final String status;
  final DateTime? lastSeen;
  final int battery;
  final int signal;

  DeviceModel({
    required this.id,
    required this.deviceName,
    required this.status,
    required this.lastSeen,
    required this.battery,
    required this.signal,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id']?.toString() ?? '',
      deviceName: json['device_name']?.toString() ?? 'Unknown Device',
      status: json['status']?.toString().toLowerCase() ?? 'offline',
      lastSeen: json['last_seen'] != null
          ? DateTime.tryParse(json['last_seen'].toString())
          : null,
      battery: int.tryParse(json['battery']?.toString() ?? '') ?? 0,
      signal: int.tryParse(json['signal']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_name': deviceName,
      'status': status,
      'last_seen': lastSeen?.toIso8601String(),
      'battery': battery,
      'signal': signal,
    };
  }
}
