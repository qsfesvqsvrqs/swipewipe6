// Flutter imports
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Core services
import 'feedback_service.dart';

/// Service de gestion du feedback haptique (Legacy)
/// @deprecated Utilisez les services spécialisés : InteractionFeedbackService, 
/// AnimationFeedbackService, SwipeFeedbackService, PhotoFeedbackService, SystemFeedbackService
/// 
/// Ce service est maintenu pour la compatibilité ascendante
class HapticService {
  static const HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  const HapticService._internal();

  /// @deprecated Utilisez InteractionFeedbackService.buttonTap()
  static Future<void> lightImpact() async {
    await InteractionFeedbackService.buttonTap();
  }

  /// @deprecated Utilisez InteractionFeedbackService.importantAction()
  static Future<void> mediumImpact() async {
    await InteractionFeedbackService.importantAction();
  }

  /// @deprecated Utilisez InteractionFeedbackService.criticalAction()
  static Future<void> heavyImpact() async {
    await InteractionFeedbackService.criticalAction();
  }

  /// @deprecated Utilisez InteractionFeedbackService.itemSelection()
  static Future<void> selectionClick() async {
    await InteractionFeedbackService.itemSelection();
  }

  /// @deprecated Utilisez SwipeFeedbackService.swipe()
  static Future<void> swipeFeedback(SwipeDirection direction, SwipeIntensity intensity) async {
    await SwipeFeedbackService.swipe(intensity);
  }

  /// @deprecated Utilisez AnimationFeedbackService.pageTransition()
  static Future<void> pageTransition() async {
    await AnimationFeedbackService.pageTransition();
  }

  /// @deprecated Utilisez SystemFeedbackService.error()
  static Future<void> error() async {
    await SystemFeedbackService.error();
  }

  /// @deprecated Utilisez SystemFeedbackService.success()
  static Future<void> success() async {
    await SystemFeedbackService.success();
  }

  /// @deprecated Utilisez SwipeFeedbackService.sortStart()
  static Future<void> actionStart() async {
    await SwipeFeedbackService.sortStart();
  }

  /// @deprecated Utilisez SwipeFeedbackService.sortComplete()
  static Future<void> actionComplete() async {
    await SwipeFeedbackService.sortComplete();
  }

  /// @deprecated Utilisez InteractionFeedbackService.buttonTap()
  static Future<void> subtle() async {
    await InteractionFeedbackService.buttonTap();
  }

  /// @deprecated Utilisez AnimationFeedbackService.morphing()
  static Future<void> iconMorph() async {
    await AnimationFeedbackService.morphing();
  }

  /// @deprecated Utilisez AnimationFeedbackService.themeChange()
  static Future<void> themeChange() async {
    await AnimationFeedbackService.themeChange();
  }

  /// @deprecated Utilisez AnimationFeedbackService.modalToggle()
  static Future<void> modalToggle() async {
    await AnimationFeedbackService.modalToggle();
  }

  /// @deprecated Utilisez PhotoFeedbackService.restorePhoto()
  static Future<void> restore() async {
    await PhotoFeedbackService.restorePhoto();
  }

  /// @deprecated Utilisez PhotoFeedbackService.addToAlbum()
  static Future<void> addToAlbum() async {
    await PhotoFeedbackService.addToAlbum();
  }

  /// @deprecated Utilisez PhotoFeedbackService.deletePhoto()
  static Future<void> deletePhoto() async {
    await PhotoFeedbackService.deletePhoto();
  }

  /// @deprecated Utilisez PhotoFeedbackService.savePhoto()
  static Future<void> savePhoto() async {
    await PhotoFeedbackService.savePhoto();
  }
}

/// Directions de swipe pour le feedback haptique
/// @deprecated Utilisez SwipeDirection dans feedback_service.dart
enum SwipeDirection {
  left,
  right,
  up,
  down,
}

/// Intensités de swipe pour le feedback haptique
/// @deprecated Utilisez SwipeIntensity dans feedback_service.dart
enum SwipeIntensity {
  light,
  medium,
  heavy,
}