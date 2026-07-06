import 'package:flutter/material.dart';

/// Thème Guidik — Material 3, prêt pour RTL Arabe/Darija.
///
/// Note : la police par défaut de Material gère les caractères arabes,
/// mais tu pourras brancher une police Noto Sans Arabic / Cairo plus tard
/// sans toucher au reste de l'app (variable `fontFamily` ci-dessous).
class GuidikTheme {
  GuidikTheme._();

  static const Color _seed = Color(0xFF1E88E5);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.light,
      ),
      // null => police Material par défaut (gère l'arabe).
      // Pour plus tard : fontFamily: 'Cairo',
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
