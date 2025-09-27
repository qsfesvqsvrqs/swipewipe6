// Flutter imports
import 'package:flutter/material.dart';

// Core services
import '../../../../core/services/haptic_service.dart';

// Shared widgets
import '../../../../shared/utils/responsive_helper.dart';
import '../../../../shared/widgets/animated_theme_toggle.dart';
import '../../../../shared/widgets/custom_icons.dart';

// Feature widgets
import '../../../home/presentation/widgets/navigation_arrows.dart';

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen>
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
              theme.colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: ResponsiveLayout(
            child: Column(
            children: [
              // Header avec navigation
              NavigationBar(
                onRightTap: _navigateBack,
                rightTooltip: 'Retour',
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
                              CustomIcons.album(
                                size: ResponsiveHelper.responsive(
                                  context,
                                  mobile: 64.0,
                                  tablet: 80.0,
                                  desktop: 96.0,
                                ),
                                color: theme.colorScheme.secondary,
                              ),
                              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context) * 1.5),
                              Text(
                                'Albums',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context)),
                              Text(
                                'Gestion des albums en cours de développement',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}