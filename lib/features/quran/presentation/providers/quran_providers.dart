import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/quran_repository.dart';
import '../../data/models/quran_models.dart';

final quranRepositoryProvider = Provider<QuranRepository>(
  (ref) => QuranRepository(),
);

final surahListProvider = FutureProvider<List<SurahIndex>>((ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.loadSurahIndices();
});

final surahProvider = FutureProvider.family<Surah?, int>((
  ref,
  surahNumber,
) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getSurah(surahNumber);
});

final pagesProvider = FutureProvider<Map<int, PageInfo>>((ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.loadPages();
});

final pageVersesProvider = FutureProvider.family<List<Verse>, int>((
  ref,
  pageNumber,
) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getVersesByPage(pageNumber);
});

final searchResultsProvider = FutureProvider.family<List<Verse>, String>((
  ref,
  query,
) async {
  if (query.trim().isEmpty) return [];
  final repo = ref.watch(quranRepositoryProvider);
  return repo.searchAyahs(query);
});
