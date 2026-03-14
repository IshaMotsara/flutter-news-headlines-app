import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_headlines_flutter/View/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Headlines',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.zero,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
