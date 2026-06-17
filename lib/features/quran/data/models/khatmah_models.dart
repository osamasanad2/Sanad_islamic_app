class KhatmahEntry {
  final String id;
  final int surahNumber;
  final int ayahNumber;
  final String title;
  final DateTime date;
  final bool completed;
  final int ayahCount;
  final String? description;

  const KhatmahEntry({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.title,
    required this.date,
    required this.completed,
    required this.ayahCount,
    this.description,
  });

  factory KhatmahEntry.fromJson(Map<String, dynamic> json) {
    return KhatmahEntry(
      id: json['id'] as String,
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      completed: json['completed'] as bool,
      ayahCount: json['ayahCount'] as int,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'title': title,
      'date': date.toIso8601String(),
      'completed': completed,
      'ayahCount': ayahCount,
      'description': description,
    };
  }
}

class KhatmahProgress {
  final int totalAyahs;
  final int completedAyahs;
  final double progressPercentage;
  final String currentSurah;
  final int currentAyah;
  final String nextWird;
  final DateTime? lastUpdated;

  const KhatmahProgress({
    required this.totalAyahs,
    required this.completedAyahs,
    required this.progressPercentage,
    required this.currentSurah,
    required this.currentAyah,
    required this.nextWird,
    this.lastUpdated,
  });

  factory KhatmahProgress.fromJson(Map<String, dynamic> json) {
    return KhatmahProgress(
      totalAyahs: json['totalAyahs'] as int,
      completedAyahs: json['completedAyahs'] as int,
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      currentSurah: json['currentSurah'] as String,
      currentAyah: json['currentAyah'] as int,
      nextWird: json['nextWird'] as String,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAyahs': totalAyahs,
      'completedAyahs': completedAyahs,
      'progressPercentage': progressPercentage,
      'currentSurah': currentSurah,
      'currentAyah': currentAyah,
      'nextWird': nextWird,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }
}
