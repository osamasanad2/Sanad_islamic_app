import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/surah_model.dart';

// Provider that loads and holds all the surahs
final quranDataProvider = FutureProvider<List<Surah>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/data/ayat.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => Surah.fromJson(json)).toList();
});

class SelectedSurahIndex extends Notifier<int> {
  @override
  int build() => 1; // Defaults to Al-Fatihah

  void setSurah(int index) {
    state = index;
  }
}

// Provider for tracking the currently selected Surah index (1-indexed based on Surah number)
final selectedSurahIndexProvider = NotifierProvider<SelectedSurahIndex, int>(SelectedSurahIndex.new);
