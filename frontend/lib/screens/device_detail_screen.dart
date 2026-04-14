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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Device'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.deviceName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Chip(
                    label: Text(isOnline ? 'ONLINE' : 'OFFLINE'),
                    backgroundColor:
                        isOnline ? Colors.green.shade100 : Colors.red.shade100,
                  ),
                  const SizedBox(height: 12),
                  Text('ID Device: ${device.id}'),
                  const SizedBox(height: 8),
                  Text('Last Seen: $lastSeenText'),
                  const SizedBox(height: 8),
                  Text('Battery: ${device.battery}%'),
                  const SizedBox(height: 8),
                  Text('Signal: ${device.signal}%'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
