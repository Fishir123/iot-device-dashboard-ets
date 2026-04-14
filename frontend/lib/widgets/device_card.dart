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

    final statusColor = isOnline ? Colors.green : Colors.red;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: statusColor.withValues(alpha: 0.12),
                    child: Icon(
                      Icons.memory_rounded,
                      color: statusColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.deviceName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Last seen: $lastSeenText',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isOnline ? 'ONLINE' : 'OFFLINE',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _MetricBar(
                label: 'Battery',
                value: device.battery,
                color: Colors.teal,
                icon: Icons.battery_charging_full_rounded,
              ),
              const SizedBox(height: 8),
              _MetricBar(
                label: 'Signal',
                value: device.signal,
                color: Colors.blue,
                icon: Icons.wifi_rounded,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Lihat detail',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _MetricBar({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0, 100);

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: safeValue / 100,
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$safeValue%',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
