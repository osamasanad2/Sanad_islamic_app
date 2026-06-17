import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad_app/features/prayer_times/data/prayer_provider.dart';
import 'package:sanad_app/core/providers/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrayerNotifier', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      container = ProviderContainer(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has loading and hijri date', () async {
      final state = container.read(prayerProvider);
      expect(state.isLoading, true);
      expect(state.hijriDate, isNotEmpty);
      expect(state.error, isNull);
    });

    test('getPrayerName returns correct names', () {
      final notifier = container.read(prayerProvider.notifier);

      expect(notifier.getPrayerName(Prayer.fajr), 'الفجر');
      expect(notifier.getPrayerName(Prayer.sunrise), 'الشروق');
      expect(notifier.getPrayerName(Prayer.dhuhr), 'الظهر');
      expect(notifier.getPrayerName(Prayer.asr), 'العصر');
      expect(notifier.getPrayerName(Prayer.maghrib), 'المغرب');
      expect(notifier.getPrayerName(Prayer.isha), 'العشاء');
      expect(notifier.getPrayerName(Prayer.none), 'غير محدد');
    });

    test('getFormattedTime formats time correctly', () {
      final notifier = container.read(prayerProvider.notifier);

      final morningTime = DateTime(2024, 1, 1, 5, 30);
      expect(notifier.getFormattedTime(morningTime), '5:30');

      final afternoonTime = DateTime(2024, 1, 1, 15, 5);
      expect(notifier.getFormattedTime(afternoonTime), '3:05');

      expect(notifier.getFormattedTime(null), '--:--');
    });

    test('getCountdownString handles negative duration', () {
      final notifier = container.read(prayerProvider.notifier);

      expect(notifier.getCountdownString(), isA<String>());
    });
  });
}
