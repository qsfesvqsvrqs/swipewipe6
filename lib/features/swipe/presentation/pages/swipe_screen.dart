import 'package:flutter/material.dart';
import '../../../../shared/widgets/animated_theme_toggle.dart';
import '../../../../shared/widgets/custom_icons.dart';
import '../../../home/presentation/widgets/navigation_arrows.dart';
import '../../../../core/services/haptic_service.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeInOut,
    );

    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _navigateBack() {
    HapticService.pageTransition();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header avec navigation
              NavigationBar(
                onLeftTap: _navigateBack,
                leftTooltip: 'Retour',
                centerWidget: const CompactThemeToggle(),
              ),
              
              // Contenu principal
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _cardAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimation.value,
                        child: Opacity(
                          opacity: _cardAnimation.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIcons.swipe(
                                size: 80,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Écran de Tri',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Interface de swipe en cours de développement',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}