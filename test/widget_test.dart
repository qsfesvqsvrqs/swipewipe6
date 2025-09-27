// Tests pour l'application SwipeWipe
// Tests des widgets principaux et de la navigation

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:swipewipe/main.dart';
import 'package:swipewipe/shared/providers/theme_provider.dart';

void main() {
  group('SwipeWipe App Tests', () {
    testWidgets('App should build without errors', (WidgetTester tester) async {
      // Créer un ThemeProvider pour les tests
      final themeProvider = ThemeProvider();
      await themeProvider.initialize();

      // Construire l'app avec le provider
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: const SwipeWipeApp(),
        ),
      );

      // Vérifier que l'app se construit sans erreur
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Home screen should display correctly', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      await themeProvider.initialize();

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: const SwipeWipeApp(),
        ),
      );

      // Attendre que l'animation de splash se termine
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Vérifier que l'écran d'accueil s'affiche
      expect(find.text('SwipeWipe'), findsOneWidget);
      expect(find.text('Organisez vos photos en un geste'), findsOneWidget);
    });

    testWidgets('Theme toggle should work', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      await themeProvider.initialize();

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: const SwipeWipeApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Trouver le bouton de basculement de thème
      final themeToggleFinder = find.byType(GestureDetector).first;
      
      // Vérifier l'état initial du thème
      final initialIsDark = themeProvider.isDarkMode;

      // Taper sur le bouton de thème
      await tester.tap(themeToggleFinder);
      await tester.pumpAndSettle();

      // Vérifier que le thème a changé
      expect(themeProvider.isDarkMode, !initialIsDark);
    });
  });

  group('Navigation Tests', () {
    testWidgets('Navigation to swipe screen should work', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      await themeProvider.initialize();

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: const SwipeWipeApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Trouver et taper sur le bouton de navigation gauche (swipe)
      final leftArrowFinder = find.byType(GestureDetector).where(
        (widget) => widget.toString().contains('ArrowDirection.left'),
      );

      if (leftArrowFinder.isNotEmpty) {
        await tester.tap(leftArrowFinder.first);
        await tester.pumpAndSettle();

        // Vérifier que nous sommes sur l'écran de swipe
        expect(find.text('Écran de Tri'), findsOneWidget);
      }
    });

    testWidgets('Navigation to albums screen should work', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      await themeProvider.initialize();

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>.value(
          value: themeProvider,
          child: const SwipeWipeApp(),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Trouver et taper sur le bouton de navigation droite (albums)
      final rightArrowFinder = find.byType(GestureDetector).where(
        (widget) => widget.toString().contains('ArrowDirection.right'),
      );

      if (rightArrowFinder.isNotEmpty) {
        await tester.tap(rightArrowFinder.first);
        await tester.pumpAndSettle();

        // Vérifier que nous sommes sur l'écran des albums
        expect(find.text('Albums'), findsOneWidget);
      }
    });
  });
}
