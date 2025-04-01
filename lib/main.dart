import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takes/providers/recordings_provider.dart';
import 'package:takes/screens/home_screen.dart';

// Light Color Scheme
final kLightColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFB39DDB), // Muted lavender
  onPrimary: Color(0xFF1A1A1A), // Dark gray
  secondary: Color(0xFFF8BBD0), // Soft peach
  onSecondary: Color(0xFF1A1A1A), // Dark gray
  tertiary: Color(0xFFB2DFDB), // Pale mint
  onTertiary: Color(0xFF1A1A1A), // Dark gray
  error: Color(0xFFE57373), // Dusty rose
  onError: Color(0xFFFFFFFF), // White
  surface: Color(0xFFFAFAFA), // Light cream
  onSurface: Color(0xFF424242), // Soft charcoal
);

// Dark Color Scheme
final kDarkColorScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF9575CD), // Darker lavender
  onPrimary: Color(0xFFFFFFFF), // White
  secondary: Color(0xFFF06292), // Darker peach
  onSecondary: Color(0xFFFFFFFF), // White
  tertiary: Color(0xFF80CBC4), // Darker mint
  onTertiary: Color(0xFF1A1A1A), // Dark gray
  error: Color(0xFFF44336), // Darker dusty rose
  onError: Color(0xFFFFFFFF), // White
  surface: Color(0xFF37474F), // Dark gray-blue
  onSurface: Color(0xFFB0BEC5), // Light gray
);

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RecordsProvider())],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: kLightColorScheme,
          scaffoldBackgroundColor: kLightColorScheme.surface,
          cardTheme: CardTheme(
            color: const Color(0xFFF5F5F5),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          iconTheme: IconThemeData(color: kLightColorScheme.tertiary),
          textTheme: TextTheme(
            titleMedium: TextStyle(
              fontWeight: FontWeight.bold,
              color: kLightColorScheme.primary,
            ),
            bodySmall: TextStyle(
              color: kLightColorScheme.onSurface.withAlpha(200),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: kLightColorScheme.secondary,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kLightColorScheme.tertiary),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kLightColorScheme.secondary),
            ),
            labelStyle: TextStyle(color: kLightColorScheme.tertiary),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: kDarkColorScheme,
          scaffoldBackgroundColor: kDarkColorScheme.surface,
          cardTheme: CardTheme(
            color: const Color(0xFF455A64),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          iconTheme: IconThemeData(color: kDarkColorScheme.tertiary),
          textTheme: TextTheme(
            titleMedium: TextStyle(
              fontWeight: FontWeight.bold,
              color: kDarkColorScheme.primary,
            ),
            bodySmall: TextStyle(
              color: kDarkColorScheme.onSurface.withAlpha(200),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: kDarkColorScheme.secondary,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kDarkColorScheme.tertiary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: kDarkColorScheme.secondary),
            ),
            labelStyle: TextStyle(color: kDarkColorScheme.tertiary),
          ),
        ),
        home: const Scaffold(body: Center(child: HomeScreen())),
      ),
    ),
  );
}
