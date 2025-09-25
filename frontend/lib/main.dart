import 'package:flutter/material.dart';
import 'package:flip_cash/screens/Splash_Screen.dart';
import 'package:flip_cash/screens/SelectCountryScreen.dart';
import 'package:provider/provider.dart';
import 'utils/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flip Cash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 21, 52),
      ),
      themeMode: themeProvider.themeMode, 
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const SelectCountryScreen(),
      },
    );
  }
}
