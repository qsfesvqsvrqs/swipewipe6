import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_icons.dart';
import '../../../../core/services/haptic_service.dart';

/// Flèches de navigation avec animations
class NavigationArrow extends StatefulWidget {
  final ArrowDirection direction;
  final VoidCallback? onTap;
  final String? tooltip;
  final double size;
  final Color? color;

  const NavigationArrow({
    super.key,
    required this.direction,
    this.onTap,
    this.tooltip,
    this.size = 48,
    this.color,
  });

  @override
  State<NavigationArrow> createState() => _NavigationArrowState();
}

class _NavigationArrowState extends State<NavigationArrow>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late AnimationController _glowController;
  
  late Animation<double> _hoverAnimation;
  late Animation<double> _pressAnimation;
  late Animation<double> _glowAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _pressController.forward();
    HapticService.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      HapticService.selectionClick();
      widget.onTap!();
    }
  }

  void _handleHoverEnter(PointerEnterEvent event) {
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _handleHoverExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  double get _rotation {
    switch (widget.direction) {
      case ArrowDirection.left:
        return 3.14159; // 180 degrés
      case ArrowDirection.right:
        return 0;
      case ArrowDirection.up:
        return -3.14159 / 2; // -90 degrés
      case ArrowDirection.down:
        return 3.14159 / 2; // 90 degrés
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final arrowColor = widget.color ?? theme.colorScheme.primary;

    Widget arrow = AnimatedBuilder(
      animation: Listenable.merge([
        _hoverAnimation,
        _pressAnimation,
        _glowAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pressAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: arrowColor.withOpacity(
                0.1 + (_hoverAnimation.value * 0.1),
              ),
              border: Border.all(
                color: arrowColor.withOpacity(
                  0.2 + (_hoverAnimation.value * 0.3),
                ),
                width: 1 + (_hoverAnimation.value * 0.5),
              ),
              boxShadow: [
                // Glow effect
                BoxShadow(
                  color: arrowColor.withOpacity(
                    _glowAnimation.value * 0.3 * (_hoverAnimation.value + 0.3),
                  ),
                  blurRadius: 15 * _glowAnimation.value * (_hoverAnimation.value + 0.5),
                  spreadRadius: 2 * _glowAnimation.value * (_hoverAnimation.value + 0.3),
                ),
                // Ombre subtile
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Transform.translate(
                offset: Offset(
                  _hoverAnimation.value * 2 * (widget.direction == ArrowDirection.right ? 1 : widget.direction == ArrowDirection.left ? -1 : 0),
                  _hoverAnimation.value * 2 * (widget.direction == ArrowDirection.down ? 1 : widget.direction == ArrowDirection.up ? -1 : 0),
                ),
                child: CustomIcons.arrow(
                  size: widget.size * 0.4,
                  color: arrowColor,
                  strokeWidth: 2,
                  rotation: _rotation,
                ),
              ),
            ),
          ),
        );
      },
    );

    return MouseRegion(
      onEnter: _handleHoverEnter,
      onExit: _handleHoverExit,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: widget.tooltip != null
            ? Tooltip(
                message: widget.tooltip!,
                child: arrow,
              )
            : arrow,
      ),
    );
  }
}

/// Directions possibles pour les flèches
enum ArrowDirection {
  left,
  right,
  up,
  down,
}

/// Barre de navigation avec flèches
class NavigationBar extends StatelessWidget {
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;
  final String? leftTooltip;
  final String? rightTooltip;
  final Widget? centerWidget;

  const NavigationBar({
    super.key,
    this.onLeftTap,
    this.onRightTap,
    this.leftTooltip,
    this.rightTooltip,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (onLeftTap != null)
            NavigationArrow(
              direction: ArrowDirection.left,
              onTap: onLeftTap,
              tooltip: leftTooltip,
            )
          else
            const SizedBox(width: 48),
          
          Expanded(
            child: Center(
              child: centerWidget ?? const SizedBox.shrink(),
            ),
          ),
          
          if (onRightTap != null)
            NavigationArrow(
              direction: ArrowDirection.right,
              onTap: onRightTap,
              tooltip: rightTooltip,
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}