// Tests unitaires pour les services de feedback
import 'package:flutter_test/flutter_test.dart';
import 'package:swipewipe/core/services/feedback_service.dart';

void main() {
  group('FeedbackService Tests', () {
    test('FeedbackService.isAvailable should return correct value', () {
      // Sur les tests, kIsWeb est false, donc isAvailable devrait être true
      expect(FeedbackService.isAvailable, isTrue);
    });

    test('FeedbackService methods should not throw exceptions', () async {
      // Tester que les méthodes de base ne lancent pas d'exceptions
      expect(() async => await FeedbackService.light(), returnsNormally);
      expect(() async => await FeedbackService.medium(), returnsNormally);
      expect(() async => await FeedbackService.heavy(), returnsNormally);
      expect(() async => await FeedbackService.selection(), returnsNormally);
    });
  });

  group('InteractionFeedbackService Tests', () {
    test('InteractionFeedbackService methods should not throw exceptions', () async {
      expect(() async => await InteractionFeedbackService.buttonTap(), returnsNormally);
      expect(() async => await InteractionFeedbackService.itemSelection(), returnsNormally);
      expect(() async => await InteractionFeedbackService.importantAction(), returnsNormally);
      expect(() async => await InteractionFeedbackService.criticalAction(), returnsNormally);
    });
  });

  group('AnimationFeedbackService Tests', () {
    test('AnimationFeedbackService methods should not throw exceptions', () async {
      expect(() async => await AnimationFeedbackService.pageTransition(), returnsNormally);
      expect(() async => await AnimationFeedbackService.themeChange(), returnsNormally);
      expect(() async => await AnimationFeedbackService.morphing(), returnsNormally);
      expect(() async => await AnimationFeedbackService.modalToggle(), returnsNormally);
    });
  });

  group('SwipeFeedbackService Tests', () {
    test('SwipeFeedbackService.swipe should handle all intensities', () async {
      expect(() async => await SwipeFeedbackService.swipe(SwipeIntensity.light), returnsNormally);
      expect(() async => await SwipeFeedbackService.swipe(SwipeIntensity.medium), returnsNormally);
      expect(() async => await SwipeFeedbackService.swipe(SwipeIntensity.heavy), returnsNormally);
    });

    test('SwipeFeedbackService sort methods should not throw exceptions', () async {
      expect(() async => await SwipeFeedbackService.sortStart(), returnsNormally);
      expect(() async => await SwipeFeedbackService.sortComplete(), returnsNormally);
    });
  });

  group('PhotoFeedbackService Tests', () {
    test('PhotoFeedbackService methods should not throw exceptions', () async {
      expect(() async => await PhotoFeedbackService.addToAlbum(), returnsNormally);
      expect(() async => await PhotoFeedbackService.deletePhoto(), returnsNormally);
      expect(() async => await PhotoFeedbackService.savePhoto(), returnsNormally);
      expect(() async => await PhotoFeedbackService.restorePhoto(), returnsNormally);
    });
  });

  group('SystemFeedbackService Tests', () {
    test('SystemFeedbackService methods should not throw exceptions', () async {
      expect(() async => await SystemFeedbackService.error(), returnsNormally);
      expect(() async => await SystemFeedbackService.success(), returnsNormally);
      expect(() async => await SystemFeedbackService.warning(), returnsNormally);
    });
  });

  group('SwipeIntensity Enum Tests', () {
    test('SwipeIntensity should have all expected values', () {
      expect(SwipeIntensity.values.length, equals(3));
      expect(SwipeIntensity.values, contains(SwipeIntensity.light));
      expect(SwipeIntensity.values, contains(SwipeIntensity.medium));
      expect(SwipeIntensity.values, contains(SwipeIntensity.heavy));
    });
  });
}