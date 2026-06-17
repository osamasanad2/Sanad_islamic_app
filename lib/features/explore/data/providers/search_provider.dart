import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../quran/data/providers/quran_provider.dart';

// Search Query State
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String newQuery) {
    state = newQuery;
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

// Search Results State
final searchResultsProvider = FutureProvider<List<dynamic>>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.isEmpty) return [];

  final quranData = await ref.watch(quranDataProvider.future);
  List<Map<String, dynamic>> results = [];

  // Very simple text search across the Quran
  // Normalizing arabic text is generally recommended but we'll do simple contains for now.
  for (var surah in quranData) {
    // Check if Surah name matches
    if (surah.name.ar.contains(query)) {
      results.add({'type': 'surah', 'data': surah});
      continue;
    }
    
    // Check Verses
    for (var verse in surah.verses) {
      if (verse.text.ar.contains(query)) {
        results.add({'type': 'verse', 'surah': surah, 'data': verse});
        // Limit results to avoid massive lists
        if (results.length > 50) return results;
      }
    }
  }

  // Future: Add search for Hadith, Articles, etc. here

  return results;
});
