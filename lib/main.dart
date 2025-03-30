
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takes/providers/recordings_provider.dart';
import 'package:takes/screens/home_screen.dart';

final Color seedColor = const Color(0xFF6750A4);

final kColorScheme = ColorScheme.fromSeed(seedColor: seedColor);

final kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: seedColor,
);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordsProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(colorScheme: kColorScheme),
        darkTheme: ThemeData(colorScheme: kDarkColorScheme),
        home: const Scaffold(
          body: Center(child: HomeScreen())
        ),
      ),
    ),
  );
}