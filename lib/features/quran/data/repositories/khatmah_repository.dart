import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/khatmah_models.dart';
import 'quran_repository.dart';

class KhatmahRepository {
  static const String _khatmahEntriesKey = 'khatmah_entries';
  static const String _khatmahProgressKey = 'khatmah_progress';
  static const String _khatmahPrefsKey = 'QuranPrefs';

  Future<List<KhatmahEntry>> loadKhatmahEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('${_khatmahPrefsKey}.${_khatmahEntriesKey}') ?? [];
    return entriesJson.map((json) => KhatmahEntry.fromJson(jsonDecode(json))).toList();
  }

  Future<KhatmahProgress> loadKhatmahProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString('${_khatmahPrefsKey}.${_khatmahProgressKey}');

    if (progressJson == null) {
      return const KhatmahProgress(
        totalAyahs: 6236,
        completedAyahs: 0,
        progressPercentage: 0.0,
        currentSurah: 'الفاتحة',
        currentAyah: 1,
        nextWird: 'من الفاتحة 1 إلى البقرة 141',
        lastUpdated: null,
      );
    }

    try {
      final progressMap = jsonDecode(progressJson) as Map<String, dynamic>;
      return KhatmahProgress.fromJson(progressMap);
    } catch (e) {
      return const KhatmahProgress(
        totalAyahs: 6236,
        completedAyahs: 0,
        progressPercentage: 0.0,
        currentSurah: 'الفاتحة',
        currentAyah: 1,
        nextWird: 'من الفاتحة 1 إلى البقرة 141',
        lastUpdated: null,
      );
    }
  }

  Future<void> addKhatmahEntry(KhatmahEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await loadKhatmahEntries();
    entries.add(entry);
    final entriesJson = entries.map((entry) => jsonEncode(entry.toJson())).toList();
    await prefs.setStringList('${_khatmahPrefsKey}.${_khatmahEntriesKey}', entriesJson);

    await _updateKhatmahProgress();
  }

  Future<void> updateKhatmahEntry(KhatmahEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await loadKhatmahEntries();
    final index = entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      entries[index] = entry;
      final entriesJson = entries.map((entry) => jsonEncode(entry.toJson())).toList();
      await prefs.setStringList('${_khatmahPrefsKey}.${_khatmahEntriesKey}', entriesJson);
      await _updateKhatmahProgress();
    }
  }

  Future<void> deleteKhatmahEntry(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await loadKhatmahEntries();
    entries.removeWhere((e) => e.id == id);
    final entriesJson = entries.map((entry) => jsonEncode(entry.toJson())).toList();
    await prefs.setStringList('${_khatmahPrefsKey}.${_khatmahEntriesKey}', entriesJson);
    await _updateKhatmahProgress();
  }

  Future<void> completeKhatmahEntry(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await loadKhatmahEntries();
    final index = entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      final entry = entries[index];
      final completedEntry = KhatmahEntry(
        id: entry.id,
        surahNumber: entry.surahNumber,
        ayahNumber: entry.ayahNumber,
        title: entry.title,
        date: entry.date,
        completed: true,
        ayahCount: entry.ayahCount,
        description: entry.description,
      );
      entries[index] = completedEntry;
      final entriesJson = entries.map((entry) => jsonEncode(entry.toJson())).toList();
      await prefs.setStringList('${_khatmahPrefsKey}.${_khatmahEntriesKey}', entriesJson);
      await _updateKhatmahProgress();
    }
  }

  Future<void> _updateKhatmahProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await loadKhatmahEntries();
    final repo = QuranRepository();

    int completedAyahs = 0;
    final List<Map<String, dynamic>> completedEntries = [];

    for (final entry in entries) {
      if (entry.completed) {
        completedAyahs += entry.ayahCount;
        completedEntries.add({
          'surahNumber': entry.surahNumber,
          'ayahNumber': entry.ayahNumber,
        });
      }
    }

    double progressPercentage = (completedAyahs / 6236) * 100;

    String currentSurah = 'الفاتحة';
    int currentAyah = 1;
    String nextWird = 'من الفاتحة 1 إلى البقرة 141';

    if (completedEntries.isNotEmpty) {
      final lastEntry = completedEntries.last;
      final surah = await repo.getSurah(lastEntry['surahNumber']);
      if (surah != null) {
        currentSurah = surah.nameArabic;
        currentAyah = lastEntry['ayahNumber'] + 1;
        if (currentAyah > surah.verses.length) {
          currentAyah = 1;
        }
      }
      nextWird = 'من ${currentSurah} ${currentAyah} إلى...';
    }

    final progress = KhatmahProgress(
      totalAyahs: 6236,
      completedAyahs: completedAyahs,
      progressPercentage: progressPercentage,
      currentSurah: currentSurah,
      currentAyah: currentAyah,
      nextWird: nextWird,
      lastUpdated: DateTime.now(),
    );

    final progressJson = jsonEncode(progress.toJson());
    await prefs.setString('${_khatmahPrefsKey}.${_khatmahProgressKey}', progressJson);
  }

  Future<void> clearAllKhatmah() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_khatmahPrefsKey}.${_khatmahEntriesKey}');
    await prefs.remove('${_khatmahPrefsKey}.${_khatmahProgressKey}');
  }

  Future<String> generateKhatmahId() async {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
