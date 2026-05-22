import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  bool _isPlaying = false;
  String? _currentUrl;

  bool get isPlaying => _isPlaying;
  String? get currentUrl => _currentUrl;

  Future<void> play(String url) async {
    _currentUrl = url;
    _isPlaying = true;
    // TODO: Implement actual just_audio player logic here
    debugPrint('AudioService: Playing \$url');
  }

  Future<void> pause() async {
    _isPlaying = false;
    // TODO: Implement actual just_audio pause logic here
    debugPrint('AudioService: Paused');
  }

  Future<void> stop() async {
    _isPlaying = false;
    _currentUrl = null;
    // TODO: Implement actual just_audio stop logic here
    debugPrint('AudioService: Stopped');
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});
