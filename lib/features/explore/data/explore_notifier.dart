import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'explore_data.dart';

final exploreProvider =
    NotifierProvider<ExploreNotifier, ExploreState>(ExploreNotifier.new);

class ExploreState {
  final ExploreContent? currentContent;
  final ContentType? currentContentType;
  final int factIndex;
  final HadithItem? featuredHadith;
  final bool isLoading;

  const ExploreState({
    this.currentContent,
    this.currentContentType,
    this.factIndex = 0,
    this.featuredHadith,
    this.isLoading = true,
  });

  ExploreState copyWith({
    ExploreContent? currentContent,
    ContentType? currentContentType,
    int? factIndex,
    HadithItem? featuredHadith,
    bool? isLoading,
  }) {
    return ExploreState(
      currentContent: currentContent ?? this.currentContent,
      currentContentType: currentContentType ?? this.currentContentType,
      factIndex: factIndex ?? this.factIndex,
      featuredHadith: featuredHadith ?? this.featuredHadith,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ExploreNotifier extends Notifier<ExploreState> {
  @override
  ExploreState build() {
    _generateDailyContent();
    return state;
  }

  void _generateDailyContent() {
    final seed = DateTime.now().day + DateTime.now().month * 31;
    final rng = Random(seed);

    final content = _pickRandomContent(rng);
    final factIdx = rng.nextInt(factsData.length);
    final hadith = hadithData[rng.nextInt(hadithData.length)];

    state = ExploreState(
      currentContent: content,
      currentContentType: content.type,
      factIndex: factIdx,
      featuredHadith: hadith,
      isLoading: false,
    );
  }

  ExploreContent _pickRandomContent(Random rng) {
    final typeIndex = rng.nextInt(7);
    final type = ContentType.values[typeIndex];

    switch (type) {
      case ContentType.ayah:
        return ExploreContent(
          type: ContentType.ayah,
          title: 'آية اليوم',
          text: '﴿ إِنَّ اللَّهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ ۚ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا ﴾',
          source: 'سورة الأحزاب • ٥٦',
          explanation: 'الله تعالى يخبر عباده بفضل الصلاة على النبي ﷺ، ويأمرهم بها.',
          icon: Icons.menu_book,
          color: const Color(0xFF4CAF50),
        );

      case ContentType.hadith:
        final h = hadithData[rng.nextInt(hadithData.length)];
        return ExploreContent(
          type: ContentType.hadith,
          title: 'حديث اليوم',
          text: h.text,
          source: h.source,
          explanation: h.explanation,
          icon: Icons.format_quote,
          color: const Color(0xFF2196F3),
        );

      case ContentType.dhikr:
        return ExploreContent(
          type: ContentType.dhikr,
          title: 'ذكر اليوم',
          text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
          source: 'فضل: كلمتان خفيفتان على اللسان ثقيلتان في الميزان',
          explanation: 'أحب الكلام إلى الله: سبحان الله وبحمده، سبحان الله العظيم.',
          icon: Icons.favorite,
          color: const Color(0xFFE91E63),
        );

      case ContentType.dua:
        final d = duasData[rng.nextInt(duasData.length)];
        return ExploreContent(
          type: ContentType.dua,
          title: 'دعاء اليوم',
          text: d.text,
          source: d.source,
          icon: Icons.pan_tool,
          color: const Color(0xFF9C27B0),
        );

      case ContentType.seerah:
        final event = seerahEventsData[rng.nextInt(seerahEventsData.length)];
        return ExploreContent(
          type: ContentType.seerah,
          title: 'من السيرة النبوية',
          text: event.summary,
          source: event.year,
          explanation: event.details,
          icon: Icons.history_edu,
          color: const Color(0xFFFF9800),
        );

      case ContentType.fact:
        final fact = factsData[rng.nextInt(factsData.length)];
        return ExploreContent(
          type: ContentType.fact,
          title: 'هل تعلم؟',
          text: fact.text,
          icon: Icons.lightbulb,
          color: const Color(0xFF00BCD4),
        );

      case ContentType.wisdom:
        final w = wisdomData[rng.nextInt(wisdomData.length)];
        return ExploreContent(
          type: ContentType.wisdom,
          title: 'حكمة وفائدة',
          text: w.text,
          source: w.source,
          icon: Icons.auto_awesome,
          color: const Color(0xFFFF5722),
        );
    }
  }

  void shuffleContent() {
    final seed = DateTime.now().millisecondsSinceEpoch;
    final rng = Random(seed);
    final content = _pickRandomContent(rng);
    final factIdx = rng.nextInt(factsData.length);

    state = state.copyWith(
      currentContent: content,
      currentContentType: content.type,
      factIndex: factIdx,
    );
  }
}
