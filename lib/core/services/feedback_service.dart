// Flutter imports
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service de base pour le feedback haptique
/// Gère les vibrations de base et la détection de plateforme
abstract class FeedbackService {
  /// Vérifie si le feedback haptique est disponible sur la plateforme
  static bool get isAvailable => !kIsWeb;

  /// Exécute un feedback haptique avec gestion d'erreur
  static Future<void> _executeFeedback(Future<void> Function() feedbackFunction) async {
    if (!isAvailable) return;
    
    try {
      await feedbackFunction();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Feedback haptique non disponible: $e');
      }
    }
  }

  /// Feedback léger
  static Future<void> light() async {
    await _executeFeedback(() => HapticFeedback.lightImpact());
  }

  /// Feedback moyen
  static Future<void> medium() async {
    await _executeFeedback(() => HapticFeedback.mediumImpact());
  }

  /// Feedback fort
  static Future<void> heavy() async {
    await _executeFeedback(() => HapticFeedback.heavyImpact());
  }

  /// Feedback de sélection
  static Future<void> selection() async {
    await _executeFeedback(() => HapticFeedback.selectionClick());
  }
}

/// Service spécialisé pour les interactions utilisateur
class InteractionFeedbackService extends FeedbackService {
  /// Feedback pour les taps sur boutons
  static Future<void> buttonTap() async {
    await FeedbackService.light();
  }

  /// Feedback pour les sélections d'éléments
  static Future<void> itemSelection() async {
    await FeedbackService.selection();
  }

  /// Feedback pour les actions importantes
  static Future<void> importantAction() async {
    await FeedbackService.medium();
  }

  /// Feedback pour les actions critiques
  static Future<void> criticalAction() async {
    await FeedbackService.heavy();
  }
}

/// Service spécialisé pour les animations et transitions
class AnimationFeedbackService extends FeedbackService {
  /// Feedback pour les transitions de page
  static Future<void> pageTransition() async {
    await FeedbackService.light();
  }

  /// Feedback pour les changements de thème
  static Future<void> themeChange() async {
    await FeedbackService.selection();
    await Future.delayed(const Duration(milliseconds: 50));
    await FeedbackService.light();
  }

  /// Feedback pour les animations de morphing
  static Future<void> morphing() async {
    await FeedbackService.light();
  }

  /// Feedback pour l'ouverture/fermeture de modales
  static Future<void> modalToggle() async {
    await FeedbackService.medium();
  }
}

/// Service spécialisé pour les gestes de swipe
class SwipeFeedbackService extends FeedbackService {
  /// Feedback pour les swipes selon l'intensité
  static Future<void> swipe(SwipeIntensity intensity) async {
    switch (intensity) {
      case SwipeIntensity.light:
        await FeedbackService.light();
        break;
      case SwipeIntensity.medium:
        await FeedbackService.medium();
        break;
      case SwipeIntensity.heavy:
        await FeedbackService.heavy();
        break;
    }
  }

  /// Feedback pour le début d'une action de tri
  static Future<void> sortStart() async {
    await FeedbackService.medium();
  }

  /// Feedback pour la fin d'une action de tri
  static Future<void> sortComplete() async {
    await FeedbackService.light();
    await Future.delayed(const Duration(milliseconds: 100));
    await FeedbackService.light();
  }
}

/// Service spécialisé pour les actions sur les photos
class PhotoFeedbackService extends FeedbackService {
  /// Feedback pour l'ajout à un album
  static Future<void> addToAlbum() async {
    await FeedbackService.medium();
  }

  /// Feedback pour la suppression d'une photo
  static Future<void> deletePhoto() async {
    await FeedbackService.heavy();
  }

  /// Feedback pour la sauvegarde d'une photo
  static Future<void> savePhoto() async {
    await FeedbackService.light();
    await Future.delayed(const Duration(milliseconds: 60));
    await FeedbackService.light();
  }

  /// Feedback pour la restauration d'une photo
  static Future<void> restorePhoto() async {
    await FeedbackService.light();
    await Future.delayed(const Duration(milliseconds: 80));
    await FeedbackService.light();
  }
}

/// Service spécialisé pour les notifications système
class SystemFeedbackService extends FeedbackService {
  /// Feedback pour les erreurs
  static Future<void> error() async {
    await FeedbackService.heavy();
    await Future.delayed(const Duration(milliseconds: 100));
    await FeedbackService.medium();
  }

  /// Feedback pour les succès
  static Future<void> success() async {
    await FeedbackService.medium();
    await Future.delayed(const Duration(milliseconds: 50));
    await FeedbackService.light();
  }

  /// Feedback pour les avertissements
  static Future<void> warning() async {
    await FeedbackService.medium();
  }
}

/// Intensités de swipe disponibles
enum SwipeIntensity {
  light,
  medium,
  heavy,
}