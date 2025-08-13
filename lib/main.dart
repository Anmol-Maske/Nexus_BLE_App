import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'views/home/home_view.dart';

void main() {
  runApp(const MyApp());
}

/// App entry. Minimal: sets theme and root view.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pennsy BLE App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeView(),
    );
  }
}
