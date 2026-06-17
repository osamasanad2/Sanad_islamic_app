import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/audio_service.dart';
import '../../data/models/quran_models.dart';

class QuranAudioState {
  final bool isPlaying;
  final SurahIndex? currentSurah;
  final int currentAyah;
  final int totalAyahs;
  final String? reciter;
  final Duration position;
  final Duration duration;
  final bool isLoading;

  const QuranAudioState({
    this.isPlaying = false,
    this.currentSurah,
    this.currentAyah = 0,
    this.totalAyahs = 0,
    this.reciter,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isLoading = false,
  });

  QuranAudioState copyWith({
    bool? isPlaying,
    SurahIndex? currentSurah,
    int? currentAyah,
    int? totalAyahs,
    String? reciter,
    Duration? position,
    Duration? duration,
    bool? isLoading,
  }) {
    return QuranAudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAyah: currentAyah ?? this.currentAyah,
      totalAyahs: totalAyahs ?? this.totalAyahs,
      reciter: reciter ?? this.reciter,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final quranAudioProvider =
    NotifierProvider<QuranAudioNotifier, QuranAudioState>(
  QuranAudioNotifier.new,
);

class QuranAudioNotifier extends Notifier<QuranAudioState> {
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _playerStateSub;

  @override
  QuranAudioState build() {
    final audioService = ref.watch(audioServiceProvider);

    _positionSub = audioService.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    _durationSub = audioService.durationStream.listen((dur) {
      if (dur != null) state = state.copyWith(duration: dur);
    });

    _playerStateSub = audioService.playerStateStream.listen((pState) {
      state = state.copyWith(
        isPlaying: pState.playing,
        isLoading: pState.processingState == ProcessingState.loading,
      );
    });

    ref.onDispose(() {
      _positionSub?.cancel();
      _durationSub?.cancel();
      _playerStateSub?.cancel();
    });

    return const QuranAudioState();
  }

  static const _baseUrl = 'https://server8.mp3quran.net';
  static const _reciters = {
    'عبد الرحمن السديس': '$_baseUrl/sdss',
    'مشاري العفاسي': '$_baseUrl/afasy',
    'ماهر المعيقلي': '$_baseUrl/maher',
    'عبد الباسط عبد الصمد': '$_baseUrl/abdulbasit',
    'سعد الغامدي': '$_baseUrl/saad',
    'ياسر الدوسري': '$_baseUrl/yasser',
    'ناصر القطامي': '$_baseUrl/nasser',
  };

  Map<String, String> get availableReciters => Map.unmodifiable(_reciters);

  Future<void> playSurah(SurahIndex surah, {String? reciter}) async {
    final audioService = ref.read(audioServiceProvider);
    final r = reciter ?? state.reciter ?? _reciters.keys.first;

    state = state.copyWith(
      isLoading: true,
      currentSurah: surah,
      currentAyah: 0,
      totalAyahs: surah.totalVerses,
      reciter: r,
    );

    final baseUrl = _reciters[r]!;
    final surahNumber = surah.id.toString().padLeft(3, '0');
    final url = '$baseUrl/$surahNumber.mp3';

    await audioService.play(url, title: '${surah.name} - $r');

    state = state.copyWith(isLoading: false);
  }

  Future<void> playAyah(int surahId, int ayahNumber, {String? reciter}) async {
    final audioService = ref.read(audioServiceProvider);
    final r = reciter ?? state.reciter ?? _reciters.keys.first;
    final baseUrl = _reciters[r]!;
    final sNum = surahId.toString().padLeft(3, '0');
    final aNum = ayahNumber.toString().padLeft(3, '0');
    final url = '$baseUrl/$sNum$aNum.mp3';

    state = state.copyWith(isLoading: true, reciter: r);
    await audioService.play(url, title: 'آية $ayahNumber - سورة $surahId');
    state = state.copyWith(isLoading: false, isPlaying: true);
  }

  Future<void> togglePlayPause() async {
    final audioService = ref.read(audioServiceProvider);
    if (state.isPlaying) {
      await audioService.pause();
    } else {
      await audioService.resume();
    }
  }

  Future<void> stop() async {
    final audioService = ref.read(audioServiceProvider);
    await audioService.stop();
    state = state.copyWith(
      isPlaying: false,
      currentSurah: null,
      currentAyah: 0,
      position: Duration.zero,
      duration: Duration.zero,
    );
  }

  Future<void> seek(Duration position) async {
    final audioService = ref.read(audioServiceProvider);
    await audioService.seek(position);
  }

  Future<void> setVolume(double volume) async {
    final audioService = ref.read(audioServiceProvider);
    await audioService.setVolume(volume);
  }

  Future<void> setReciter(String reciter) async {
    if (state.currentSurah != null) {
      await playSurah(state.currentSurah!, reciter: reciter);
    } else {
      state = state.copyWith(reciter: reciter);
    }
  }

  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    ref.read(audioServiceProvider).dispose();
  }
}
