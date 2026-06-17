import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/quran_models.dart';
import '../providers/quran_providers.dart';
import 'reading_screen.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  List<Map<String, dynamic>> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('quran_bookmarks') ?? [];
    final repo = ref.read(quranRepositoryProvider);
    final surahIndices = await repo.loadSurahIndices();
    final results = <Map<String, dynamic>>[];

    for (final entry in data) {
      final parts = entry.split(':');
      final surahId = int.parse(parts[0]);
      final ayahId = int.parse(parts[1]);
      final surah = surahIndices.firstWhere(
        (s) => s.id == surahId,
        orElse: () => SurahIndex(
          id: surahId,
          name: '',
          transliteration: '',
          type: '',
          totalVerses: 0,
        ),
      );
      final verse = await repo.findVerse(surahId, ayahId);
      if (verse != null) {
        results.add({
          'surah': surahId,
          'ayah': ayahId,
          'surahName': surah.name,
          'arabic': verse.arabic,
          'english': verse.english,
          'page': verse.page,
        });
      }
    }

    if (mounted) {
      setState(() {
        _bookmarks = results.reversed.toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteBookmark(int surah, int ayah) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('quran_bookmarks') ?? [];
    data.remove('$surah:$ayah');
    await prefs.setStringList('quran_bookmarks', data);
    _loadBookmarks();
  }

  void _copyAyah(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم نسخ الآية')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            'العلامات المرجعية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            '${_bookmarks.length}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_bookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد علامات مرجعية',
              style: TextStyle(fontSize: 18, color: context.appColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'اضغط مطولاً على آية لإضافتها',
              style: TextStyle(
                fontSize: 14,
                color: context.appColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _bookmarks.length,
      itemBuilder: (context, index) {
        final bm = _bookmarks[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReadingScreen(
                    initialSurah: bm['surah'] as int,
                    initialAyah: bm['ayah'] as int,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.bookmark,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${bm['surahName']} - الآية ${bm['ayah']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: context.appColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'صفحة ${bm['page']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.appColors.textSecondary.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        bm['arabic'] as String,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'quran',
                          color: context.appColors.textPrimary,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          tooltip: 'نسخ',
                          onPressed: () => _copyAyah(bm['arabic'] as String),
                          color: context.appColors.textSecondary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          tooltip: 'حذف',
                          onPressed: () => _deleteBookmark(
                            bm['surah'] as int,
                            bm['ayah'] as int,
                          ),
                          color: context.appColors.error.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
