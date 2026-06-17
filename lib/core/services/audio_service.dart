import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AudioPlaybackState { idle, loading, playing, paused, completed, error }

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;
  String? _currentTitle;
  LoopMode _loopMode = LoopMode.off;
  double _volume = 1.0;
  List<AudioSource>? _playlist;

  AudioService() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _currentUrl = null;
      }
    });
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<LoopMode> get loopModeStream => _player.loopModeStream;
  Stream<double> get volumeStream => _player.volumeStream;
  Stream<int?> get currentIndexStream => _player.currentIndexStream;

  bool get isPlaying => _player.playing;
  String? get currentUrl => _currentUrl;
  String? get currentTitle => _currentTitle;
  LoopMode get loopMode => _loopMode;
  double get volume => _volume;
  Duration? get position => _player.position;
  Duration? get duration => _player.duration;
  AudioPlaybackState get playbackState {
    final state = _player.playerState;
    if (state.processingState == ProcessingState.loading) {
      return AudioPlaybackState.loading;
    }
    if (state.processingState == ProcessingState.idle && state.playing == false && _currentUrl != null) {
      return AudioPlaybackState.error;
    }
    if (state.playing) return AudioPlaybackState.playing;
    if (state.processingState == ProcessingState.completed) {
      return AudioPlaybackState.completed;
    }
    if (_currentUrl != null) return AudioPlaybackState.paused;
    return AudioPlaybackState.idle;
  }

  Future<void> play(String url, {String? title}) async {
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      await _player.play();
      _currentUrl = url;
      _currentTitle = title;
      _playlist = null;
    } catch (e) {
      _currentUrl = null;
      _currentTitle = null;
    }
  }

  Future<void> playPlaylist(List<String> urls, {int startIndex = 0}) async {
    try {
      _playlist = urls.map((u) => AudioSource.uri(Uri.parse(u))).toList();
      await _player.setAudioSource(
        ConcatenatingAudioSource(children: _playlist!),
        initialIndex: startIndex,
      );
      await _player.play();
      _currentUrl = urls[startIndex];
    } catch (e) {
      _playlist = null;
      _currentUrl = null;
    }
  }

  Future<void> playLocal(String assetPath, {String? title}) async {
    try {
      await _player.setAudioSource(AudioSource.asset(assetPath));
      await _player.play();
      _currentUrl = assetPath;
      _currentTitle = title;
    } catch (e) {
      _currentUrl = null;
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (_) {}
  }

  Future<void> resume() async {
    try {
      await _player.play();
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
    _currentUrl = null;
    _currentTitle = null;
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (_) {}
  }

  Future<void> next() async {
    try {
      await _player.seekToNext();
    } catch (_) {}
  }

  Future<void> previous() async {
    try {
      await _player.seekToPrevious();
    } catch (_) {}
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
  }

  Future<void> toggleLoopMode() async {
    switch (_loopMode) {
      case LoopMode.off:
        _loopMode = LoopMode.one;
        await _player.setLoopMode(LoopMode.one);
      case LoopMode.one:
        _loopMode = LoopMode.all;
        await _player.setLoopMode(LoopMode.all);
      case LoopMode.all:
        _loopMode = LoopMode.off;
        await _player.setLoopMode(LoopMode.off);
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  void dispose() {
    _player.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});
