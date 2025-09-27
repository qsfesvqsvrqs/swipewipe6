// Tests unitaires pour ThemeProvider
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipewipe/shared/providers/theme_provider.dart';

void main() {
  group('ThemeProvider Tests', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
      // Mock SharedPreferences pour les tests
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial state should be correct', () {
      expect(themeProvider.isDarkMode, isFalse);
      expect(themeProvider.isInitialized, isFalse);
      expect(themeProvider.themeMode, equals(ThemeMode.light));
    });

    test('Initialize should set isInitialized to true', () async {
      await themeProvider.initialize();
      expect(themeProvider.isInitialized, isTrue);
    });

    test('Initialize should load saved theme preference', () async {
      // Configurer une préférence sauvegardée
      SharedPreferences.setMockInitialValues({'theme_mode': true});
      
      await themeProvider.initialize();
      
      expect(themeProvider.isDarkMode, isTrue);
      expect(themeProvider.themeMode, equals(ThemeMode.dark));
    });

    test('toggleTheme should change theme mode', () async {
      await themeProvider.initialize();
      
      final initialMode = themeProvider.isDarkMode;
      await themeProvider.toggleTheme();
      
      expect(themeProvider.isDarkMode, equals(!initialMode));
    });

    test('setTheme should set specific theme', () async {
      await themeProvider.initialize();
      
      await themeProvider.setTheme(true);
      expect(themeProvider.isDarkMode, isTrue);
      expect(themeProvider.themeMode, equals(ThemeMode.dark));
      
      await themeProvider.setTheme(false);
      expect(themeProvider.isDarkMode, isFalse);
      expect(themeProvider.themeMode, equals(ThemeMode.light));
    });

    test('setTheme should not change if same value', () async {
      await themeProvider.initialize();
      
      // Définir le thème à false (déjà la valeur par défaut)
      final initialMode = themeProvider.isDarkMode;
      await themeProvider.setTheme(false);
      
      expect(themeProvider.isDarkMode, equals(initialMode));
    });

    test('lightTheme should have correct properties', () {
      final lightTheme = ThemeProvider.lightTheme;
      
      expect(lightTheme.brightness, equals(Brightness.light));
      expect(lightTheme.useMaterial3, isTrue);
      expect(lightTheme.colorScheme.primary, equals(const Color(0xFF32F094)));
    });

    test('darkTheme should have correct properties', () {
      final darkTheme = ThemeProvider.darkTheme;
      
      expect(darkTheme.brightness, equals(Brightness.dark));
      expect(darkTheme.useMaterial3, isTrue);
      expect(darkTheme.colorScheme.primary, equals(const Color(0xFF32F094)));
    });

    test('Theme should persist after toggle', () async {
      await themeProvider.initialize();
      
      // Basculer le thème
      await themeProvider.toggleTheme();
      final toggledMode = themeProvider.isDarkMode;
      
      // Créer un nouveau provider et initialiser
      final newProvider = ThemeProvider();
      await newProvider.initialize();
      
      // Le nouveau provider devrait avoir le même état
      expect(newProvider.isDarkMode, equals(toggledMode));
    });

    test('Initialize should handle errors gracefully', () async {
      // Cette méthode ne devrait pas lancer d'exception même en cas d'erreur
      expect(() async => await themeProvider.initialize(), returnsNormally);
      expect(themeProvider.isInitialized, isTrue);
    });

    test('Methods should auto-initialize if not initialized', () async {
      expect(themeProvider.isInitialized, isFalse);
      
      await themeProvider.toggleTheme();
      expect(themeProvider.isInitialized, isTrue);
      
      final newProvider = ThemeProvider();
      expect(newProvider.isInitialized, isFalse);
      
      await newProvider.setTheme(true);
      expect(newProvider.isInitialized, isTrue);
    });
  });
}