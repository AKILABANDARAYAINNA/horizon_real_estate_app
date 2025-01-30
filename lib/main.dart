import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizon Real Estates',
      theme: ThemeData(
        fontFamily: 'Roboto', // Set Roboto-Black as the default font
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.w900), // Black weight
          bodyMedium: TextStyle(fontWeight: FontWeight.w900),
          bodySmall: TextStyle(fontWeight: FontWeight.w900),
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Roboto', // Set Roboto-Black for dark mode
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.w900),
          bodyMedium: TextStyle(fontWeight: FontWeight.w900),
          bodySmall: TextStyle(fontWeight: FontWeight.w900),
        ),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, // Automatically switches based on system settings
      home: const HomeScreen(), // App starts on HomeScreen
    );
  }
}
