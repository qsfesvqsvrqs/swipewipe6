import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Indicateur de stockage avec animation circulaire
class StorageIndicator extends StatefulWidget {
  final double usedSpace;
  final double totalSpace;
  final double freedThisMonth;

  const StorageIndicator({
    super.key,
    this.usedSpace = 45.2, // GB
    this.totalSpace = 128.0, // GB
    this.freedThisMonth = 2.1, // GB
  });

  @override
  State<StorageIndicator> createState() => _StorageIndicatorState();
}

class _StorageIndicatorState extends State<StorageIndicator>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.usedSpace / widget.totalSpace,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Démarrer les animations
    _progressController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final availableSpace = widget.totalSpace - widget.usedSpace;
    final usagePercentage = (widget.usedSpace / widget.totalSpace * 100).round();

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Titre
          Text(
            'Espace de stockage',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Indicateur circulaire
          SizedBox(
            width: 200,
            height: 200,
            child: AnimatedBuilder(
              animation: Listenable.merge([_progressAnimation, _pulseAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: CustomPaint(
                    size: const Size(200, 200),
                    painter: _StorageCirclePainter(
                      progress: _progressAnimation.value,
                      backgroundColor: theme.colorScheme.outline.withOpacity(0.1),
                      progressColor: theme.colorScheme.primary,
                      strokeWidth: 12,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${availableSpace.toStringAsFixed(1)} GB',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'disponible',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$usagePercentage% utilisé',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Statistiques détaillées
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                context,
                title: 'Utilisé',
                value: '${widget.usedSpace.toStringAsFixed(1)} GB',
                color: theme.colorScheme.primary,
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
              _buildStatColumn(
                context,
                title: 'Libéré ce mois',
                value: '${widget.freedThisMonth.toStringAsFixed(1)} GB',
                color: theme.colorScheme.secondary,
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
              _buildStatColumn(
                context,
                title: 'Total',
                value: '${widget.totalSpace.toStringAsFixed(0)} GB',
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Painter pour l'indicateur circulaire de stockage
class _StorageCirclePainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _StorageCirclePainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Peinture pour le fond
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Peinture pour le progrès
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Dessiner le cercle de fond
    canvas.drawCircle(center, radius, backgroundPaint);

    // Dessiner l'arc de progrès
    if (progress > 0) {
      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // Commencer en haut
        sweepAngle,
        false,
        progressPaint,
      );
    }

    // Ajouter un gradient subtil au progrès
    if (progress > 0) {
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            progressColor.withOpacity(0.8),
            progressColor,
            progressColor.withOpacity(0.6),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        gradientPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _StorageCirclePainter &&
        oldDelegate.progress != progress;
  }
}