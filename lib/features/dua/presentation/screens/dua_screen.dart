import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/hisn_almuslim_model.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> with SingleTickerProviderStateMixin {
  List<HisnCategory>? _hisnCategories;
  bool _loadingHisn = true;
  late AnimationController _animCtrl;
  List<Animation<double>> _fadeAnims = [];
  List<Animation<Offset>> _slideAnims = [];
  String _query = '';
  final _searchFocus = FocusNode();
  final _searchCtrl = TextEditingController();

  final List<_LegacyCategory> _legacyCategories = [
    _LegacyCategory(name: 'أدعية الصباح', icon: Icons.wb_sunny_rounded, color: const Color(0xFFE8A040), duas: [
      _LegacyDua(text: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ.', source: 'صحيح الترمذي'),
      _LegacyDua(text: 'اللَّهُمَّ أَنْتَ رَبِّي لا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ.', source: 'صحيح البخاري'),
      _LegacyDua(text: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْماً نَافِعاً، وَرِزْقاً طَيِّباً، وَعَمَلاً مُتَقَبَّلاً.', source: 'سنن ابن ماجه'),
    ]),
    _LegacyCategory(name: 'أدعية المساء', icon: Icons.nightlight_round_rounded, color: const Color(0xFF4A6FA5), duas: [
      _LegacyDua(text: 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ.', source: 'صحيح الترمذي'),
      _LegacyDua(text: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لا شَرِيكَ لَهُ.', source: 'صحيح مسلم'),
    ]),
    _LegacyCategory(name: 'أدعية النوم', icon: Icons.bedtime_rounded, color: const Color(0xFF5B4A8A), duas: [
      _LegacyDua(text: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا.', source: 'صحيح البخاري'),
      _LegacyDua(text: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ.', source: 'صحيح الترمذي'),
      _LegacyDua(text: 'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لا مَلْجَأَ وَلا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ.', source: 'صحيح البخاري'),
    ]),
    _LegacyCategory(name: 'أدعية الخروج من المنزل', icon: Icons.door_front_door_rounded, color: const Color(0xFF2E7D6F), duas: [
      _LegacyDua(text: 'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلا حَوْلَ وَلا قُوَّةَ إِلَّا بِاللَّهِ.', source: 'صحيح الترمذي'),
      _LegacyDua(text: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أَضِلَّ أَوْ أُضَلَّ، أَوْ أَزِلَّ أَوْ أُزَلَّ، أَوْ أَظْلِمَ أَوْ أُظْلَمَ، أَوْ أَجْهَلَ أَوْ يُجْهَلَ عَلَيَّ.', source: 'سنن أبي داود'),
    ]),
    _LegacyCategory(name: 'أدعية الأكل والشرب', icon: Icons.restaurant_rounded, color: const Color(0xFFC17B3C), duas: [
      _LegacyDua(text: 'بِسْمِ اللَّهِ.', source: 'صحيح البخاري'),
      _LegacyDua(text: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلا قُوَّةَ.', source: 'صحيح الترمذي'),
    ]),
    _LegacyCategory(name: 'أدعية السفر', icon: Icons.flight_rounded, color: const Color(0xFF3A7CA5), duas: [
      _LegacyDua(text: 'اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ.', source: 'صحيح مسلم'),
      _LegacyDua(text: 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى.', source: 'صحيح مسلم'),
    ]),
  ];

  bool _matchesQuery(_LegacyDua dua) {
    if (_query.isEmpty) return true;
    final q = _query;
    return dua.text.contains(q) || dua.source.contains(q);
  }

  bool _legacyCatMatches(_LegacyCategory cat) {
    if (_query.isEmpty) return true;
    if (cat.name.contains(_query)) return true;
    return cat.duas.any(_matchesQuery);
  }

  bool _hisnCatMatches(HisnCategory cat) {
    if (_query.isEmpty) return true;
    if (cat.name.contains(_query)) return true;
    return cat.duas.any((d) => d.text.contains(_query) || d.source.contains(_query));
  }

  bool get _isSearching => _query.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _loadHisn();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _loadHisn() async {
    final cats = await HisnAlmuslimRepository.load();
    if (!mounted) return;
    _fadeAnims = List.generate(cats.length, (i) {
      return CurvedAnimation(parent: _animCtrl, curve: Interval(i * 0.04, 0.5 + i * 0.04, curve: Curves.easeOut));
    });
    _slideAnims = List.generate(cats.length, (i) {
      return Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(parent: _animCtrl, curve: Interval(i * 0.04, 0.5 + i * 0.04, curve: Curves.easeOutCubic)),
      );
    });
    setState(() { _hisnCategories = cats; _loadingHisn = false; });
    _animCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('الأدعية'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: context.appColors.textPrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              onChanged: (v) => setState(() => _query = v),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث في الأدعية والأذكار...',
                hintTextDirection: TextDirection.rtl,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); _searchFocus.unfocus(); },
                      )
                    : null,
                filled: true,
                fillColor: context.appColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.08))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
          ),
          Expanded(
            child: _isSearching ? _buildSearchResults() : _buildFullList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFullList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...List.generate(_legacyCategories.length, (i) => _LegacyCategoryCard(category: _legacyCategories[i], index: i)),
        const SizedBox(height: 12),
        _HisnSectionHeader(),
        const SizedBox(height: 12),
        if (_loadingHisn)
          const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: Center(child: CircularProgressIndicator()))
        else if (_hisnCategories != null && _fadeAnims.length == _hisnCategories!.length)
          ...List.generate(_hisnCategories!.length, (i) {
            return FadeTransition(
              opacity: _fadeAnims[i],
              child: SlideTransition(
                position: _slideAnims[i],
                child: _CategoryCard(category: _hisnCategories![i]),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSearchResults() {
    final matchedLegacy = _legacyCategories.where(_legacyCatMatches).toList();
    final matchedHisn = _hisnCategories?.where(_hisnCatMatches).toList() ?? [];

    if (matchedLegacy.isEmpty && matchedHisn.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: context.appColors.textSecondary.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text('لا توجد نتائج لـ "$_query"', style: TextStyle(fontSize: 15, color: context.appColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (matchedLegacy.isNotEmpty) ...matchedLegacy.map((c) => _LegacyCategoryCard(category: c, index: 0)),
        if (matchedLegacy.isNotEmpty && matchedHisn.isNotEmpty) ...[
          const SizedBox(height: 8),
          _HisnSectionHeader(),
          const SizedBox(height: 8),
        ],
        if (matchedHisn.isNotEmpty && !_loadingHisn) ...matchedHisn.map((c) => _CategoryCard(category: c)),
      ],
    );
  }
}

/* ─── Section Header ─── */

class _HisnSectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 4, height: 22,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.gold, AppColors.primary], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.menu_book_rounded, color: AppColors.gold, size: 18),
            ),
            const SizedBox(width: 8),
            Text('حصن المسلم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.appColors.textPrimary)),
            const Spacer(),
            Text('الأذكار والأدعية المأثورة', style: TextStyle(fontSize: 10, color: context.appColors.textSecondary, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gold.withValues(alpha: 0.5), AppColors.primary.withValues(alpha: 0.15), Colors.transparent],
              begin: Alignment.centerLeft, end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}

/* ─── Legacy categories ─── */

class _LegacyCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<_LegacyDua> duas;
  const _LegacyCategory({required this.name, required this.icon, required this.color, required this.duas});
}

class _LegacyDua {
  final String text;
  final String source;
  const _LegacyDua({required this.text, required this.source});
}

class _LegacyCategoryCard extends StatefulWidget {
  final _LegacyCategory category;
  final int index;
  const _LegacyCategoryCard({required this.category, required this.index});
  @override
  State<_LegacyCategoryCard> createState() => _LegacyCategoryCardState();
}

class _LegacyCategoryCardState extends State<_LegacyCategoryCard> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _slideCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic),
    );
    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) _slideCtrl.forward();
    });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cat.color.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(color: cat.color.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: cat.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                        child: Icon(cat.icon, color: cat.color, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(cat.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: context.appColors.textPrimary))),
                      AnimatedRotation(turns: _expanded ? 0.5 : 0, duration: const Duration(milliseconds: 200), child: Icon(Icons.expand_more_rounded, color: context.appColors.textSecondary, size: 20)),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: _expanded
                    ? Column(children: [const SizedBox(height: 4), ...cat.duas.map((dua) => _LegacyDuaCard(dua: dua, color: cat.color))])
                    : const SizedBox(width: double.infinity),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegacyDuaCard extends StatelessWidget {
  final _LegacyDua dua;
  final Color color;
  const _LegacyDuaCard({required this.dua, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.appColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dua.text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.appColors.textPrimary, height: 1.8)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle_rounded, size: 6, color: color.withValues(alpha: 0.4)),
                    const SizedBox(width: 6),
                    Text(dua.source, style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.8), fontWeight: FontWeight.w500)),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: dua.text));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('تم نسخ الدعاء'), behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ));
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.copy_rounded, size: 16, color: color.withValues(alpha: 0.7)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ─── Hisn categories ─── */

class _CategoryCard extends StatefulWidget {
  final HisnCategory category;
  const _CategoryCard({required this.category});
  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final c = cat.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: c.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [c.withValues(alpha: 0.18), c.withValues(alpha: 0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(cat.icon, color: c, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(cat.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.appColors.textPrimary))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                    child: Text('${cat.duas.length}', style: TextStyle(fontSize: 10, color: c, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(turns: _expanded ? 0.5 : 0, duration: const Duration(milliseconds: 200), child: Icon(Icons.expand_more_rounded, color: context.appColors.textSecondary, size: 20)),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded ? _buildDuasList(cat.duas, c) : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _buildDuasList(List<HisnDuaItem> duas, Color c) {
    return Column(
      children: [
        Divider(height: 1, thickness: 1, indent: 14, endIndent: 14, color: c.withValues(alpha: 0.12)),
        ...duas.asMap().entries.map((entry) => _HisnDuaCard(dua: entry.value, color: c, isLast: entry.key == duas.length - 1)),
      ],
    );
  }
}

class _HisnDuaCard extends StatelessWidget {
  final HisnDuaItem dua;
  final Color color;
  final bool isLast;
  const _HisnDuaCard({required this.dua, required this.color, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14, 10, 14, isLast ? 12 : 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dua.text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.appColors.textPrimary, height: 1.7)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.verified_rounded, size: 10, color: color.withValues(alpha: 0.5)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(dua.source, style: TextStyle(fontSize: 9, color: color.withValues(alpha: 0.8), fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: dua.text));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('تم نسخ الدعاء'), behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ));
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.copy_rounded, size: 14, color: color.withValues(alpha: 0.7)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
