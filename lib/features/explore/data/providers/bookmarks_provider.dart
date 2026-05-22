import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'daily_ayah_provider.dart';

class BookmarksNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    // Load initial from shared prefs
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getStringList('bookmarked_ayahs') ?? [];
  }

  void toggleBookmark(String ayahId) {
    final prefs = ref.read(sharedPreferencesProvider);
    final currentState = state;
    
    if (currentState.contains(ayahId)) {
      state = currentState.where((id) => id != ayahId).toList();
    } else {
      state = [...currentState, ayahId];
    }
    
    prefs.setStringList('bookmarked_ayahs', state);
  }
  
  bool isBookmarked(String ayahId) {
    return state.contains(ayahId);
  }
}

final bookmarksProvider = NotifierProvider<BookmarksNotifier, List<String>>(BookmarksNotifier.new);
