import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device_provider.dart';
import '../widgets/device_card.dart';
import 'device_detail_screen.dart';

class DeviceDashboardScreen extends StatefulWidget {
  const DeviceDashboardScreen({super.key});

  @override
  State<DeviceDashboardScreen> createState() => _DeviceDashboardScreenState();
}

class _DeviceDashboardScreenState extends State<DeviceDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DeviceProvider>().fetchDevices());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'IoT Device Dashboard',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => context.read<DeviceProvider>().fetchDevices(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: provider.fetchDevices,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(14),
              children: [
                _TopSummary(
                  total: provider.devices.length,
                  online: provider.devices.where((d) => d.status == 'online').length,
                  usingCache: provider.usingCache,
                ),
                const SizedBox(height: 12),
                if (provider.errorMessage != null)
                  _InfoBanner(
                    text: provider.errorMessage!,
                    isCache: provider.usingCache,
                  ),
                if (provider.devices.isEmpty)
                  const _EmptyState()
                else
                  ...provider.devices.map(
                    (device) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DeviceCard(
                        device: device,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeviceDetailScreen(device: device),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopSummary extends StatelessWidget {
  final int total;
  final int online;
  final bool usingCache;

  const _TopSummary({
    required this.total,
    required this.online,
    required this.usingCache,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'Total Device',
              value: total.toString(),
              icon: Icons.devices_other_rounded,
            ),
          ),
          Expanded(
            child: _SummaryItem(
              label: 'Online',
              value: online.toString(),
              icon: Icons.wifi_tethering_rounded,
            ),
          ),
          Expanded(
            child: _SummaryItem(
              label: 'Sumber',
              value: usingCache ? 'CACHE' : 'API',
              icon: usingCache ? Icons.sd_storage_rounded : Icons.cloud_done_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.teal.shade700),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String text;
  final bool isCache;

  const _InfoBanner({required this.text, required this.isCache});

  @override
  Widget build(BuildContext context) {
    final color = isCache ? Colors.orange : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCache ? Icons.sd_storage_rounded : Icons.error_outline_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: const [
          Icon(Icons.inbox_rounded, size: 56, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'Belum ada data device',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            'Tarik ke bawah untuk refresh data API',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
