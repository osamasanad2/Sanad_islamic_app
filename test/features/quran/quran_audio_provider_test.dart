import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad_app/features/quran/presentation/providers/audio_provider.dart';

void main() {
  group('QuranAudioNotifier', () {
    test('availableReciters returns list of reciters', () {
      final container = ProviderContainer();
      addTearDown(() => container.dispose());

      final notifier = container.read(quranAudioProvider.notifier);
      final reciters = notifier.availableReciters;

      expect(reciters, isNotEmpty);
      expect(reciters.keys, contains('عبد الرحمن السديس'));
      expect(reciters.keys, contains('مشاري العفاسي'));
      expect(reciters.length, greaterThanOrEqualTo(3));
    });
  });
}
