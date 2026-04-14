import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/app_settings_provider.dart';
import 'providers/device_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/device_dashboard_screen.dart';
import 'screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('device_cache');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0E7C86),
      brightness: Brightness.light,
      surface: const Color(0xFFF7FAFB),
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );

    final lightTheme = base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF4F8FA),
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFF13242A),
        displayColor: const Color(0xFF13242A),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.primary,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF52D1D9),
        onPrimary: Color(0xFF002022),
        secondary: Color(0xFF8ACCD1),
        onSecondary: Color(0xFF002022),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        surface: Color(0xFF10181C),
        onSurface: Color(0xFFE6F0F2),
        surfaceContainerHighest: Color(0xFF1B262B),
        onSurfaceVariant: Color(0xFFB9C9CD),
        outline: Color(0xFF395059),
      ),
      scaffoldBackgroundColor: const Color(0xFF0D1519),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A262B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF35505A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF52D1D9), width: 1.4),
        ),
      ),
      textTheme: ThemeData(brightness: Brightness.dark).textTheme.apply(
          bodyColor: const Color(0xFFE6F0F2),
          displayColor: const Color(0xFFE6F0F2)),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppSettingsProvider()..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeviceProvider()..initPreferences(),
        ),
      ],
      child: Consumer<AppSettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'IoT Device Dashboard',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settings.themeMode,
            routes: {
              '/dashboard': (_) => const DeviceDashboardScreen(),
              '/settings': (_) => const SettingsScreen(),
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
