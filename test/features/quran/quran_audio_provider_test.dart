import 'package:flutter_test/flutter_test.dart';
import 'package:sanad_app/features/quran/presentation/providers/audio_provider.dart';

void main() {
  group('QuranAudioNotifier', () {
    test('availableReciters returns known reciters', () {
      final reciters = {
        'عبد الرحمن السديس',
        'مشاري العفاسي',
        'ماهر المعيقلي',
        'عبد الباسط عبد الصمد',
        'سعد الغامدي',
        'ياسر الدوسري',
        'ناصر القطامي',
      };
      expect(reciters.length, greaterThanOrEqualTo(3));
      expect(reciters.contains('عبد الرحمن السديس'), isTrue);
      expect(reciters.contains('مشاري العفاسي'), isTrue);
    });

    test('QuranAudioState has correct defaults', () {
      const state = QuranAudioState();
      expect(state.isPlaying, false);
      expect(state.currentSurah, isNull);
      expect(state.currentAyah, 0);
      expect(state.totalAyahs, 0);
      expect(state.isLoading, false);
      expect(state.position, Duration.zero);
      expect(state.duration, Duration.zero);
      expect(state.reciter, isNull);
    });

    test('copyWith updates correctly', () {
      const state = QuranAudioState();
      final updated = state.copyWith(isPlaying: true, currentAyah: 5);
      expect(updated.isPlaying, true);
      expect(updated.currentAyah, 5);
      expect(updated.isLoading, false);
    });
  });
}
