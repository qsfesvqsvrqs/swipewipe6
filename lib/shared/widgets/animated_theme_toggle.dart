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

    // Animation de glow uniquement lors des interactions
    // _glowController.repeat(reverse: true); // Supprimé pour économiser les ressources
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
    // Démarrer l'animation glow lors de l'interaction
    _glowController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    // Arrêter l'animation glow
    _glowController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    // Arrêter l'animation glow
    _glowController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Semantics(
          button: true,
          label: themeProvider.isDarkMode ? 'Passer au thème clair' : 'Passer au thème sombre',
          hint: 'Appuyez pour changer le thème de l\'application',
          value: themeProvider.isDarkMode ? 'Thème sombre activé' : 'Thème clair activé',
          child: GestureDetector(
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

/// Version compacte du bouton de thème avec paramètres configurables
class CompactThemeToggle extends StatelessWidget {
  final double size;
  final EdgeInsets? padding;
  final CompactThemeToggleType type;

  const CompactThemeToggle({
    super.key,
    this.size = 32,
    this.padding,
    this.type = CompactThemeToggleType.toolbar,
  });

  /// Constructeur pour les barres d'outils
  const CompactThemeToggle.toolbar({
    super.key,
    this.size = 32,
  }) : padding = const EdgeInsets.all(4),
       type = CompactThemeToggleType.toolbar;

  /// Constructeur pour les headers
  const CompactThemeToggle.header({
    super.key,
    this.size = 40,
  }) : padding = const EdgeInsets.all(8),
       type = CompactThemeToggleType.header;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? 
        (type == CompactThemeToggleType.header 
            ? const EdgeInsets.all(8) 
            : const EdgeInsets.all(4));
    
    return AnimatedThemeToggle(
      size: size,
      padding: effectivePadding,
    );
  }
}

/// Types de boutons compacts disponibles
enum CompactThemeToggleType {
  toolbar,
  header,
}