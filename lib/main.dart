import 'package:flutter/material.dart';
import 'package:my_member_link_lab/views/home/login_screen.dart';



void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Member Link',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue[800]!, 
          brightness: Brightness.light,
        ).copyWith(
          primary: Colors.blue[800],
          onPrimary: Colors.white,
          primaryContainer: Colors.blue[600],
          secondary: Colors.blue[600],
          onSecondary: Colors.white,
          background: Colors.white,
          onBackground: Colors.black87,
          surface: Colors.blue[50]!,
              onSurface: Colors.black87,
              error: Colors.redAccent,
              onError: Colors.white,
        ),
      ),
      
      home: const LoginScreen(),
    );
  }
}