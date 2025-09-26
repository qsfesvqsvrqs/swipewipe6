import 'package:flutter/material.dart';

/// Transitions personnalisées pour la navigation entre écrans
class PageTransitions {
  PageTransitions._();

  /// Transition de slide horizontal fluide
  static PageRouteBuilder slideTransition({
    required Widget page,
    required RouteSettings settings,
    SlideDirection direction = SlideDirection.right,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOutCubic,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        switch (direction) {
          case SlideDirection.left:
            begin = const Offset(-1.0, 0.0);
            break;
          case SlideDirection.right:
            begin = const Offset(1.0, 0.0);
            break;
          case SlideDirection.up:
            begin = const Offset(0.0, -1.0);
            break;
          case SlideDirection.down:
            begin = const Offset(0.0, 1.0);
            break;
        }

        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(
          tween.chain(CurveTween(curve: curve)),
        );

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// Transition de fade avec scale
  static PageRouteBuilder fadeScaleTransition({
    required Widget page,
    required RouteSettings settings,
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnimation = animation.drive(
          CurveTween(curve: curve),
        );
        
        final scaleAnimation = animation.drive(
          Tween(begin: 0.8, end: 1.0).chain(
            CurveTween(curve: curve),
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Transition morphing circulaire
  static PageRouteBuilder circularRevealTransition({
    required Widget page,
    required RouteSettings settings,
    Offset? center,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final size = MediaQuery.of(context).size;
        final revealCenter = center ?? Offset(size.width / 2, size.height / 2);
        
        final maxRadius = (size.width > size.height ? size.width : size.height) * 1.2;
        
        final radiusAnimation = animation.drive(
          Tween(begin: 0.0, end: maxRadius).chain(
            CurveTween(curve: curve),
          ),
        );

        return ClipPath(
          clipper: _CircularRevealClipper(
            center: revealCenter,
            radius: radiusAnimation.value,
          ),
          child: child,
        );
      },
    );
  }

  /// Transition de rotation 3D
  static PageRouteBuilder rotation3DTransition({
    required Widget page,
    required RouteSettings settings,
    RotationAxis axis = RotationAxis.y,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final rotationAnimation = animation.drive(
          Tween(begin: 1.0, end: 0.0).chain(
            CurveTween(curve: curve),
          ),
        );

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(axis == RotationAxis.y ? rotationAnimation.value * 3.14159 / 2 : 0)
            ..rotateX(axis == RotationAxis.x ? rotationAnimation.value * 3.14159 / 2 : 0),
          child: child,
        );
      },
    );
  }

  /// Transition de swipe avec parallax
  static PageRouteBuilder swipeParallaxTransition({
    required Widget page,
    required RouteSettings settings,
    SlideDirection direction = SlideDirection.right,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOutCubic,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset primaryBegin, secondaryBegin;
        
        switch (direction) {
          case SlideDirection.left:
            primaryBegin = const Offset(-1.0, 0.0);
            secondaryBegin = const Offset(0.3, 0.0);
            break;
          case SlideDirection.right:
            primaryBegin = const Offset(1.0, 0.0);
            secondaryBegin = const Offset(-0.3, 0.0);
            break;
          case SlideDirection.up:
            primaryBegin = const Offset(0.0, -1.0);
            secondaryBegin = const Offset(0.0, 0.3);
            break;
          case SlideDirection.down:
            primaryBegin = const Offset(0.0, 1.0);
            secondaryBegin = const Offset(0.0, -0.3);
            break;
        }

        const end = Offset.zero;
        
        final primaryTween = Tween(begin: primaryBegin, end: end);
        final secondaryTween = Tween(begin: end, end: secondaryBegin);
        
        final primaryAnimation = animation.drive(
          primaryTween.chain(CurveTween(curve: curve)),
        );
        
        final secondarySlideAnimation = secondaryAnimation.drive(
          secondaryTween.chain(CurveTween(curve: curve)),
        );

        return Stack(
          children: [
            SlideTransition(
              position: secondarySlideAnimation,
              child: Container(), // Page précédente
            ),
            SlideTransition(
              position: primaryAnimation,
              child: child,
            ),
          ],
        );
      },
    );
  }
}

/// Directions de slide
enum SlideDirection { left, right, up, down }

/// Axes de rotation
enum RotationAxis { x, y, z }

/// Clipper pour la transition circulaire
class _CircularRevealClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  _CircularRevealClipper({
    required this.center,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper is _CircularRevealClipper &&
        (oldClipper.center != center || oldClipper.radius != radius);
  }
}

/// Extension pour faciliter l'utilisation des transitions
extension NavigatorTransitions on NavigatorState {
  Future<T?> pushWithTransition<T extends Object?>(
    Widget page, {
    PageTransitionType type = PageTransitionType.slide,
    SlideDirection direction = SlideDirection.right,
    Duration? duration,
    Curve? curve,
    Offset? center,
    RotationAxis axis = RotationAxis.y,
  }) {
    late PageRouteBuilder route;
    
    switch (type) {
      case PageTransitionType.slide:
        route = PageTransitions.slideTransition(
          page: page,
          settings: RouteSettings(name: page.runtimeType.toString()),
          direction: direction,
          duration: duration ?? const Duration(milliseconds: 300),
          curve: curve ?? Curves.easeInOutCubic,
        );
        break;
      case PageTransitionType.fadeScale:
        route = PageTransitions.fadeScaleTransition(
          page: page,
          settings: RouteSettings(name: page.runtimeType.toString()),
          duration: duration ?? const Duration(milliseconds: 250),
          curve: curve ?? Curves.easeInOut,
        );
        break;
      case PageTransitionType.circularReveal:
        route = PageTransitions.circularRevealTransition(
          page: page,
          settings: RouteSettings(name: page.runtimeType.toString()),
          center: center,
          duration: duration ?? const Duration(milliseconds: 400),
          curve: curve ?? Curves.easeInOut,
        );
        break;
      case PageTransitionType.rotation3D:
        route = PageTransitions.rotation3DTransition(
          page: page,
          settings: RouteSettings(name: page.runtimeType.toString()),
          axis: axis,
          duration: duration ?? const Duration(milliseconds: 350),
          curve: curve ?? Curves.easeInOut,
        );
        break;
      case PageTransitionType.swipeParallax:
        route = PageTransitions.swipeParallaxTransition(
          page: page,
          settings: RouteSettings(name: page.runtimeType.toString()),
          direction: direction,
          duration: duration ?? const Duration(milliseconds: 300),
          curve: curve ?? Curves.easeInOutCubic,
        );
        break;
    }
    
    return push(route);
  }
}

/// Types de transitions disponibles
enum PageTransitionType {
  slide,
  fadeScale,
  circularReveal,
  rotation3D,
  swipeParallax,
}