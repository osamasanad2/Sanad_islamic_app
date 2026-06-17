import 'package:flutter_test/flutter_test.dart';
import 'package:sanad_app/core/services/firebase_service.dart';

void main() {
  group('FirebaseService', () {
    late FirebaseService firebaseService;

    setUp(() {
      firebaseService = FirebaseService();
    });

    test('is singleton', () {
      final instance1 = FirebaseService();
      final instance2 = FirebaseService();
      expect(identical(instance1, instance2), isTrue);
    });

    test('initial state is not initialized', () {
      expect(firebaseService.isInitialized, false);
      expect(firebaseService.analytics, isNull);
      expect(firebaseService.crashlytics, isNull);
    });

    test('logEvent does not throw when not initialized', () async {
      await firebaseService.logEvent('test_event');
    });

    test('initialize can be called multiple times safely', () async {
      await firebaseService.initialize();
      await firebaseService.initialize();
    });
  });
}
