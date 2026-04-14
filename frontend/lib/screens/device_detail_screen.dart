import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/device_model.dart';

class DeviceDetailScreen extends StatelessWidget {
  final DeviceModel device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final isOnline = device.status == 'online';
    final lastSeenText = device.lastSeen != null
        ? DateFormat('dd MMM yyyy, HH:mm:ss').format(device.lastSeen!.toLocal())
        : '-';

    final statusColor = isOnline ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Device',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: statusColor.withValues(alpha: 0.12),
                      child: Icon(Icons.memory_rounded, color: statusColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        device.deviceName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isOnline ? 'ONLINE' : 'OFFLINE',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _DetailRow(label: 'ID Device', value: device.id),
                _DetailRow(label: 'Last Seen', value: lastSeenText),
                _DetailRow(label: 'Battery', value: '${device.battery}%'),
                _DetailRow(label: 'Signal', value: '${device.signal}%'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(':  '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
