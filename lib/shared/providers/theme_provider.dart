import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/haptic_service.dart';

/// Provider pour la gestion des thèmes avec persistance
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  bool _isDarkMode = false;
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Initialise le provider et charge les préférences
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isDarkMode = _prefs?.getBool(_themeKey) ?? false;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // En cas d'erreur, utiliser les valeurs par défaut
      _isDarkMode = false;
      _isInitialized = true;
      notifyListeners();
      debugPrint('Erreur lors de l\'initialisation des préférences de thème: $e');
    }
  }

  /// Bascule entre les thèmes clair et sombre
  Future<void> toggleTheme() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    _isDarkMode = !_isDarkMode;
    await _saveThemePreference();
    await HapticService.themeChange();
    notifyListeners();
  }

  /// Définit le thème explicitement
  Future<void> setTheme(bool isDark) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      await _saveThemePreference();
      await HapticService.themeChange();
      notifyListeners();
    }
  }

  /// Sauvegarde la préférence de thème
  Future<void> _saveThemePreference() async {
    try {
      final prefs = _prefs;
      if (prefs != null) {
        await prefs.setBool(_themeKey, _isDarkMode);
      }
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde des préférences de thème: $e');
    }
  }

  /// Thème clair personnalisé
  static ThemeData get lightTheme {
    const primaryColor = Color(0xFF32F094);
    const surfaceColor = Color(0xFFE8E6E6);
    const onSurfaceColor = Color(0xFF191E21);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: onSurfaceColor,
        secondary: primaryColor.withOpacity(0.8),
        onSecondary: onSurfaceColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        background: surfaceColor,
        onBackground: onSurfaceColor,
        outline: onSurfaceColor.withOpacity(0.2),
        shadow: onSurfaceColor.withOpacity(0.1),
      ),
      
      // Typographie
      textTheme: _buildTextTheme(onSurfaceColor),
      
      // Composants
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: onSurfaceColor,
        elevation: 0,
        centerTitle: true,
      ),
      
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onSurfaceColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: onSurfaceColor.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: onSurfaceColor.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }

  /// Thème sombre personnalisé
  static ThemeData get darkTheme {
    const primaryColor = Color(0xFF32F094);
    const surfaceColor = Color(0xFF191E21);
    const onSurfaceColor = Color(0xFFE8E6E6);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: surfaceColor,
        secondary: primaryColor.withOpacity(0.8),
        onSecondary: surfaceColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        background: surfaceColor,
        onBackground: onSurfaceColor,
        outline: onSurfaceColor.withOpacity(0.2),
        shadow: Colors.black.withOpacity(0.3),
      ),
      
      // Typographie
      textTheme: _buildTextTheme(onSurfaceColor),
      
      // Composants
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: onSurfaceColor,
        elevation: 0,
        centerTitle: true,
      ),
      
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: surfaceColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: onSurfaceColor.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: onSurfaceColor.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }

  /// Construit la typographie personnalisée
  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      // Titres
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: -0.25,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      
      // Titres de section
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      
      // Corps de texte
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textColor.withOpacity(0.8),
      ),
      
      // Labels
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textColor.withOpacity(0.8),
      ),
    );
  }
}