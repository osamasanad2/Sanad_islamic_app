import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../quran/data/providers/quran_provider.dart';
import '../models/daily_ayah_model.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this in main.dart');
});

final dailyAyahProvider = FutureProvider<DailyAyah?>((ref) async {
  final quranData = await ref.watch(quranDataProvider.future);
  if (quranData.isEmpty) return null;

  final prefs = ref.watch(sharedPreferencesProvider);
  final today = DateTime.now();
  final dateStr = "\${today.year}-\${today.month}-\${today.day}";

  final savedDate = prefs.getString('daily_ayah_date');
  int surahIndex;
  int verseIndex;

  if (savedDate == dateStr) {
    surahIndex = prefs.getInt('daily_ayah_surah') ?? 0;
    verseIndex = prefs.getInt('daily_ayah_verse') ?? 0;
  } else {
    // Generate new random ayah
    final random = Random();
    surahIndex = random.nextInt(quranData.length);
    final surah = quranData[surahIndex];
    verseIndex = random.nextInt(surah.verses.length);

    await prefs.setString('daily_ayah_date', dateStr);
    await prefs.setInt('daily_ayah_surah', surahIndex);
    await prefs.setInt('daily_ayah_verse', verseIndex);
  }

  // Fallback checks just in case indices are out of bounds
  if (surahIndex >= quranData.length) surahIndex = 0;
  final surah = quranData[surahIndex];
  if (verseIndex >= surah.verses.length) verseIndex = 0;
  final verse = surah.verses[verseIndex];

  return DailyAyah(
    surah: surah,
    verse: verse,
    date: today,
  );
});
