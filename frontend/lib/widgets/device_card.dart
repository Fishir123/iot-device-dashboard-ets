import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/device_model.dart';

class DeviceCard extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback? onTap;

  const DeviceCard({super.key, required this.device, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOnline = device.status == 'online';
    final lastSeenText = device.lastSeen != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(device.lastSeen!.toLocal())
        : '-';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      device.deviceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(isOnline ? 'ONLINE' : 'OFFLINE'),
                    backgroundColor:
                        isOnline ? Colors.green.shade100 : Colors.red.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Last seen: $lastSeenText'),
              const SizedBox(height: 4),
              Text('Battery: ${device.battery}%'),
              const SizedBox(height: 4),
              Text('Signal: ${device.signal}%'),
            ],
          ),
        ),
      ),
    );
  }
}
