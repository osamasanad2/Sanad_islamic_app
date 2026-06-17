import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/quran_models.dart';
import '../../data/repositories/tafsir_repository.dart';
import '../providers/quran_providers.dart';

class ReadingScreen extends ConsumerStatefulWidget {
  final int initialSurah;
  final int initialAyah;

  const ReadingScreen({super.key, this.initialSurah = 1, this.initialAyah = 1});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  late PageController _pageController;
  List<int> _sortedPages = [];
  int _currentPage = 1;
  bool _showControls = true;
  double _fontSize = 24;
  Color _bgColor = const Color(0xFFF5F0E8);
  List<Map<String, dynamic>> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadInitialData();
    _loadBookmarks();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final repo = ref.read(quranRepositoryProvider);
    await repo.loadPages();
    final pages = await repo.getSortedPages();
    final surah = await repo.getSurah(widget.initialSurah);
    if (surah != null) {
      final firstVerse = surah.verses.firstWhere(
        (v) => v.number == widget.initialAyah,
        orElse: () => surah.verses.first,
      );
      setState(() {
        _sortedPages = pages;
        _currentPage = firstVerse.page;
      });
    } else {
      setState(() => _sortedPages = pages);
    }
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('quran_bookmarks') ?? [];
    setState(() {
      _bookmarks = data.map((e) {
        final parts = e.split(':');
        return {'surah': int.parse(parts[0]), 'ayah': int.parse(parts[1])};
      }).toList();
    });
  }

  bool _isBookmarked(int surah, int ayah) {
    return _bookmarks.any((b) => b['surah'] == surah && b['ayah'] == ayah);
  }

  Future<void> _toggleBookmark(int surah, int ayah) async {
    final prefs = await SharedPreferences.getInstance();
    if (_isBookmarked(surah, ayah)) {
      _bookmarks.removeWhere((b) => b['surah'] == surah && b['ayah'] == ayah);
    } else {
      _bookmarks.add({'surah': surah, 'ayah': ayah});
    }
    final data = _bookmarks.map((b) => '${b['surah']}:${b['ayah']}').toList();
    await prefs.setStringList('quran_bookmarks', data);
    setState(() {});
  }

  void _showTafsir(int surahNumber, int ayahNumber) async {
    final tafsirRepo = TafsirRepository();
    final jalalayn = await tafsirRepo.getTafsir(
      surahNumber,
      ayahNumber,
      'aljalalayn',
    );
    final muyassar = await tafsirRepo.getTafsir(
      surahNumber,
      ayahNumber,
      'almuyassar',
    );
    final repo = ref.read(quranRepositoryProvider);
    final surah = await repo.getSurah(surahNumber);
    final verse = surah?.verses.firstWhere((v) => v.number == ayahNumber);

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (ctx, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'تفسير الآية $ayahNumber',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isBookmarked(surahNumber, ayahNumber)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: AppColors.primary,
                    ),
                    onPressed: () => _toggleBookmark(surahNumber, ayahNumber),
                  ),
                ],
              ),
              if (verse != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      verse.arabic,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'quran',
                        color: context.appColors.textPrimary,
                        height: 1.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  verse.english,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.appColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (muyassar != null) ...[
                const Text(
                  'التفسير الميسر',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  muyassar,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 15,
                    color: context.appColors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ],
              if (jalalayn != null) ...[
                const SizedBox(height: 20),
                const Text(
                  'تفسير الجلالين',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  jalalayn,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 15,
                    color: context.appColors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sortedPages.isEmpty) {
      return Scaffold(
        backgroundColor: _bgColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentPageIndex = _sortedPages.indexOf(_currentPage);

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _sortedPages.length,
              onPageChanged: (index) {
                setState(() => _currentPage = _sortedPages[index]);
              },
              itemBuilder: (context, index) {
                final pageNum = _sortedPages[index];
                return FutureBuilder<PageInfo?>(
                  future: _loadPageInfo(pageNum),
                  builder: (context, snapshot) {
                    final pageInfo = snapshot.data;
                    if (pageInfo == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _buildPageContent(pageInfo);
                  },
                );
              },
            ),
            // Top controls bar
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _bgColor.withValues(alpha: 0.95),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.text_fields),
                        onPressed: _showFontSizeDialog,
                      ),
                      IconButton(
                        icon: const Icon(Icons.palette_outlined),
                        onPressed: _showBgColorDialog,
                      ),
                    ],
                  ),
                ),
              ),
            // Bottom controls
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  decoration: BoxDecoration(
                    color: _bgColor.withValues(alpha: 0.95),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'صفحة $_currentPage • الجزء ${_getJuzForPage(_currentPage)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: context.appColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: currentPageIndex > 0
                                ? () => _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                                : null,
                          ),
                          Text(
                            '$_currentPage / ${_sortedPages.length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed:
                                currentPageIndex < _sortedPages.length - 1
                                ? () => _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                                : null,
                          ),
                        ],
                      ),
                      Slider(
                        value: currentPageIndex.toDouble(),
                        min: 0,
                        max: (_sortedPages.length - 1).toDouble(),
                        onChanged: (v) {
                          final idx = v.round();
                          _pageController.animateToPage(
                            idx,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<PageInfo?> _loadPageInfo(int pageNum) async {
    final repo = ref.read(quranRepositoryProvider);
    try {
      final pages = await repo.loadPages();
      return pages[pageNum];
    } catch (_) {
      return null;
    }
  }

  Widget _buildPageContent(PageInfo pageInfo) {
    return GestureDetector(
      onTap: () => setState(() => _showControls = !_showControls),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          _showControls ? 60 : 20,
          20,
          _showControls ? 100 : 20,
        ),
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                _buildPageHeader(pageInfo),
                const SizedBox(height: 20),
                ...pageInfo.verses.map(
                  (verse) => _buildVerseWidget(verse, pageInfo),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader(PageInfo pageInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text('۞', style: TextStyle(fontSize: 28, color: AppColors.gold)),
          const SizedBox(height: 4),
          Text(
            'الجزء ${pageInfo.juz}',
            style: TextStyle(fontSize: 14, color: context.appColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildVerseWidget(Verse verse, PageInfo pageInfo) {
    final surahForVerse = ref
        .read(quranRepositoryProvider)
        .getSurahNumberForVerse(
          pageInfo.pageNumber,
          pageInfo.verses.indexOf(verse),
        );

    final isStartOfSurah = verse.number == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          if (isStartOfSurah) _buildSurahHeader(surahForVerse),
          const SizedBox(height: 8),
          GestureDetector(
            onLongPress: () => _showTafsir(surahForVerse, verse.number),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.06),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${verse.number}',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'surah_number',
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      verse.arabic,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: _fontSize,
                        fontFamily: 'quran',
                        color: context.appColors.textPrimary,
                        height: 1.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahHeader(int surahNumber) {
    return FutureBuilder<Surah?>(
      future: ref.read(quranRepositoryProvider).getSurah(surahNumber),
      builder: (context, snapshot) {
        final surah = snapshot.data;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  surah?.nameArabic ?? '',
                  style: TextStyle(
                    fontSize: _fontSize + 4,
                    fontFamily: 'quran',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  surah?.transliteration ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: context.appColors.textSecondary,
                  ),
                ),
                if (surahNumber != 1 && surahNumber != 9)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                      style: TextStyle(
                        fontSize: _fontSize - 2,
                        fontFamily: 'quran',
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _getJuzForPage(int page) {
    if (page <= 21) return 1;
    if (page <= 41) return 2;
    if (page <= 61) return 3;
    if (page <= 81) return 4;
    if (page <= 101) return 5;
    if (page <= 121) return 6;
    if (page <= 141) return 7;
    if (page <= 161) return 8;
    if (page <= 181) return 9;
    if (page <= 201) return 10;
    if (page <= 221) return 11;
    if (page <= 241) return 12;
    if (page <= 261) return 13;
    if (page <= 281) return 14;
    if (page <= 301) return 15;
    if (page <= 321) return 16;
    if (page <= 341) return 17;
    if (page <= 361) return 18;
    if (page <= 381) return 19;
    if (page <= 401) return 20;
    if (page <= 421) return 21;
    if (page <= 441) return 22;
    if (page <= 461) return 23;
    if (page <= 481) return 24;
    if (page <= 501) return 25;
    if (page <= 521) return 26;
    if (page <= 541) return 27;
    if (page <= 561) return 28;
    if (page <= 581) return 29;
    return 30;
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حجم الخط'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اسحب لتغيير حجم الخط'),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (ctx, setLocalState) => Column(
                children: [
                  Text(
                    '$_fontSize',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    value: _fontSize,
                    min: 16,
                    max: 40,
                    divisions: 12,
                    onChanged: (v) {
                      setLocalState(() => _fontSize = v);
                    },
                    onChangeEnd: (v) {
                      setState(() => _fontSize = v);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('تم'),
          ),
        ],
      ),
    );
  }

  void _showBgColorDialog() {
    final colors = [
      const Color(0xFFF5F0E8),
      const Color(0xFFFFFFFF),
      const Color(0xFFE8E0D0),
      const Color(0xFFF0F5E8),
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('لون الخلفية'),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((c) {
            final isSelected = _bgColor.toARGB32() == c.toARGB32();
            return GestureDetector(
              onTap: () {
                setState(() => _bgColor = c);
                Navigator.pop(ctx);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
