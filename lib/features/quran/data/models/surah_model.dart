class TranslatedText {
  final String ar;
  final String en;
  final String? transliteration;

  TranslatedText({
    required this.ar,
    required this.en,
    this.transliteration,
  });

  factory TranslatedText.fromJson(Map<String, dynamic> json) {
    return TranslatedText(
      ar: json['ar'] ?? '',
      en: json['en'] ?? '',
      transliteration: json['transliteration'],
    );
  }
}

class Verse {
  final int number;
  final TranslatedText text;
  final int juz;
  final int page;
  final dynamic sajda;

  Verse({
    required this.number,
    required this.text,
    required this.juz,
    required this.page,
    required this.sajda,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number: json['number'] ?? 0,
      text: TranslatedText.fromJson(json['text'] ?? {}),
      juz: json['juz'] ?? 0,
      page: json['page'] ?? 0,
      sajda: json['sajda'] ?? false,
    );
  }
}

class Surah {
  final int number;
  final TranslatedText name;
  final TranslatedText revelationPlace;
  final int versesCount;
  final List<Verse> verses;

  Surah({
    required this.number,
    required this.name,
    required this.revelationPlace,
    required this.versesCount,
    required this.verses,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    var versesList = json['verses'] as List? ?? [];
    return Surah(
      number: json['number'] ?? 0,
      name: TranslatedText.fromJson(json['name'] ?? {}),
      revelationPlace: TranslatedText.fromJson(json['revelation_place'] ?? {}),
      versesCount: json['verses_count'] ?? 0,
      verses: versesList.map((v) => Verse.fromJson(v)).toList(),
    );
  }
}
