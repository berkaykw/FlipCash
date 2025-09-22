import 'package:flutter/material.dart';
import 'package:flip_cash/screens/Splash_Screen.dart';
import 'package:flip_cash/screens/SelectCountryScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip Cash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => SelectCountryScreen(),
      },
    );
  }
}
