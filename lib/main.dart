import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/home/home_page.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final lightScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF3366FF));
    final darkScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF3366FF), brightness: Brightness.dark);
    return MaterialApp(
      title: 'Items',
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: lightScheme,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(elevation: 0),
        cardTheme: const CardThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
      ),
      darkTheme: ThemeData(
        colorScheme: darkScheme,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(elevation: 0),
        cardTheme: const CardThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
      ),
      home: const HomePage(),
    );
  }
}
