import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quran_models.dart';

class QuranRepository {
  List<Surah>? _surahs;
  List<SurahIndex>? _surahIndices;
  Map<int, PageInfo>? _pages;
  List<int>? _sortedPages;

  Future<List<Surah>> loadSurahs() async {
    if (_surahs != null) return _surahs!;
    final data = await rootBundle.loadString('assets/data/ayat.json');
    final List<dynamic> jsonList = json.decode(data);
    _surahs = jsonList.map((j) => Surah.fromJson(j)).toList();
    return _surahs!;
  }

  Future<List<SurahIndex>> loadSurahIndices() async {
    if (_surahIndices != null) return _surahIndices!;
    final data = await rootBundle.loadString('assets/data/index.json');
    final List<dynamic> jsonList = json.decode(data);
    _surahIndices = jsonList.map((j) => SurahIndex.fromJson(j)).toList();
    return _surahIndices!;
  }

  Future<Map<int, PageInfo>> loadPages() async {
    if (_pages != null) return _pages!;
    final surahs = await loadSurahs();
    final pageMap = <int, List<Verse>>{};
    final pageSurahs = <int, Set<int>>{};
    final pageJuz = <int, int>{};

    for (final surah in surahs) {
      for (final verse in surah.verses) {
        pageMap.putIfAbsent(verse.page, () => []).add(verse);
        pageSurahs.putIfAbsent(verse.page, () => {}).add(surah.number);
        pageJuz.putIfAbsent(verse.page, () => verse.juz);
      }
    }

    _pages = {};
    for (final entry in pageMap.entries) {
      final surahsOnPage = pageSurahs[entry.key]!;
      _pages![entry.key] = PageInfo(
        pageNumber: entry.key,
        verses: entry.value,
        surahStart: surahsOnPage.first,
        surahEnd: surahsOnPage.last,
        juz: pageJuz[entry.key]!,
      );
    }

    _sortedPages = _pages!.keys.toList()..sort();
    return _pages!;
  }

  Future<List<int>> getSortedPages() async {
    await loadPages();
    return _sortedPages!;
  }

  Future<Surah?> getSurah(int number) async {
    final surahs = await loadSurahs();
    return surahs.firstWhere((s) => s.number == number);
  }

  Future<List<Verse>> getVersesByPage(int page) async {
    final pages = await loadPages();
    return pages[page]?.verses ?? [];
  }

  Future<Verse?> findVerse(int surahNumber, int ayahNumber) async {
    final surah = await getSurah(surahNumber);
    if (surah == null) return null;
    return surah.verses.firstWhere((v) => v.number == ayahNumber);
  }

  Future<List<Verse>> searchAyahs(String query) async {
    final surahs = await loadSurahs();
    final results = <Verse>[];
    final normalizedQuery = _normalizeArabic(query);

    for (final surah in surahs) {
      for (final verse in surah.verses) {
        if (_normalizeArabic(verse.arabic).contains(normalizedQuery) ||
            verse.english.toLowerCase().contains(query.toLowerCase())) {
          results.add(verse);
        }
      }
    }
    return results;
  }

  String _normalizeArabic(String text) {
    return text
        .replaceAll('آ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ة', 'ه')
        .replaceAll(RegExp(r'[ًٌٍٍَُِّْ]'), '');
  }

  int getSurahNumberForVerse(int page, int verseIndex) {
    if (_surahs == null) return 1;
    int cumulative = 0;
    for (final surah in _surahs!) {
      cumulative += surah.verses.length;
      if (verseIndex < cumulative) return surah.number;
    }
    return 1;
  }

  void clearCache() {
    _surahs = null;
    _surahIndices = null;
    _pages = null;
    _sortedPages = null;
  }
}
