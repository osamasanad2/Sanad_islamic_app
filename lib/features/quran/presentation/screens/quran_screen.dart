import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

// Theme presets for the Quran reader
class _QuranTheme {
  final Color bg;
  final Color text;
  final Color accent;
  final Color border;
  final String name;
  const _QuranTheme(this.bg, this.text, this.accent, this.border, this.name);
}

const _themes = [
  _QuranTheme(Color(0xFFFFFDF5), Color(0xFF2C1810), Color(0xFFD4AF37), Color(0xFFD4AF37), 'كريمي'),
  _QuranTheme(Color(0xFFE8F5E9), Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50), 'أخضر'),
  _QuranTheme(Color(0xFFE3F2FD), Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF42A5F5), 'أزرق'),
  _QuranTheme(Color(0xFF1A1A2E), Color(0xFFD4AF37), Color(0xFFD4AF37), Color(0xFF3A3A5C), 'ليلي'),
];

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});
  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  bool _isMushafMode = false;
  bool _isPlaying = false;
  bool _isMemorizationMode = false;
  int _playingAyahIndex = 1;
  double _fontSize = 26.0;
  int _themeIndex = 0;
  final Set<int> _hiddenAyahs = {};

  _QuranTheme get _theme => _themes[_themeIndex];
  bool get _isDark => _themeIndex == 3;

  final List<String> _ayahs = [
    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    'الرَّحْمَٰنِ الرَّحِيمِ',
    'مَالِكِ يَوْمِ الدِّينِ',
    'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
    'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildKhatmaProgress(),
                _buildAppBar(),
                _buildModeToggle(),
                const SizedBox(height: 8),
                Expanded(child: _isMushafMode ? _buildMushafMode() : _buildSeamlessMode()),
                const SizedBox(height: 90),
              ],
            ),
            Positioned(left: 0, right: 0, bottom: 0, child: _buildAudioPlayer()),
          ],
        ),
      ),
    );
  }

  // ─── Khatma Progress ───
  Widget _buildKhatmaProgress() {
    return Container(
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: 0.45,
          backgroundColor: _theme.accent.withValues(alpha: 0.15),
          valueColor: AlwaysStoppedAnimation<Color>(_theme.accent),
        ),
      ),
    ).animate().fadeIn();
  }

  // ─── AppBar ───
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.arrow_back, color: _theme.text), onPressed: () => context.pop()),
          const Spacer(),
          Column(
            children: [
              Text('سُورَةُ الفَاتِحَة', style: TextStyle(color: _theme.text, fontWeight: FontWeight.bold, fontSize: 18)),
              Text('مكية • ٧ آيات', style: TextStyle(color: _theme.text.withValues(alpha: 0.5), fontSize: 11)),
            ],
          ),
          const Spacer(),
          IconButton(icon: Icon(Icons.search, color: _theme.text), onPressed: () {}),
          IconButton(icon: Icon(Icons.tune_rounded, color: _theme.text), onPressed: _showSettingsSheet),
        ],
      ),
    );
  }

  // ─── Mode Toggle ───
  Widget _buildModeToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _theme.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildToggleButton('قراءة سلسة', !_isMushafMode, () => setState(() => _isMushafMode = false)),
          _buildToggleButton('المصحف', _isMushafMode, () => setState(() => _isMushafMode = true)),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? _theme.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: isActive ? (_isDark ? Colors.black : Colors.white) : _theme.text, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }

  // ─── Surah Header (Tezhip) ───
  Widget _buildSurahHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_theme.accent.withValues(alpha: 0.15), _theme.accent.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _theme.accent.withValues(alpha: 0.4), width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Corner ornaments
          Positioned(left: 0, top: 0, child: Icon(Icons.star, size: 14, color: _theme.accent.withValues(alpha: 0.4))),
          Positioned(right: 0, top: 0, child: Icon(Icons.star, size: 14, color: _theme.accent.withValues(alpha: 0.4))),
          Positioned(left: 0, bottom: 0, child: Icon(Icons.star, size: 14, color: _theme.accent.withValues(alpha: 0.4))),
          Positioned(right: 0, bottom: 0, child: Icon(Icons.star, size: 14, color: _theme.accent.withValues(alpha: 0.4))),
          Column(
            children: [
              Text('﷽', style: TextStyle(fontSize: 32, color: _theme.accent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('سُورَةُ الفَاتِحَة', style: TextStyle(fontSize: 20, color: _theme.text, fontWeight: FontWeight.bold)),
              Text('مكية ـ ٧ آيات', style: TextStyle(fontSize: 12, color: _theme.text.withValues(alpha: 0.5))),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.95, 0.95));
  }

  // ─── Seamless Mode ───
  Widget _buildSeamlessMode() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      physics: const BouncingScrollPhysics(),
      itemCount: _ayahs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildSurahHeader();
        final ayahIdx = index - 1;
        final isPlayingAyah = _isPlaying && _playingAyahIndex == ayahIdx;
        final isHidden = _isMemorizationMode && _hiddenAyahs.contains(ayahIdx);

        return GestureDetector(
          onLongPress: () => _showTafseerDialog(ayahIdx, _ayahs[ayahIdx]),
          onTap: isHidden ? () => setState(() => _hiddenAyahs.remove(ayahIdx)) : null,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPlayingAyah ? _theme.accent.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: isPlayingAyah ? Border.all(color: _theme.accent.withValues(alpha: 0.3)) : null,
            ),
            child: Column(
              children: [
                if (isHidden)
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(color: _theme.accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text('اضغط لإظهار الآية', style: TextStyle(color: _theme.text.withValues(alpha: 0.4), fontSize: 12))),
                  )
                else
                  Text(
                    _ayahs[ayahIdx],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: _fontSize, height: 1.8, color: _theme.text, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAyahAction(Icons.bookmark_border, () {}),
                    const SizedBox(width: 20),
                    _buildAyahNumber(ayahIdx + 1),
                    const SizedBox(width: 20),
                    _buildAyahAction(Icons.share_outlined, () {}),
                    if (_isMemorizationMode && !isHidden) ...[
                      const SizedBox(width: 20),
                      _buildAyahAction(Icons.visibility_off_outlined, () => setState(() => _hiddenAyahs.add(ayahIdx))),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms);
      },
    );
  }

  Widget _buildAyahAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: _theme.text.withValues(alpha: 0.3), size: 18),
    );
  }

  Widget _buildAyahNumber(int num) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.brightness_5, color: _theme.accent.withValues(alpha: 0.6), size: 32),
        Text('$num', style: TextStyle(fontSize: 10, color: _theme.text, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ─── Mushaf Mode ───
  Widget _buildMushafMode() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildSurahHeader(),
          // Ornamental Mushaf frame
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 40),
            decoration: BoxDecoration(
              color: _isDark ? const Color(0xFF1A1A2E) : const Color(0xFFFFFDF5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _theme.accent, width: 3),
              boxShadow: [BoxShadow(color: _theme.accent.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 6))],
            ),
            child: Stack(
              children: [
                // Side ornamental lines
                Positioned(left: 8, top: 8, bottom: 8, child: Container(width: 1.5, color: _theme.accent.withValues(alpha: 0.3))),
                Positioned(right: 8, top: 8, bottom: 8, child: Container(width: 1.5, color: _theme.accent.withValues(alpha: 0.3))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: List.generate(_ayahs.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _ayahs[i],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: _fontSize, color: _theme.text, fontWeight: FontWeight.w600, height: 1.8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(Icons.brightness_5, color: _theme.accent, size: 36),
                                Text('${i + 1}', style: TextStyle(fontSize: 10, color: _isDark ? Colors.black : Colors.black87, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),
        ],
      ),
    );
  }

  // ─── Audio Player ───
  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isDark ? const Color(0xFF252540) : AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundColor: _theme.accent.withValues(alpha: 0.2), child: Icon(Icons.person, color: _theme.accent)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مشاري العفاسي', style: TextStyle(fontWeight: FontWeight.bold, color: _isDark ? Colors.white : AppColors.textPrimary, fontSize: 13)),
                    Text('الفاتحة', style: TextStyle(fontSize: 11, color: _isDark ? Colors.white54 : AppColors.textSecondary)),
                  ],
                ),
              ),
              IconButton(icon: Icon(Icons.repeat, color: _isDark ? Colors.white38 : AppColors.textSecondary, size: 20), onPressed: () {}),
              Container(
                decoration: BoxDecoration(color: _theme.accent, shape: BoxShape.circle, boxShadow: [BoxShadow(color: _theme.accent.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4))]),
                child: IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: _isDark ? Colors.black : Colors.white, size: 24),
                  onPressed: () => setState(() => _isPlaying = !_isPlaying),
                ),
              ),
            ],
          ),
          if (_isPlaying) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: 0.3, backgroundColor: _theme.accent.withValues(alpha: 0.15), valueColor: AlwaysStoppedAnimation<Color>(_theme.accent), minHeight: 3),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Tafseer Bottom Sheet with Tabs ───
  void _showTafseerDialog(int idx, String ayah) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return DefaultTabController(
          length: 3,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.55,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: _isDark ? const Color(0xFF252540) : AppColors.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: _theme.accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                  child: Text(ayah, style: TextStyle(color: _theme.accent, fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 16),
                TabBar(
                  labelColor: _theme.accent,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: _theme.accent,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
                  tabs: const [Tab(text: 'التفسير الميسر'), Tab(text: 'ابن كثير'), Tab(text: 'معاني الكلمات')],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _tafseerContent('التفسير الميسر: هنا يظهر تفسير مبسط للآية الكريمة ليعين المسلم على فهم كتاب الله وتدبر معانيه بسهولة دون تعقيد.'),
                      _tafseerContent('تفسير ابن كثير: يعرض هنا التفسير المفصل مع ذكر الأسباب والمناسبات والأحاديث المرتبطة بالآية الكريمة.'),
                      _tafseerContent('معاني الكلمات: يعرض هنا شرح مفردات الآية كلمة كلمة لتسهيل الفهم اللغوي.'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionBtn(Icons.bookmark_add_outlined, 'حفظ'),
                    _actionBtn(Icons.image_outlined, 'بطاقة'),
                    _actionBtn(Icons.share_outlined, 'مشاركة'),
                    _actionBtn(Icons.copy, 'نسخ'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tafseerContent(String text) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(text, style: TextStyle(color: _isDark ? Colors.white70 : AppColors.textPrimary, height: 1.7, fontSize: 14)),
    );
  }

  Widget _actionBtn(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: _theme.accent.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: _theme.accent, size: 20),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 11, color: _isDark ? Colors.white54 : AppColors.textSecondary)),
      ],
    );
  }

  // ─── Settings Sheet ───
  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setModal) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: _isDark ? const Color(0xFF252540) : AppColors.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('إعدادات القراءة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _isDark ? Colors.white : AppColors.textPrimary)),
                const SizedBox(height: 20),
                Text('حجم الخط', style: TextStyle(fontWeight: FontWeight.bold, color: _isDark ? Colors.white70 : AppColors.textPrimary)),
                Slider(
                  value: _fontSize, min: 18, max: 40,
                  activeColor: _theme.accent, inactiveColor: Colors.grey.shade300,
                  onChanged: (v) { setModal(() => _fontSize = v); setState(() => _fontSize = v); },
                ),
                const SizedBox(height: 16),
                Text('مظهر المصحف', style: TextStyle(fontWeight: FontWeight.bold, color: _isDark ? Colors.white70 : AppColors.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_themes.length, (i) => _buildThemeOption(i, setModal)),
                ),
                const SizedBox(height: 20),
                // Memorization Mode Toggle
                SwitchListTile(
                  value: _isMemorizationMode,
                  onChanged: (v) { setModal(() => _isMemorizationMode = v); setState(() { _isMemorizationMode = v; _hiddenAyahs.clear(); }); },
                  activeColor: _theme.accent,
                  title: Text('وضع التحفيظ', style: TextStyle(fontWeight: FontWeight.bold, color: _isDark ? Colors.white : AppColors.textPrimary)),
                  subtitle: Text('إخفاء الآيات للتسميع الذاتي', style: TextStyle(fontSize: 12, color: _isDark ? Colors.white54 : AppColors.textSecondary)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildThemeOption(int i, StateSetter setModal) {
    final t = _themes[i];
    final isSelected = _themeIndex == i;
    return GestureDetector(
      onTap: () { setModal(() => _themeIndex = i); setState(() => _themeIndex = i); },
      child: Column(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: t.bg, shape: BoxShape.circle,
              border: Border.all(color: isSelected ? t.accent : Colors.grey.shade300, width: isSelected ? 3 : 1),
            ),
            child: Center(child: Text('ق', style: TextStyle(color: t.text, fontWeight: FontWeight.bold, fontSize: 16))),
          ),
          const SizedBox(height: 6),
          Text(t.name, style: TextStyle(fontSize: 11, color: isSelected ? _theme.accent : (_isDark ? Colors.white54 : AppColors.textSecondary), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
