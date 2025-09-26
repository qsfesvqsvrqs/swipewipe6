import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/widgets/animated_theme_toggle.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/custom_icons.dart';
import '../../../../shared/widgets/page_transitions.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../swipe/presentation/pages/swipe_screen.dart';
import '../../../albums/presentation/pages/albums_screen.dart';
import '../widgets/storage_indicator.dart';
import '../widgets/navigation_arrows.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
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
    _glowController.dispose();
    super.dispose();
  }

  void _navigateToSwipe() async {
    await HapticService.pageTransition();
    if (mounted) {
      Navigator.of(context).pushWithTransition(
        const SwipeScreen(),
        type: PageTransitionType.swipeParallax,
        direction: SlideDirection.right,
      );
    }
  }

  void _navigateToAlbums() async {
    await HapticService.pageTransition();
    if (mounted) {
      Navigator.of(context).pushWithTransition(
        const AlbumsScreen(),
        type: PageTransitionType.swipeParallax,
        direction: SlideDirection.left,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
              theme.colorScheme.primary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header avec navigation et bouton de thème
              _buildHeader(context),
              
              // Contenu principal
              Expanded(
                child: AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 600),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        const SizedBox(height: 40),
                        
                        // Logo et titre
                        _buildLogo(context),
                        
                        const SizedBox(height: 60),
                        
                        // Indicateur de stockage
                        const StorageIndicator(),
                        
                        const SizedBox(height: 80),
                        
                        // Bouton principal
                        _buildMainButton(context),
                        
                        const Spacer(),
                        
                        // Statistiques rapides
                        _buildQuickStats(context),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Navigation vers Albums
          NavigationArrow(
            direction: ArrowDirection.left,
            onTap: _navigateToAlbums,
            tooltip: 'Albums',
          ),
          
          const Spacer(),
          
          // Bouton de thème
          const AnimatedThemeToggle(),
          
          const Spacer(),
          
          // Navigation vers Swipe
          NavigationArrow(
            direction: ArrowDirection.right,
            onTap: _navigateToSwipe,
            tooltip: 'Tri',
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Icône principale avec glow
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.2),
                    theme.colorScheme.primary.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(
                      _glowAnimation.value * 0.4,
                    ),
                    blurRadius: 30 * _glowAnimation.value,
                    spreadRadius: 5 * _glowAnimation.value,
                  ),
                ],
              ),
              child: Center(
                child: CustomIcons.swipe(
                  size: 60,
                  color: theme.colorScheme.primary,
                  strokeWidth: 2.5,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        // Titre
        Text(
          'SwipeWipe',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Sous-titre
        Text(
          'Triez vos photos en un geste',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMainButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: AnimatedButton(
        onPressed: _navigateToSwipe,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 20,
        ),
        borderRadius: BorderRadius.circular(16),
        enableGlow: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIcons.swipe(
              size: 24,
              color: theme.colorScheme.onPrimary,
            ),
            const SizedBox(width: 16),
            Text(
              'Commencer le tri',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: CustomIcons.album(
              size: 20,
              color: theme.colorScheme.primary,
            ),
            label: 'Albums',
            value: '3',
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
          _buildStatItem(
            context,
            icon: Icon(
              Icons.photo_library_outlined,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            label: 'Photos',
            value: '1.2k',
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
          _buildStatItem(
            context,
            icon: Icon(
              Icons.cleaning_services_outlined,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            label: 'Libéré',
            value: '2.1 GB',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required Widget icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}