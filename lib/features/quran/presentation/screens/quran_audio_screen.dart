import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/audio_provider.dart';
import '../providers/quran_providers.dart';
import '../../data/models/quran_models.dart';

class QuranAudioScreen extends ConsumerStatefulWidget {
  const QuranAudioScreen({super.key});

  @override
  ConsumerState<QuranAudioScreen> createState() => _QuranAudioScreenState();
}

class _QuranAudioScreenState extends ConsumerState<QuranAudioScreen> {
  List<SurahIndex> _surahs = [];

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    final repo = ref.read(quranRepositoryProvider);
    final surahs = await repo.loadSurahIndices();
    setState(() => _surahs = surahs);
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(quranAudioProvider);
    final audioNotifier = ref.read(quranAudioProvider.notifier);

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('استماع القرآن'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildReciterSelector(audioState),
          ),
          if (audioState.currentSurah != null) _buildNowPlaying(audioState, audioNotifier),
          Expanded(
            child: _surahs.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _surahs.length,
                    itemBuilder: (context, index) {
                      final surah = _surahs[index];
                      final isActive = audioState.currentSurah?.id == surah.id;
                      return _buildSurahTile(surah, isActive, audioNotifier);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReciterSelector(QuranAudioState audioState) {
    final notifier = ref.read(quranAudioProvider.notifier);
    final reciters = notifier.availableReciters;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: audioState.reciter ?? reciters.keys.first,
          items: reciters.keys.map((name) {
            return DropdownMenuItem(value: name, child: Text(name));
          }).toList(),
          onChanged: (value) {
            if (value != null) notifier.setReciter(value);
          },
        ),
      ),
    );
  }

  Widget _buildNowPlaying(QuranAudioState state, QuranAudioNotifier notifier) {
    final duration = state.duration;
    final position = state.position;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            state.currentSurah?.name ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.reciter ?? '',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldLight),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                    onPressed: null,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.primary,
                      ),
                      onPressed: () => notifier.togglePlayPause(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Colors.white),
                    onPressed: null,
                  ),
                ],
              ),
              Text(
                '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
              ),
            ],
          ),
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildSurahTile(
      SurahIndex surah, bool isActive, QuranAudioNotifier notifier) {
    final isMeccan = surah.type == 'meccan';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withValues(alpha: 0.08) : context.appColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => notifier.playSurah(surah),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? const LinearGradient(colors: [AppColors.gold, AppColors.goldLight])
                        : const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isActive ? Icons.play_arrow : Icons.music_note,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(surah.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.appColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${surah.transliteration} - ${isMeccan ? "مكية" : "مدنية"} - ${surah.totalVerses} آية',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.appColors.textSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('قيد التشغيل',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
