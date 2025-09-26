import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Collection d'icônes personnalisées pour SwipeWipe
/// Design sobre et minimaliste avec des formes géométriques simples
class CustomIcons {
  CustomIcons._();

  // Icône de tri/swipe - Cercle avec flèches directionnelles
  static Widget swipe({
    double size = 24,
    Color? color,
    double strokeWidth = 2,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SwipeIconPainter(
        color: color ?? Colors.white,
        strokeWidth: strokeWidth,
      ),
    );
  }

  // Icône d'album - Trois rectangles empilés avec perspective
  static Widget album({
    double size = 24,
    Color? color,
    double strokeWidth = 2,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _AlbumIconPainter(
        color: color ?? Colors.white,
        strokeWidth: strokeWidth,
      ),
    );
  }

  // Icône de maison - Forme géométrique simple
  static Widget home({
    double size = 24,
    Color? color,
    double strokeWidth = 2,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HomeIconPainter(
        color: color ?? Colors.white,
        strokeWidth: strokeWidth,
      ),
    );
  }

  // Icône de suppression - X stylisé dans un cercle
  static Widget delete({
    double size = 24,
    Color? color,
    double strokeWidth = 2,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DeleteIconPainter(
        color: color ?? Colors.white,
        strokeWidth: strokeWidth,
      ),
    );
  }

  // Icône de sauvegarde - Cœur géométrique
  static Widget save({
    double size = 24,
    Color? color,
    double strokeWidth = 2,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SaveIconPainter(
        color: color ?? Colors.white,
        strokeWidth: strokeWidth,
      ),
    );
  }

  // Icône de restauration - Flèche circulaire
  static Widget restore({
    double size = 24,
    Color? color,
    double strokeWidth = 2,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RestoreIconPainter(
        color: color ?? Colors.white,
        strokeWidth: strokeWidth,
      ),
    );
  }

  // Icône de thème - Soleil/Lune morphing
  static Widget theme({
    double size = 24,
    Color? color,
    double strokeWidth = 2,
    bool isDark = false,
  }) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ThemeIconPainter(
        color: color ?? Colors.white,
        strokeWidth: strokeWidth,
        isDark: isDark,
      ),
    );
  }

  // Icône de navigation - Flèche stylisée
  static Widget arrow({
    double size = 24,
    Color? color,
    double strokeWidth = 2,
    double rotation = 0,
  }) {
    return Transform.rotate(
      angle: rotation,
      child: CustomPaint(
        size: Size(size, size),
        painter: _ArrowIconPainter(
          color: color ?? Colors.white,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

// Painters pour chaque icône personnalisée

class _SwipeIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _SwipeIconPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Cercle central
    canvas.drawCircle(center, radius, paint);

    // Flèches directionnelles
    final arrowLength = size.width * 0.15;
    
    // Flèche droite
    canvas.drawLine(
      Offset(center.dx + radius + 2, center.dy),
      Offset(center.dx + radius + arrowLength + 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + radius + arrowLength + 2, center.dy),
      Offset(center.dx + radius + arrowLength - 3, center.dy - 3),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + radius + arrowLength + 2, center.dy),
      Offset(center.dx + radius + arrowLength - 3, center.dy + 3),
      paint,
    );

    // Flèche gauche
    canvas.drawLine(
      Offset(center.dx - radius - 2, center.dy),
      Offset(center.dx - radius - arrowLength - 2, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - radius - arrowLength - 2, center.dy),
      Offset(center.dx - radius - arrowLength + 3, center.dy - 3),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - radius - arrowLength - 2, center.dy),
      Offset(center.dx - radius - arrowLength + 3, center.dy + 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AlbumIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _AlbumIconPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width * 0.8;
    final h = size.height * 0.6;
    final offsetX = (size.width - w) / 2;
    final offsetY = (size.height - h) / 2;

    // Trois rectangles empilés avec perspective
    for (int i = 0; i < 3; i++) {
      final offset = i * 2.0;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          offsetX + offset,
          offsetY + offset,
          w - offset * 2,
          h - offset * 2,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HomeIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _HomeIconPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width * 0.8;
    final h = size.height * 0.8;
    final offsetX = (size.width - w) / 2;
    final offsetY = (size.height - h) / 2;

    // Forme de maison géométrique
    path.moveTo(offsetX + w / 2, offsetY);
    path.lineTo(offsetX + w, offsetY + h * 0.4);
    path.lineTo(offsetX + w * 0.8, offsetY + h * 0.4);
    path.lineTo(offsetX + w * 0.8, offsetY + h);
    path.lineTo(offsetX + w * 0.2, offsetY + h);
    path.lineTo(offsetX + w * 0.2, offsetY + h * 0.4);
    path.lineTo(offsetX, offsetY + h * 0.4);
    path.close();

    canvas.drawPath(path, paint);

    // Porte
    final doorRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        offsetX + w * 0.4,
        offsetY + h * 0.6,
        w * 0.2,
        h * 0.4,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(doorRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DeleteIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _DeleteIconPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Cercle
    canvas.drawCircle(center, radius, paint);

    // X stylisé
    final crossSize = radius * 0.6;
    canvas.drawLine(
      Offset(center.dx - crossSize, center.dy - crossSize),
      Offset(center.dx + crossSize, center.dy + crossSize),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + crossSize, center.dy - crossSize),
      Offset(center.dx - crossSize, center.dy + crossSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SaveIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _SaveIconPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final heartSize = size.width * 0.35;

    // Cœur géométrique
    final path = Path();
    path.moveTo(center.dx, center.dy + heartSize * 0.8);
    
    // Côté gauche
    path.cubicTo(
      center.dx - heartSize * 0.8, center.dy + heartSize * 0.2,
      center.dx - heartSize * 0.8, center.dy - heartSize * 0.4,
      center.dx - heartSize * 0.3, center.dy - heartSize * 0.6,
    );
    
    // Haut gauche
    path.cubicTo(
      center.dx - heartSize * 0.1, center.dy - heartSize * 0.8,
      center.dx + heartSize * 0.1, center.dy - heartSize * 0.8,
      center.dx + heartSize * 0.3, center.dy - heartSize * 0.6,
    );
    
    // Côté droit
    path.cubicTo(
      center.dx + heartSize * 0.8, center.dy - heartSize * 0.4,
      center.dx + heartSize * 0.8, center.dy + heartSize * 0.2,
      center.dx, center.dy + heartSize * 0.8,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RestoreIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _RestoreIconPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Arc circulaire
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 1.5,
      false,
      paint,
    );

    // Flèche
    final arrowTip = Offset(center.dx, center.dy - radius);
    canvas.drawLine(
      arrowTip,
      Offset(arrowTip.dx - 6, arrowTip.dy + 8),
      paint,
    );
    canvas.drawLine(
      arrowTip,
      Offset(arrowTip.dx + 6, arrowTip.dy + 8),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ThemeIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isDark;

  _ThemeIconPainter({
    required this.color,
    required this.strokeWidth,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    if (isDark) {
      // Lune
      final moonPath = Path();
      moonPath.addOval(Rect.fromCircle(center: center, radius: radius));
      
      final shadowCenter = Offset(center.dx + radius * 0.3, center.dy - radius * 0.3);
      final shadowPath = Path();
      shadowPath.addOval(Rect.fromCircle(center: shadowCenter, radius: radius * 0.8));
      
      final moonShape = Path.combine(PathOperation.difference, moonPath, shadowPath);
      canvas.drawPath(moonShape, paint);
    } else {
      // Soleil
      canvas.drawCircle(center, radius, paint);
      
      // Rayons
      for (int i = 0; i < 8; i++) {
        final angle = (i * math.pi * 2) / 8;
        final startRadius = radius + 4;
        final endRadius = radius + 12;
        
        final start = Offset(
          center.dx + startRadius * math.cos(angle),
          center.dy + startRadius * math.sin(angle),
        );
        final end = Offset(
          center.dx + endRadius * math.cos(angle),
          center.dy + endRadius * math.sin(angle),
        );
        
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => 
      oldDelegate is _ThemeIconPainter && oldDelegate.isDark != isDark;
}

class _ArrowIconPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _ArrowIconPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width * 0.6;
    final h = size.height * 0.6;
    final offsetX = (size.width - w) / 2;
    final offsetY = (size.height - h) / 2;

    // Flèche stylisée
    final path = Path();
    path.moveTo(offsetX, offsetY + h / 2);
    path.lineTo(offsetX + w * 0.7, offsetY + h / 2);
    path.moveTo(offsetX + w * 0.4, offsetY + h * 0.2);
    path.lineTo(offsetX + w, offsetY + h / 2);
    path.lineTo(offsetX + w * 0.4, offsetY + h * 0.8);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}