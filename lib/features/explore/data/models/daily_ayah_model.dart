import '../../../quran/data/models/surah_model.dart';

class DailyAyah {
  final Surah surah;
  final Verse verse;
  final DateTime date;

  DailyAyah({
    required this.surah,
    required this.verse,
    required this.date,
  });
}
