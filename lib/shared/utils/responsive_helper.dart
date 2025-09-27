import 'package:flutter/material.dart';

/// Helper pour gérer le responsive design
class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Détermine si l'écran est mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Détermine si l'écran est tablette
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Détermine si l'écran est desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Retourne une valeur selon la taille d'écran
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Retourne le padding horizontal adaptatif
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsive(
        context,
        mobile: 16.0,
        tablet: 32.0,
        desktop: 48.0,
      ),
    );
  }

  /// Retourne la largeur maximale du contenu
  static double getMaxContentWidth(BuildContext context) {
    return responsive(
      context,
      mobile: double.infinity,
      tablet: 800.0,
      desktop: 1200.0,
    );
  }

  /// Retourne le nombre de colonnes pour une grille
  static int getGridColumns(BuildContext context) {
    return responsive(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
  }

  /// Retourne la taille des icônes adaptative
  static double getIconSize(BuildContext context) {
    return responsive(
      context,
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }

  /// Retourne la taille des boutons adaptative
  static double getButtonHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 48.0,
      tablet: 52.0,
      desktop: 56.0,
    );
  }

  /// Retourne l'espacement vertical adaptatif
  static double getVerticalSpacing(BuildContext context) {
    return responsive(
      context,
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );
  }

  /// Retourne la taille de police adaptative
  static double getFontSize(BuildContext context, double baseFontSize) {
    final scaleFactor = responsive(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
    );
    return baseFontSize * scaleFactor;
  }
}

/// Widget responsive qui adapte son contenu selon la taille d'écran
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.responsive(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

/// Layout responsive avec contraintes de largeur
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final bool centerContent;
  final EdgeInsets? padding;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.centerContent = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveHelper.getMaxContentWidth(context);
    final horizontalPadding = padding ?? ResponsiveHelper.getHorizontalPadding(context);

    Widget content = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: horizontalPadding,
      child: child,
    );

    if (centerContent && ResponsiveHelper.isDesktop(context)) {
      content = Center(child: content);
    }

    return content;
  }
}