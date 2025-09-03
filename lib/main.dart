import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'features/auth/pages/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breach',
      theme: AppTheme.lightTheme,
      home: const LandingPage(),
    );
  }
}
