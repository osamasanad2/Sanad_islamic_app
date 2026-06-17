class Verse {
  final int number;
  final String arabic;
  final String english;
  final int juz;
  final int page;
  final bool sajda;

  const Verse({
    required this.number,
    required this.arabic,
    required this.english,
    required this.juz,
    required this.page,
    required this.sajda,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    final sajdaRaw = json['sajda'];
    final sajda = sajdaRaw is bool ? sajdaRaw : sajdaRaw != null;
    return Verse(
      number: json['number'] as int,
      arabic: json['text']['ar'] as String,
      english: json['text']['en'] as String,
      juz: json['juz'] as int,
      page: json['page'] as int,
      sajda: sajda,
    );
  }
}

class Surah {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String transliteration;
  final String revelationArabic;
  final String revelationEnglish;
  final int versesCount;
  final List<Verse> verses;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.transliteration,
    required this.revelationArabic,
    required this.revelationEnglish,
    required this.versesCount,
    required this.verses,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      nameArabic: json['name']['ar'] as String,
      nameEnglish: json['name']['en'] as String,
      transliteration: json['name']['transliteration'] as String,
      revelationArabic: json['revelation_place']['ar'] as String,
      revelationEnglish: json['revelation_place']['en'] as String,
      versesCount: json['verses_count'] as int,
      verses: (json['verses'] as List).map((v) => Verse.fromJson(v)).toList(),
    );
  }
}

class SurahIndex {
  final int id;
  final String name;
  final String transliteration;
  final String type;
  final int totalVerses;

  const SurahIndex({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.type,
    required this.totalVerses,
  });

  factory SurahIndex.fromJson(Map<String, dynamic> json) {
    return SurahIndex(
      id: json['id'] as int,
      name: json['name'] as String,
      transliteration: json['transliteration'] as String,
      type: json['type'] as String,
      totalVerses: json['total_verses'] as int,
    );
  }
}

class TafsirEntry {
  final int surah;
  final int ayah;
  final String text;

  const TafsirEntry({
    required this.surah,
    required this.ayah,
    required this.text,
  });
}

class PageInfo {
  final int pageNumber;
  final List<Verse> verses;
  final int surahStart;
  final int surahEnd;
  final int juz;

  const PageInfo({
    required this.pageNumber,
    required this.verses,
    required this.surahStart,
    required this.surahEnd,
    required this.juz,
  });
}
