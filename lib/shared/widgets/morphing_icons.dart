import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Icônes avec animations de morphing fluides
class MorphingIcons extends StatefulWidget {
  final IconData fromIcon;
  final IconData toIcon;
  final bool isToggled;
  final Duration duration;
  final Color? color;
  final double size;
  final VoidCallback? onTap;

  const MorphingIcons({
    super.key,
    required this.fromIcon,
    required this.toIcon,
    required this.isToggled,
    this.duration = const Duration(milliseconds: 300),
    this.color,
    this.size = 24,
    this.onTap,
  });

  @override
  State<MorphingIcons> createState() => _MorphingIconsState();
}

class _MorphingIconsState extends State<MorphingIcons>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    if (widget.isToggled) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(MorphingIcons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isToggled != widget.isToggled) {
      if (widget.isToggled) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Icône de départ
              Opacity(
                opacity: 1.0 - _animation.value,
                child: Transform.scale(
                  scale: 1.0 - (_animation.value * 0.2),
                  child: Transform.rotate(
                    angle: _animation.value * math.pi / 4,
                    child: Icon(
                      widget.fromIcon,
                      size: widget.size,
                      color: widget.color,
                    ),
                  ),
                ),
              ),
              // Icône d'arrivée
              Opacity(
                opacity: _animation.value,
                child: Transform.scale(
                  scale: 0.8 + (_animation.value * 0.2),
                  child: Transform.rotate(
                    angle: (1.0 - _animation.value) * -math.pi / 4,
                    child: Icon(
                      widget.toIcon,
                      size: widget.size,
                      color: widget.color,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Icône de play/pause avec morphing
class PlayPauseIcon extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback? onTap;
  final Color? color;
  final double size;

  const PlayPauseIcon({
    super.key,
    required this.isPlaying,
    this.onTap,
    this.color,
    this.size = 24,
  });

  @override
  State<PlayPauseIcon> createState() => _PlayPauseIconState();
}

class _PlayPauseIconState extends State<PlayPauseIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isPlaying) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(PlayPauseIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPlaying != widget.isPlaying) {
      if (widget.isPlaying) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _PlayPausePainter(
            progress: _animation.value,
            color: widget.color ?? Theme.of(context).iconTheme.color!,
          ),
        ),
      ),
    );
  }
}

class _PlayPausePainter extends CustomPainter {
  final double progress;
  final Color color;

  _PlayPausePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    if (progress < 0.5) {
      // Morphing de play vers pause (première moitié)
      final t = progress * 2;
      _drawPlayToPause(canvas, center, radius, t, paint);
    } else {
      // Morphing de play vers pause (deuxième moitié)
      final t = (progress - 0.5) * 2;
      _drawPauseComplete(canvas, center, radius, t, paint);
    }
  }

  void _drawPlayToPause(Canvas canvas, Offset center, double radius, double t, Paint paint) {
    // Triangle de play qui se transforme
    final path = Path();
    
    // Points du triangle de play
    final playLeft = Offset(center.dx - radius * 0.3, center.dy - radius * 0.5);
    final playRight = Offset(center.dx + radius * 0.5, center.dy);
    final playBottom = Offset(center.dx - radius * 0.3, center.dy + radius * 0.5);
    
    // Points de pause
    final pauseLeft1 = Offset(center.dx - radius * 0.3, center.dy - radius * 0.5);
    final pauseLeft2 = Offset(center.dx - radius * 0.1, center.dy - radius * 0.5);
    final pauseRight1 = Offset(center.dx + radius * 0.1, center.dy - radius * 0.5);
    final pauseRight2 = Offset(center.dx + radius * 0.3, center.dy - radius * 0.5);
    
    // Interpolation
    final leftTop = Offset.lerp(playLeft, pauseLeft1, t)!;
    final rightTop = Offset.lerp(playRight, pauseRight2, t)!;
    final leftBottom = Offset.lerp(playBottom, Offset(pauseLeft1.dx, center.dy + radius * 0.5), t)!;
    final rightBottom = Offset.lerp(playRight, Offset(pauseRight2.dx, center.dy + radius * 0.5), t)!;
    
    // Dessiner la forme interpolée
    path.moveTo(leftTop.dx, leftTop.dy);
    path.lineTo(rightTop.dx, rightTop.dy);
    path.lineTo(rightBottom.dx, rightBottom.dy);
    path.lineTo(leftBottom.dx, leftBottom.dy);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  void _drawPauseComplete(Canvas canvas, Offset center, double radius, double t, Paint paint) {
    // Deux barres de pause
    final barWidth = radius * 0.2;
    final barHeight = radius;
    
    // Barre gauche
    final leftRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.2, center.dy),
        width: barWidth,
        height: barHeight,
      ),
      Radius.circular(barWidth * 0.2),
    );
    
    // Barre droite
    final rightRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.2, center.dy),
        width: barWidth,
        height: barHeight,
      ),
      Radius.circular(barWidth * 0.2),
    );
    
    canvas.drawRRect(leftRect, paint);
    canvas.drawRRect(rightRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _PlayPausePainter && oldDelegate.progress != progress;
  }
}

/// Icône de cœur avec animation de battement
class HeartIcon extends StatefulWidget {
  final bool isLiked;
  final VoidCallback? onTap;
  final Color? color;
  final Color? likedColor;
  final double size;

  const HeartIcon({
    super.key,
    required this.isLiked,
    this.onTap,
    this.color,
    this.likedColor,
    this.size = 24,
  });

  @override
  State<HeartIcon> createState() => _HeartIconState();
}

class _HeartIconState extends State<HeartIcon>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _beatController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _beatAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _beatController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _beatAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _beatController,
      curve: Curves.easeInOut,
    ));

    if (widget.isLiked) {
      _scaleController.value = 1.0;
      _startBeating();
    }
  }

  void _startBeating() {
    _beatController.repeat(reverse: true);
  }

  void _stopBeating() {
    _beatController.stop();
    _beatController.reset();
  }

  @override
  void didUpdateWidget(HeartIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLiked != widget.isLiked) {
      if (widget.isLiked) {
        _scaleController.forward().then((_) {
          _scaleController.reverse();
          _startBeating();
        });
      } else {
        _stopBeating();
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _beatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = widget.color ?? theme.iconTheme.color!;
    final likedColor = widget.likedColor ?? Colors.red;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _beatAnimation]),
        builder: (context, child) {
          final scale = widget.isLiked 
              ? _scaleAnimation.value * _beatAnimation.value
              : 1.0;
          
          return Transform.scale(
            scale: scale,
            child: Icon(
              widget.isLiked ? Icons.favorite : Icons.favorite_border,
              size: widget.size,
              color: widget.isLiked ? likedColor : defaultColor,
            ),
          );
        },
      ),
    );
  }
}

/// Icône de menu hamburger avec morphing vers X
class MenuIcon extends StatefulWidget {
  final bool isOpen;
  final VoidCallback? onTap;
  final Color? color;
  final double size;
  final double strokeWidth;

  const MenuIcon({
    super.key,
    required this.isOpen,
    this.onTap,
    this.color,
    this.size = 24,
    this.strokeWidth = 2,
  });

  @override
  State<MenuIcon> createState() => _MenuIconState();
}

class _MenuIconState extends State<MenuIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isOpen) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(MenuIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOpen != widget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _MenuIconPainter(
            progress: _animation.value,
            color: widget.color ?? Theme.of(context).iconTheme.color!,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _MenuIconPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _MenuIconPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final lineLength = size.width * 0.6;
    final lineSpacing = size.height * 0.2;

    // Ligne du haut
    final topStart = Offset(
      center.dx - lineLength / 2,
      center.dy - lineSpacing,
    );
    final topEnd = Offset(
      center.dx + lineLength / 2,
      center.dy - lineSpacing,
    );

    // Ligne du milieu
    final middleStart = Offset(
      center.dx - lineLength / 2,
      center.dy,
    );
    final middleEnd = Offset(
      center.dx + lineLength / 2,
      center.dy,
    );

    // Ligne du bas
    final bottomStart = Offset(
      center.dx - lineLength / 2,
      center.dy + lineSpacing,
    );
    final bottomEnd = Offset(
      center.dx + lineLength / 2,
      center.dy + lineSpacing,
    );

    if (progress == 0) {
      // Menu hamburger
      canvas.drawLine(topStart, topEnd, paint);
      canvas.drawLine(middleStart, middleEnd, paint);
      canvas.drawLine(bottomStart, bottomEnd, paint);
    } else if (progress == 1) {
      // X
      canvas.drawLine(topStart, bottomEnd, paint);
      canvas.drawLine(bottomStart, topEnd, paint);
    } else {
      // Animation intermédiaire
      final topNewEnd = Offset.lerp(topEnd, bottomEnd, progress)!;
      final bottomNewEnd = Offset.lerp(bottomEnd, topEnd, progress)!;
      
      // Ligne du haut qui devient diagonale
      canvas.drawLine(topStart, topNewEnd, paint);
      
      // Ligne du bas qui devient diagonale
      canvas.drawLine(bottomStart, bottomNewEnd, paint);
      
      // Ligne du milieu qui disparaît
      final middleOpacity = 1.0 - progress;
      final middlePaint = Paint()
        ..color = color.withOpacity(middleOpacity)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      
      canvas.drawLine(middleStart, middleEnd, middlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _MenuIconPainter && oldDelegate.progress != progress;
  }
}