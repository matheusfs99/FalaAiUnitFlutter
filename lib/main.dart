import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fala ai unit',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF5199C3), // Cor azul de fundo
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5199C3), // AppBar azul
        ),
      ),
      home: LoginScreen(),
    );
  }
}
