
import 'package:flutter/material.dart';
import 'package:takes/screens/home_screen.dart';

final Color seedColor = const Color(0xFF6750A4);

final kColorScheme = ColorScheme.fromSeed(seedColor: seedColor);

final kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: seedColor,
);

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(colorScheme: kColorScheme),
      darkTheme: ThemeData(colorScheme: kDarkColorScheme),
      home: Scaffold(
        // backgroundColor: kColorScheme.primary,
        body: const Center(child: HomeScreen())
      ),
    ),
  );
}