import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/shared_prefs_provider.dart';
import 'asma_al_husna_model.dart';

const String _favoritesKey = 'asma_al_husna_favorites';
const String _lastNameDateKey = 'asma_al_husna_last_date';
const String _lastNameIdKey = 'asma_al_husna_last_name_id';

class AsmaAlHusnaState {
  final List<AsmaAlHusnaName> names;
  final Set<int> favoriteIds;
  final bool isLoading;
  final String? error;
  final int? nameOfTheDayId;

  const AsmaAlHusnaState({
    this.names = const [],
    this.favoriteIds = const {},
    this.isLoading = false,
    this.error,
    this.nameOfTheDayId,
  });

  AsmaAlHusnaState copyWith({
    List<AsmaAlHusnaName>? names,
    Set<int>? favoriteIds,
    bool? isLoading,
    String? error,
    int? nameOfTheDayId,
  }) {
    return AsmaAlHusnaState(
      names: names ?? this.names,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      nameOfTheDayId: nameOfTheDayId ?? this.nameOfTheDayId,
    );
  }

  List<AsmaAlHusnaName> get favorites =>
      names.where((n) => favoriteIds.contains(n.id)).toList();

  AsmaAlHusnaName? get nameOfTheDay {
    try {
      return names.firstWhere((n) => n.id == nameOfTheDayId);
    } catch (_) {
      return null;
    }
  }
}

final asmaAlHusnaProvider =
    NotifierProvider<AsmaAlHusnaNotifier, AsmaAlHusnaState>(
        AsmaAlHusnaNotifier.new);

class AsmaAlHusnaNotifier extends Notifier<AsmaAlHusnaState> {
  @override
  AsmaAlHusnaState build() {
    _loadData();
    return const AsmaAlHusnaState(isLoading: true);
  }

  Future<void> _loadData() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/asma_al_husna.json');
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      final names = jsonList
          .map((e) => AsmaAlHusnaName.fromJson(e as Map<String, dynamic>))
          .toList();

      final prefs = ref.read(sharedPrefsProvider);
      final favoriteIds = _loadFavorites(prefs);
      final nameOfTheDayId = _getNameOfTheDay(prefs, names.length);

      state = AsmaAlHusnaState(
        names: names,
        favoriteIds: favoriteIds,
        isLoading: false,
        nameOfTheDayId: nameOfTheDayId,
      );
    } catch (e) {
      state = AsmaAlHusnaState(
        isLoading: false,
        error: 'فشل تحميل الأسماء: $e',
      );
    }
  }

  Set<int> _loadFavorites(SharedPreferences prefs) {
    final stored = prefs.getStringList(_favoritesKey);
    return stored?.map(int.parse).toSet() ?? {};
  }

  int _getNameOfTheDay(SharedPreferences prefs, int totalNames) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = prefs.getString(_lastNameDateKey);
    final lastNameId = prefs.getInt(_lastNameIdKey);

    if (lastDate == today && lastNameId != null) {
      return lastNameId;
    }

    final dayOfYear = DateTime.now().difference(
          DateTime(DateTime.now().year, 1, 1),
        ).inDays;
    final nameId = (dayOfYear % totalNames) + 1;

    prefs.setString(_lastNameDateKey, today);
    prefs.setInt(_lastNameIdKey, nameId);

    return nameId;
  }

  Future<void> toggleFavorite(int nameId) async {
    final ids = Set<int>.from(state.favoriteIds);
    if (ids.contains(nameId)) {
      ids.remove(nameId);
    } else {
      ids.add(nameId);
    }
    state = state.copyWith(favoriteIds: ids);

    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setStringList(_favoritesKey, ids.map((e) => e.toString()).toList());
  }
}
