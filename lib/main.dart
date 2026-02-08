import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const NurseApp());
}

class NurseApp extends StatelessWidget {
  const NurseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
