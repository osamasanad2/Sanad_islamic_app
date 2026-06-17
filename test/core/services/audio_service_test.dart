import 'package:flutter_test/flutter_test.dart';
import 'package:sanad_app/core/services/audio_service.dart';

void main() {
  group('AudioService', () {
    late AudioService audioService;

    setUp(() {
      audioService = AudioService();
    });

    tearDown(() {
      audioService.dispose();
    });

    test('initial state is idle', () {
      expect(audioService.isPlaying, false);
      expect(audioService.currentUrl, isNull);
    });

    test('stop clears current url', () async {
      await audioService.stop();
      expect(audioService.currentUrl, isNull);
    });
  });
}
