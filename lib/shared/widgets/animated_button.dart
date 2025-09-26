import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bouton animé avec feedback haptique et effets visuels
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool enableHaptic;
  final bool enableGlow;
  final Duration animationDuration;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.enableHaptic = true,
    this.enableGlow = true,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    if (widget.enableGlow) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() => _isPressed = true);
      _scaleController.forward();
      
      if (widget.enableHaptic) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  void _handleTap() {
    if (widget.onPressed != null) {
      if (widget.enableHaptic) {
        HapticFeedback.selectionClick();
      }
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.primary;
    final foregroundColor = widget.foregroundColor ?? theme.colorScheme.onPrimary;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                boxShadow: [
                  if (widget.enableGlow)
                    BoxShadow(
                      color: backgroundColor.withOpacity(
                        _glowAnimation.value * 0.3,
                      ),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: widget.elevation ?? 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: backgroundColor,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                  onTap: widget.onPressed,
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: DefaultTextStyle(
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: foregroundColor,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Bouton d'icône animé
class AnimatedIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final bool enableHaptic;
  final bool enableGlow;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.color,
    this.backgroundColor,
    this.enableHaptic = true,
    this.enableGlow = false,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (widget.onPressed != null) {
      if (widget.enableHaptic) {
        HapticFeedback.lightImpact();
      }
      
      // Animation de press
      await _scaleController.forward();
      _scaleController.reverse();
      
      // Petite rotation pour l'effet
      _rotationController.forward().then((_) {
        _rotationController.reverse();
      });
      
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = widget.color ?? theme.colorScheme.primary;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.backgroundColor?.withOpacity(0.1),
                  border: widget.backgroundColor != null
                      ? Border.all(
                          color: widget.backgroundColor!.withOpacity(0.2),
                          width: 1,
                        )
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(widget.size / 2),
                    onTap: widget.onPressed,
                    child: Center(
                      child: IconTheme(
                        data: IconThemeData(
                          color: iconColor,
                          size: widget.size * 0.5,
                        ),
                        child: widget.icon,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}