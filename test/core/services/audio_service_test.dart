import 'package:flutter_test/flutter_test.dart';
import 'package:sanad_app/core/services/audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioPlaybackState', () {
    test('has all expected values', () {
      expect(AudioPlaybackState.idle, isA<AudioPlaybackState>());
      expect(AudioPlaybackState.loading, isA<AudioPlaybackState>());
      expect(AudioPlaybackState.playing, isA<AudioPlaybackState>());
      expect(AudioPlaybackState.paused, isA<AudioPlaybackState>());
      expect(AudioPlaybackState.completed, isA<AudioPlaybackState>());
      expect(AudioPlaybackState.error, isA<AudioPlaybackState>());
    });
  });

  group('AudioServiceProvider', () {
    test('audioServiceProvider is defined', () {
      expect(audioServiceProvider, isNotNull);
    });
  });
}
