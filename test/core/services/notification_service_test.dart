import 'package:flutter_test/flutter_test.dart';
import 'package:sanad_app/core/services/notification_service.dart';

void main() {
  group('NotificationService', () {
    test('can be instantiated', () {
      final service = NotificationService();
      expect(service, isNotNull);
    });

    test('onNotificationTap is a broadcast stream', () {
      final service = NotificationService();
      expect(service.onNotificationTap, isA<Stream<Map<String, dynamic>>>());
    });

    test('dispose closes stream', () {
      final service = NotificationService();
      service.dispose();
    });
  });
}
