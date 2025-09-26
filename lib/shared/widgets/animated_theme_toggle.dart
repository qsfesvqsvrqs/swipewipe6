import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'custom_icons.dart';
import '../../core/services/haptic_service.dart';

/// Bouton de basculement de thème avec animations fluides
class AnimatedThemeToggle extends StatefulWidget {
  final double size;
  final EdgeInsets? padding;

  const AnimatedThemeToggle({
    super.key,
    this.size = 48,
    this.padding,
  });

  @override
  State<AnimatedThemeToggle> createState() => _AnimatedThemeToggleState();
}

class _AnimatedThemeToggleState extends State<AnimatedThemeToggle>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _glowController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // Animation de rotation pour le morphing soleil/lune
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    // Animation de scale pour l'effet de press
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    // Animation de glow
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Animation de glow en boucle
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    // Feedback haptique léger
    await HapticService.lightImpact();
    
    // Animation de press
    await _scaleController.forward();
    _scaleController.reverse();
    
    // Basculer le thème
    if (mounted) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.toggleTheme();
      
      // Animation de rotation
      if (themeProvider.isDarkMode) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GestureDetector(
          onTap: _handleTap,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: Container(
            padding: widget.padding ?? const EdgeInsets.all(8),
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _rotationAnimation,
                _scaleAnimation,
                _glowAnimation,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.primary.withOpacity(0.05),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.7, 1.0],
                      ),
                      boxShadow: [
                        // Glow effect
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(
                            _glowAnimation.value * 0.3,
                          ),
                          blurRadius: 20 * _glowAnimation.value,
                          spreadRadius: 2 * _glowAnimation.value,
                        ),
                        // Ombre subtile
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(widget.size / 2),
                        onTap: _handleTap,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Transform.rotate(
                              angle: _rotationAnimation.value * 3.14159,
                              child: CustomIcons.theme(
                                size: widget.size * 0.5,
                                color: theme.colorScheme.primary,
                                strokeWidth: 2,
                                isDark: isDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// Version compacte du bouton de thème pour les barres d'outils
class CompactThemeToggle extends StatelessWidget {
  final double size;

  const CompactThemeToggle({
    super.key,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedThemeToggle(
      size: size,
      padding: const EdgeInsets.all(4),
    );
  }
}

/// Version compacte du bouton de thème pour les headers
class CompactThemeToggle extends StatelessWidget {
  const CompactThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnimatedThemeToggle(
      size: 40,
      padding: EdgeInsets.all(8),
    );
  }
}