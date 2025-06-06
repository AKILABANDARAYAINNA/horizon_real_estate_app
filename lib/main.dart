import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart'; // 👈 Make sure this file exists

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Horizon Real Estates',
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.w900),
          bodyMedium: TextStyle(fontWeight: FontWeight.w900),
          bodySmall: TextStyle(fontWeight: FontWeight.w900),
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.w900),
          bodyMedium: TextStyle(fontWeight: FontWeight.w900),
          bodySmall: TextStyle(fontWeight: FontWeight.w900),
        ),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),

      /// Define app-wide routes
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
