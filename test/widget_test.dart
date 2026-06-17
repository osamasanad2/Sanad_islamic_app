import 'package:flutter_test/flutter_test.dart';
import 'package:sanad_app/core/services/database_service.dart';
import 'package:sanad_app/core/services/firebase_service.dart';
import 'package:sanad_app/features/prayer_times/data/prayer_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App Core', () {
    test('DatabaseService is singleton', () {
      final db1 = DatabaseService();
      final db2 = DatabaseService();
      expect(identical(db1, db2), isTrue);
    });

    test('FirebaseService is singleton', () {
      final fs1 = FirebaseService();
      final fs2 = FirebaseService();
      expect(identical(fs1, fs2), isTrue);
    });

    test('PrayerState copyWith works correctly', () {
      final state = PrayerState(
        isLoading: true,
        hijriDate: '1 محرم 1446',
      );

      final updated = state.copyWith(isLoading: false, locationName: 'مكة');
      expect(updated.isLoading, false);
      expect(updated.locationName, 'مكة');
      expect(updated.hijriDate, '1 محرم 1446');
    });

    test('PrayerState initial values are correct', () {
      final state = PrayerState();
      expect(state.isLoading, true);
      expect(state.error, isNull);
      expect(state.prayerTimes, isNull);
      expect(state.nextPrayer, isNull);
      expect(state.timeUntilNextPrayer, isNull);
      expect(state.hijriDate, '');
      expect(state.locationName, 'تحديد الموقع...');
    });
  });
}
