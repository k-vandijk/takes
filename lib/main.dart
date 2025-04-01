import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takes/providers/recordings_provider.dart';
import 'package:takes/screens/home_screen.dart';

// Light Color Scheme
final kLightColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF5E8C61), // A rich forest green for a grounded, natural feel
  onPrimary: Color(0xFFFFFFFF), // White for clean contrast
  secondary: Color(0xFFF4A261), // A warm, soft orange for energy and highlights
  onSecondary: Color(0xFF1A1A1A), // Near-black for readability
  error: Color(0xFFD9534F), // A muted red for errors, noticeable but not jarring
  onError: Color(0xFFFFFFFF), // White for legibility
  surface: Color(0xFFF8F1E9), // Off-white with a warm tint for a cozy background
  onSurface: Color(0xFF2D2D2D), // Dark gray for text, softer than pure black
);

// Dark Color Scheme
final kDarkColorScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF8AB89C), // A muted sage green, calming and modern
  onPrimary: Color(0xFF0F1A13), // Very dark green-gray for contrast
  secondary: Color(0xFFE68A5C), // A deeper orange, vibrant yet balanced
  onSecondary: Color(0xFF1F0F07), // Dark brown-black for readability
  error: Color(0xFFE57373), // A softer red, visible in dark mode
  onError: Color(0xFF1A0F0F), // Dark gray for error text contrast
  surface: Color(0xFF1E2521), // Deep charcoal with a hint of green for depth
  onSurface: Color(0xFFECE5D8), // Warm off-white for text, easy on the eyes
);

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RecordsProvider())],
      child: MaterialApp(
        theme: ThemeData(colorScheme: kLightColorScheme),
        darkTheme: ThemeData(colorScheme: kDarkColorScheme),
        home: const Scaffold(body: Center(child: HomeScreen())),
      ),
    ),
  );
}