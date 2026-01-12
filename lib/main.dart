import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BodyCloneApp());
}

class BodyCloneApp extends StatelessWidget {
  const BodyCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BodyClone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      ),
      home: const SplashScreen(),
    );
  }
}

