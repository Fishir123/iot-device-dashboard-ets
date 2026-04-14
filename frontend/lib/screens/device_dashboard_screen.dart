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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DeviceProvider>().fetchDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 390 ? 12.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'IoT Control Center',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        toolbarHeight: 68,
        actions: [
          IconButton.filledTonal(
            tooltip: 'Refresh',
            onPressed: () => context.read<DeviceProvider>().fetchDevices(),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 6),
          IconButton(
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings_rounded),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.devices.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Memuat data device...'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.fetchDevices,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Stack(
                  children: [
                    const _DashboardBackdrop(),
                    ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        12,
                        horizontalPadding,
                        24,
                      ),
                      children: [
                        _TopSummary(
                          total: provider.devices.length,
                          online: provider.devices
                              .where((d) => d.status == 'online')
                              .length,
                          usingCache: provider.usingCache,
                        ),
                        const SizedBox(height: 10),
                        _DataSourceBadge(source: provider.lastRefreshSource),
                        const SizedBox(height: 14),
                        if (provider.errorMessage != null)
                          _InfoBanner(
                            text: provider.errorMessage!,
                            isCache: provider.usingCache,
                          ),
                        if (provider.devices.isEmpty)
                          const _EmptyState()
                        else ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Daftar Device',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          ...provider.devices.asMap().entries.map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _AnimatedItem(
                                    index: entry.key,
                                    child: DeviceCard(
                                      device: entry.value,
                                      onTap: () {
                                        context
                                            .read<DeviceProvider>()
                                            .selectDevice(entry.value.id);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DeviceDetailScreen(
                                              device: entry.value,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
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
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final offline = (total - online).clamp(0, total);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark
                ? cs.primary.withValues(alpha: 0.3)
                : cs.primary.withValues(alpha: 0.16),
            isDark
                ? cs.tertiary.withValues(alpha: 0.24)
                : cs.tertiary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? cs.outline.withValues(alpha: 0.45)
              : cs.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Realtime Device Monitoring',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.86),
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SummaryItem(
                label: 'Total Device',
                value: total.toString(),
                icon: Icons.devices_other_rounded,
              ),
              _SummaryItem(
                label: 'Online',
                value: online.toString(),
                icon: Icons.wifi_tethering_rounded,
              ),
              _SummaryItem(
                label: 'Offline',
                value: offline.toString(),
                icon: Icons.wifi_off_rounded,
              ),
              _SummaryItem(
                label: 'Sumber',
                value: usingCache ? 'Cached Data' : 'Online Data',
                icon: usingCache
                    ? Icons.sd_storage_rounded
                    : Icons.cloud_done_rounded,
              ),
            ],
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
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxItemWidth = (width - 64) / 2;
    final itemWidth = maxItemWidth.clamp(132.0, 180.0);

    return Container(
      width: itemWidth,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHigh.withValues(alpha: 0.78)
            : Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? cs.outline.withValues(alpha: 0.36)
              : cs.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: cs.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 15),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.14),
            color.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.24)),
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

class _DataSourceBadge extends StatelessWidget {
  final String source;

  const _DataSourceBadge({required this.source});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCache = source == 'Cached Data';

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: (isCache ? Colors.orange : cs.primary)
              .withValues(alpha: isDark ? 0.22 : 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color:
                (isCache ? Colors.orange : cs.primary).withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCache ? Icons.sd_storage_rounded : Icons.cloud_done_rounded,
              size: 16,
              color: isCache ? Colors.orange.shade800 : cs.primary,
            ),
            const SizedBox(width: 6),
            Text(
              source,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isCache ? Colors.orange.shade900 : cs.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark ? cs.surfaceContainerHigh : Colors.white,
              isDark
                  ? cs.primary.withValues(alpha: 0.2)
                  : cs.primary.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? cs.outline.withValues(alpha: 0.35)
                : cs.primary.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.sensors_off_rounded,
              size: 52,
              color: cs.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 10),
            const Text(
              'Belum ada data device',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Tarik ke bawah untuk mengambil data terbaru dari API',
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.72)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 45).clamp(0, 250)),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }
}

class _DashboardBackdrop extends StatelessWidget {
  const _DashboardBackdrop();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: -70,
            top: 120,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.tertiary.withValues(alpha: 0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
