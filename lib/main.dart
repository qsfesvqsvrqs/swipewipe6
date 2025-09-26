import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'shared/providers/theme_provider.dart';
import 'features/home/presentation/pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuration de la barre de statut
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Initialiser le provider de thème
  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  runApp(SwipeWipeApp(themeProvider: themeProvider));
}

class SwipeWipeApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const SwipeWipeApp({
    super.key,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'SwipeWipe',
            debugShowCheckedModeBanner: false,
            
            // Configuration des thèmes
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            
            // Page d'accueil
            home: const SwipeWipeHome(),
            
            // Configuration des transitions
            builder: (context, child) {
              return AnimatedTheme(
                data: themeProvider.isDarkMode 
                    ? ThemeProvider.darkTheme 
                    : ThemeProvider.lightTheme,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

class SwipeWipeHome extends StatefulWidget {
  const SwipeWipeHome({super.key});

  @override
  State<SwipeWipeHome> createState() => _SwipeWipeHomeState();
}

class _SwipeWipeHomeState extends State<SwipeWipeHome>
    with TickerProviderStateMixin {
  late AnimationController _splashController;
  late Animation<double> _splashAnimation;
  
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    
    _splashController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _splashAnimation = CurvedAnimation(
      parent: _splashController,
      curve: Curves.easeInOut,
    );

    _startSplashSequence();
  }

  @override
  void dispose() {
    _splashController.dispose();
    super.dispose();
  }

  void _startSplashSequence() async {
    // Animation d'entrée du splash
    await _splashController.forward();
    
    // Attendre un peu
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Animation de sortie du splash
    await _splashController.reverse();
    
    // Masquer le splash et afficher l'écran principal
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return _buildSplashScreen(context);
    }
    
    return const HomeScreen();
  }

  Widget _buildSplashScreen(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.surface,
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _splashAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.5 + (_splashAnimation.value * 0.5),
                child: Opacity(
                  opacity: _splashAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo avec glow
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.3),
                              theme.colorScheme.primary.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.swipe,
                            size: 60,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Titre
                      Text(
                        'SwipeWipe',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Sous-titre
                      Text(
                        'Triez vos photos en un geste',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Indicateur de chargement
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
