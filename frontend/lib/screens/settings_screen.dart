import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings_provider.dart';
import '../providers/device_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    final username = context.read<AppSettingsProvider>().username;
    _usernameController = TextEditingController(text: username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panelColor = isDark
        ? cs.surface.withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.84);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: panelColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.primary.withValues(alpha: 0.14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username',
                    style:
                        TextStyle(color: cs.onSurface.withValues(alpha: 0.8))),
                const SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Masukkan username',
                    hintStyle:
                        TextStyle(color: cs.onSurface.withValues(alpha: 0.62)),
                    filled: true,
                    fillColor: isDark
                        ? cs.surfaceContainerHighest.withValues(alpha: 0.55)
                        : cs.surface,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (value) =>
                      context.read<AppSettingsProvider>().updateUsername(value),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonal(
                    onPressed: () {
                      context
                          .read<AppSettingsProvider>()
                          .updateUsername(_usernameController.text);
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text('Simpan Username'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Consumer<AppSettingsProvider>(
            builder: (context, settings, _) {
              final isDark = settings.themeMode == ThemeMode.dark;
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.14)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('Theme Mode',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                            value: false,
                            label: Text('Light'),
                            icon: Icon(Icons.light_mode_rounded)),
                        ButtonSegment(
                            value: true,
                            label: Text('Dark'),
                            icon: Icon(Icons.dark_mode_rounded)),
                      ],
                      selected: {isDark},
                      onSelectionChanged: (selection) {
                        final darkSelected = selection.first;
                        context.read<AppSettingsProvider>().setThemeMode(
                            darkSelected ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Consumer<DeviceProvider>(
            builder: (context, provider, _) {
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.14)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Stored Info',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _InfoLine(
                        label: 'Last refresh source',
                        value: provider.lastRefreshSource),
                    _InfoLine(
                        label: 'Selected device',
                        value: provider.selectedDeviceId ?? '-'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
