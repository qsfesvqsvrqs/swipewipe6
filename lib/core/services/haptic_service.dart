import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Service de gestion du feedback haptique
/// Fournit des vibrations subtiles et contextuelles
class HapticService {
  static const HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  const HapticService._internal();

  /// Feedback léger pour les interactions simples
  /// Utilisé pour : tap sur boutons, sélection d'éléments
  static Future<void> lightImpact() async {
    if (!kIsWeb) {
      try {
        await HapticFeedback.lightImpact();
      } catch (e) {
        debugPrint('Haptic feedback not available: $e');
      }
    }
  }

  /// Feedback moyen pour les actions importantes
  /// Utilisé pour : swipe, changement d'état, navigation
  static Future<void> mediumImpact() async {
    if (!kIsWeb) {
      try {
        await HapticFeedback.mediumImpact();
      } catch (e) {
        debugPrint('Haptic feedback not available: $e');
      }
    }
  }

  /// Feedback fort pour les actions critiques
  /// Utilisé pour : suppression, erreurs, confirmations importantes
  static Future<void> heavyImpact() async {
    if (!kIsWeb) {
      try {
        await HapticFeedback.heavyImpact();
      } catch (e) {
        debugPrint('Haptic feedback not available: $e');
      }
    }
  }

  /// Feedback de sélection pour les changements d'état
  /// Utilisé pour : basculement de thème, sélection dans une liste
  static Future<void> selectionClick() async {
    if (!kIsWeb) {
      try {
        await HapticFeedback.selectionClick();
      } catch (e) {
        debugPrint('Haptic feedback not available: $e');
      }
    }
  }

  /// Feedback personnalisé pour le swipe
  /// Combine plusieurs types selon la direction et l'intensité
  static Future<void> swipeFeedback(SwipeDirection direction, SwipeIntensity intensity) async {
    switch (intensity) {
      case SwipeIntensity.light:
        await lightImpact();
        break;
      case SwipeIntensity.medium:
        await mediumImpact();
        break;
      case SwipeIntensity.heavy:
        await heavyImpact();
        break;
    }
  }

  /// Feedback pour les transitions de page
  static Future<void> pageTransition() async {
    await lightImpact();
  }

  /// Feedback pour les erreurs
  static Future<void> error() async {
    await heavyImpact();
    // Double vibration pour les erreurs
    await Future.delayed(const Duration(milliseconds: 100));
    await mediumImpact();
  }

  /// Feedback pour les succès
  static Future<void> success() async {
    await mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await lightImpact();
  }

  /// Feedback pour le début d'une action longue (comme le tri)
  static Future<void> actionStart() async {
    await mediumImpact();
  }

  /// Feedback pour la fin d'une action longue
  static Future<void> actionComplete() async {
    await lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await lightImpact();
  }

  /// Feedback très subtil pour les micro-interactions
  static Future<void> subtle() async {
    if (!kIsWeb) {
      try {
        // Utilise la vibration la plus légère disponible
        await HapticFeedback.lightImpact();
      } catch (e) {
        debugPrint('Haptic feedback not available: $e');
      }
    }
  }

  /// Feedback pour les animations de morphing d'icônes
  static Future<void> iconMorph() async {
    await subtle();
  }

  /// Feedback pour les changements de thème
  static Future<void> themeChange() async {
    await selectionClick();
    await Future.delayed(const Duration(milliseconds: 50));
    await subtle();
  }

  /// Feedback pour l'ouverture/fermeture de modales
  static Future<void> modalToggle() async {
    await mediumImpact();
  }

  /// Feedback pour les gestes de restauration
  static Future<void> restore() async {
    await lightImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await lightImpact();
  }

  /// Feedback pour l'ajout à un album
  static Future<void> addToAlbum() async {
    await mediumImpact();
  }

  /// Feedback pour la suppression d'une photo
  static Future<void> deletePhoto() async {
    await heavyImpact();
  }

  /// Feedback pour la sauvegarde d'une photo
  static Future<void> savePhoto() async {
    await lightImpact();
    await Future.delayed(const Duration(milliseconds: 60));
    await subtle();
  }
}

/// Directions de swipe pour le feedback haptique
enum SwipeDirection {
  left,
  right,
  up,
  down,
}

/// Intensités de swipe pour le feedback haptique
enum SwipeIntensity {
  light,
  medium,
  heavy,
}

/// Extension pour faciliter l'utilisation du feedback haptique
extension HapticFeedbackExtension on Widget {
  Widget withHapticFeedback({
    required VoidCallback onTap,
    HapticFeedbackType type = HapticFeedbackType.light,
  }) {
    return GestureDetector(
      onTap: () async {
        switch (type) {
          case HapticFeedbackType.light:
            await HapticService.lightImpact();
            break;
          case HapticFeedbackType.medium:
            await HapticService.mediumImpact();
            break;
          case HapticFeedbackType.heavy:
            await HapticService.heavyImpact();
            break;
          case HapticFeedbackType.selection:
            await HapticService.selectionClick();
            break;
          case HapticFeedbackType.subtle:
            await HapticService.subtle();
            break;
        }
        onTap();
      },
      child: this,
    );
  }
}

/// Types de feedback haptique disponibles
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
  subtle,
}