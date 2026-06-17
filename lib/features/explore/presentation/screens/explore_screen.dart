import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/explore_data.dart';
import '../../data/explore_notifier.dart';
import '../../data/islamic_event_model.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exploreState = ref.watch(exploreProvider);
    final isSearching = exploreState.searchQuery.isNotEmpty;

    if (exploreState.isLoading) {
      return Scaffold(
        backgroundColor: context.appColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: context.appColors.background,
              title: Text(
                'استكشف',
                style: TextStyle(
                  color: context.appColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: _buildSearchBar(context),
                ),
              ),
            ),
            if (!isSearching) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTagsRow(context).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 20.0),
                      _buildDailyContentCard(context, ref, exploreState)
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideY(begin: 0.1),
                      const SizedBox(height: 12.0),
                      _buildRandomButton(context, ref)
                          .animate()
                          .fadeIn(delay: 250.ms),
                      const SizedBox(height: 24.0),
                      _buildDidYouKnowSection(context, exploreState)
                          .animate()
                          .fadeIn(delay: 300.ms)
                          .slideY(begin: 0.1),
                      const SizedBox(height: 28.0),
                      _buildSectionTitle(context, 'شخصيات إسلامية')
                          .animate()
                          .fadeIn(delay: 350.ms),
                      const SizedBox(height: 16.0),
                      _buildPersonalitiesCarousel(context)
                          .animate()
                          .fadeIn(delay: 400.ms),
                      const SizedBox(height: 28.0),
                      _buildSectionTitle(context, 'السيرة والتاريخ')
                          .animate()
                          .fadeIn(delay: 450.ms),
                      const SizedBox(height: 16.0),
                      _buildSeerahCarousel(context)
                          .animate()
                          .fadeIn(delay: 500.ms),
                      const SizedBox(height: 28.0),
                      _buildSectionTitle(context, 'مواضيع إسلامية')
                          .animate()
                          .fadeIn(delay: 550.ms),
                      const SizedBox(height: 16.0),
                      _buildTopicsGrid(context)
                          .animate()
                          .fadeIn(delay: 600.ms),
                      const SizedBox(height: 24.0),
                      _buildSectionTitle(context, 'حاسبة الزكاة')
                          .animate()
                          .fadeIn(delay: 620.ms),
                      const SizedBox(height: 16.0),
                      _buildZakatEntryCard(context)
                          .animate()
                          .fadeIn(delay: 640.ms),
                      const SizedBox(height: 32.0),
                      _buildSectionTitle(context, 'المكتبة الإسلامية')
                          .animate()
                          .fadeIn(delay: 650.ms),
                      const SizedBox(height: 16.0),
                      _buildLibraryEntryCard(context),
                      const SizedBox(height: 24.0),
                      _buildSanadAICard(context)
                          .animate()
                          .fadeIn(delay: 700.ms)
                          .slideY(begin: 0.1),
                      const SizedBox(height: 28.0),
                      _buildSectionTitle(context, 'أسماء الله الحسنى')
                          .animate()
                          .fadeIn(delay: 730.ms),
                      const SizedBox(height: 16.0),
                      _buildAsmaAlHusnaCard(context)
                          .animate()
                          .fadeIn(delay: 760.ms)
                          .slideY(begin: 0.1),
                      const SizedBox(height: 28.0),
                      _buildSectionTitle(context, 'في مثل هذا اليوم')
                          .animate()
                          .fadeIn(delay: 790.ms),
                      const SizedBox(height: 16.0),
                      _buildOnThisDayCard(context)
                          .animate()
                          .fadeIn(delay: 820.ms)
                          .slideY(begin: 0.1),
                      const SizedBox(height: 28.0),
                      _buildSectionTitle(context, 'الرقية الشرعية')
                          .animate()
                          .fadeIn(delay: 850.ms),
                      const SizedBox(height: 16.0),
                      _buildRuqyahCard(context)
                          .animate()
                          .fadeIn(delay: 880.ms)
                          .slideY(begin: 0.1),
                      const SizedBox(height: 28.0),
                      _buildSectionTitle(context, 'تعلم التجويد')
                          .animate()
                          .fadeIn(delay: 910.ms),
                      const SizedBox(height: 16.0),
                      _buildTajweedCard(context)
                          .animate()
                          .fadeIn(delay: 940.ms)
                          .slideY(begin: 0.1),
                      const SizedBox(height: 28.0),
                      _buildSectionTitle(context, 'المرأة المسلمة')
                          .animate()
                          .fadeIn(delay: 970.ms),
                      const SizedBox(height: 16.0),
                      _buildMuslimWomanCard(context)
                          .animate()
                          .fadeIn(delay: 1000.ms)
                           .slideY(begin: 0.1),
                       const SizedBox(height: 28.0),
                       _buildSectionTitle(context, 'فقه العبادات')
                           .animate()
                           .fadeIn(delay: 1030.ms),
                       const SizedBox(height: 16.0),
                       _buildFiqhCard(context)
                           .animate()
                           .fadeIn(delay: 1060.ms)
                           .slideY(begin: 0.1),
                       const SizedBox(height: 100.0),
                    ],
                  ),
                ),
              ),
            ] else
              _buildSearchResults(context, exploreState),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isSearching = ref.watch(exploreProvider).searchQuery.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) =>
            ref.read(exploreProvider.notifier).setSearchQuery(value),
        decoration: InputDecoration(
          hintText: 'ابحث عن آية، حديث، أو دعاء...',
          hintStyle: TextStyle(
            color: context.appColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: isSearching
              ? IconButton(
                  icon: const Icon(Icons.close, color: AppColors.primary),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(exploreProvider.notifier).setSearchQuery('');
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.mic, color: AppColors.primary),
                  onPressed: () {},
                ),
          filled: true,
          fillColor: context.appColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTagsRow(BuildContext context) {
    final tags = ['#الصبر', '#الجنة', '#بر_الوالدين', '#الفجر', '#الرزق'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tags.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(
              tags[index],
              style: TextStyle(
                color: context.appColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: context.appColors.primaryLight.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            onPressed: () {
              final tagText = tags[index].replaceFirst('#', '');
              _searchController.text = tagText;
              ref.read(exploreProvider.notifier).setSearchQuery(tagText);
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, ExploreState exploreState) {
    final query = exploreState.searchQuery.trim().toLowerCase();
    final results = <Map<String, dynamic>>[];

    if (query.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptySearch(context));
    }

    for (final topic in topicsData) {
      if (topic.title.toLowerCase().contains(query) ||
          topic.description.toLowerCase().contains(query) ||
          topic.id.toLowerCase().contains(query)) {
        results.add({
          'title': topic.title,
          'subtitle': topic.description,
          'icon': topic.icon,
          'color': topic.color,
          'type': 'topic',
        });
      }
    }

    for (final hadith in hadithData) {
      if (hadith.text.toLowerCase().contains(query) ||
          (hadith.source.toLowerCase().contains(query))) {
        results.add({
          'title': hadith.text,
          'subtitle': hadith.source,
          'icon': Icons.format_quote,
          'color': const Color(0xFF2196F3),
          'type': 'hadith',
        });
      }
    }

    for (final dua in duasData) {
      if (dua.text.toLowerCase().contains(query) ||
          (dua.source?.toLowerCase().contains(query) ?? false)) {
        results.add({
          'title': dua.text,
          'subtitle': dua.source ?? '',
          'icon': Icons.pan_tool,
          'color': const Color(0xFF9C27B0),
          'type': 'dua',
        });
      }
    }

    for (final wisdom in wisdomData) {
      if (wisdom.text.toLowerCase().contains(query) ||
          (wisdom.source?.toLowerCase().contains(query) ?? false)) {
        results.add({
          'title': wisdom.text,
          'subtitle': wisdom.source ?? '',
          'icon': Icons.auto_awesome,
          'color': const Color(0xFFFF5722),
          'type': 'wisdom',
        });
      }
    }

    for (final fact in factsData) {
      if (fact.text.toLowerCase().contains(query)) {
        results.add({
          'title': fact.text,
          'subtitle': 'هل تعلم؟',
          'icon': Icons.lightbulb,
          'color': const Color(0xFF00BCD4),
          'type': 'fact',
        });
      }
    }

    for (final p in personalitiesData) {
      if (p.name.toLowerCase().contains(query) ||
          p.title.toLowerCase().contains(query) ||
          p.summary.toLowerCase().contains(query)) {
        results.add({
          'title': p.name,
          'subtitle': p.title,
          'icon': p.icon,
          'color': p.color,
          'type': 'personality',
        });
      }
    }

    for (final event in seerahEventsData) {
      if (event.title.toLowerCase().contains(query) ||
          event.summary.toLowerCase().contains(query)) {
        results.add({
          'title': event.title,
          'subtitle': event.summary,
          'icon': event.icon,
          'color': event.color,
          'type': 'seerah',
        });
      }
    }

    if (results.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptySearch(context));
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final result = results[index];
            return _buildSearchResultItem(context, result);
          },
          childCount: results.length,
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(
      BuildContext context, Map<String, dynamic> result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (result['color'] as Color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              result['icon'] as IconData,
              color: result['color'] as Color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result['title'] as String,
                  style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((result['subtitle'] as String).isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    result['subtitle'] as String,
                    style: TextStyle(
                      color: context.appColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: context.appColors.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج مطابقة',
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرّب كلمة مختلفة أو اختر وسمًا آخر',
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyContentCard(
    BuildContext context,
    WidgetRef ref,
    ExploreState exploreState,
  ) {
    final content = exploreState.currentContent;
    if (content == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: content.color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: content.color.withValues(alpha: 0.3),
            blurRadius: 15.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -20,
            top: -20,
            child: Icon(
              content.icon,
              size: 140,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(content.icon, color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        content.title,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (content.source != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        content.source!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                content.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  height: 1.6,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (content.explanation != null) ...[
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    content.explanation!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(Icons.content_copy, 'نسخ', contentText: content.text),
                  const SizedBox(width: 32),
                  _buildActionButton(Icons.favorite_border, 'حفظ', contentText: content.text),
                  const SizedBox(width: 32),
                  _buildActionButton(Icons.share, 'مشاركة', contentText: content.text),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {String? contentText}) {
    return InkWell(
      onTap: () {
        switch (label) {
          case 'نسخ':
            if (contentText != null) {
              Clipboard.setData(ClipboardData(text: contentText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم النسخ'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            }
            break;
          case 'حفظ':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم الحفظ'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
            break;
          case 'مشاركة':
            if (contentText != null) {
              Share.share(contentText);
            }
            break;
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRandomButton(BuildContext context, WidgetRef ref) {
    return Center(
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => ref.read(exploreProvider.notifier).shuffleContent(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shuffle, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                const Text(
                  'اكتشف محتوى جديد',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDidYouKnowSection(
    BuildContext context,
    ExploreState exploreState,
  ) {
    final fact = factsData[exploreState.factIndex % factsData.length];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.cyan.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.cyan.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline,
                color: Colors.cyan, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'هل تعلم؟',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: context.appColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  fact.text,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.appColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: context.appColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPersonalitiesCarousel(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: personalitiesData.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final p = personalitiesData[index];
          return GestureDetector(
            onTap: () => _showPersonalityDialog(context, p),
            child: Container(
              width: 130,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.appColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: p.color.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: p.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(p.icon, color: p.color, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    p.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: context.appColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.title,
                    style: TextStyle(
                      fontSize: 10,
                      color: context.appColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPersonalityDialog(BuildContext context, Personality p) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: p.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(p.icon, color: p.color, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                p.summary,
                style: TextStyle(
                  fontSize: 14,
                  color: context.appColors.textPrimary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'أبرز الإنجازات',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                p.achievements,
                style: TextStyle(
                  fontSize: 13,
                  color: context.appColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'الدروس المستفادة',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                p.lessons,
                style: TextStyle(
                  fontSize: 13,
                  color: context.appColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeerahCarousel(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: seerahEventsData.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final event = seerahEventsData[index];
          return GestureDetector(
            onTap: () => _showSeerahDialog(context, event),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    event.color.withValues(alpha: 0.9),
                    event.color.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(event.icon, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.year,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.summary,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSeerahDialog(BuildContext context, SeerahEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollCtrl) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollCtrl,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: event.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(event.icon, color: event.color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'السنة: ${event.year}',
                              style: TextStyle(
                                fontSize: 13,
                                color: context.appColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    event.details,
                    style: TextStyle(
                      fontSize: 15,
                      color: context.appColors.textPrimary,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopicsGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: topicsData.length,
      itemBuilder: (context, index) {
        final topic = topicsData[index];
        return GestureDetector(
          onTap: () => _showTopicDialog(context, topic),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: topic.color.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: topic.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(topic.icon, color: topic.color, size: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  topic.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: context.appColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  topic.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.appColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTopicDialog(BuildContext context, IslamicTopic topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollCtrl) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollCtrl,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: topic.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(topic.icon, color: topic.color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        topic.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    topic.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...topic.ayahKeys.map(
                    (a) => _buildTopicItem(
                      context,
                      Icons.menu_book,
                      'آية: $a',
                      Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...topic.hadithIndices.map(
                    (i) {
                      final idx = int.tryParse(i) ?? 0;
                      final h = hadithData[idx % hadithData.length];
                      return _buildTopicItem(
                        context,
                        Icons.format_quote,
                        h.text.replaceAll(RegExp(r'[«»]'), '').trim(),
                        Colors.blue,
                        maxLines: 2,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ...topic.duaTexts.map(
                    (d) => _buildTopicItem(
                      context,
                      Icons.pan_tool,
                      d,
                      Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopicItem(
    BuildContext context,
    IconData icon,
    String text,
    Color color, {
    int maxLines = 3,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: context.appColors.textPrimary,
                height: 1.4,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZakatEntryCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/zakat'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gold.withValues(alpha: 0.9),
              AppColors.goldLight.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.calculate,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'حاسبة الزكاة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'احسب زكاتك بدقة وفق النصاب الشرعي (85 جرام ذهب)',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ابدأ الحساب',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSanadAICard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSanadAIBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF553C9A),
              const Color(0xFF6B46C1).withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B46C1).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF6B46C1).withValues(alpha: 0.12),
              blurRadius: 40,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.smart_toy_rounded,
                size: 120,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'سند الذكي',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'مساعدك الذكي لفهم القرآن والحديث والفقه',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'اسأل سند',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSanadAIBottomSheet(BuildContext context) {
    final suggestions = [
      {
        'title': 'ما هي أحكام الصلاة؟',
        'icon': Icons.mosque_rounded,
        'color': const Color(0xFF2196F3),
        'hadithIndices': [2, 14, 16],
        'duaIndices': [8],
        'explanation': 'الصلاة هي عمود الدين، وهي الركن الثاني من أركان الإسلام. فرضت على كل مسلم بالغ عاقل، وهي أول ما يحاسب عليه العبد يوم القيامة.',
      },
      {
        'title': 'أخبرني عن فضل الصدقة',
        'icon': Icons.volunteer_activism,
        'color': const Color(0xFF4DB6AC),
        'hadithIndices': [3, 18],
        'wisdomIndices': [18],
        'explanation': 'الصدقة تطفئ الخطيئة كما يطفئ الماء النار، وهي تزيد في المال ولا تنقصه. قال النبي ﷺ: "ما نقص مال من صدقة".',
      },
      {
        'title': 'ما هو حكم الربا؟',
        'icon': Icons.gavel,
        'color': const Color(0xFFF44336),
        'hadithIndices': [14],
        'explanation': 'الربا من كبائر الذنوب في الإسلام. قال الله تعالى: "وَأَحَلَّ اللَّهُ الْبَيْعَ وَحَرَّمَ الرِّبَا". لعن النبي ﷺ آكل الربا وموكله وكاتبه وشاهديه.',
      },
      {
        'title': 'حدثني عن الصبر',
        'icon': Icons.hourglass_empty,
        'color': const Color(0xFF4CAF50),
        'hadithIndices': [8, 11],
        'wisdomIndices': [13],
        'explanation': 'الصبر نصف الإيمان، وهو من أعظم أبواب الخير. قال النبي ﷺ: "عجباً لأمر المؤمن إن أمره كله خير، وإن أصابته سراء شكر فكان خيراً له، وإن أصابته ضراء صبر فكان خيراً له".',
      },
      {
        'title': 'ما هو فضل بر الوالدين؟',
        'icon': Icons.favorite,
        'color': const Color(0xFFE91E63),
        'hadithIndices': [7, 9],
        'wisdomIndices': [6],
        'explanation': 'بر الوالدين من أحب الأعمال إلى الله بعد الصلاة على وقتها. قال النبي ﷺ: "الوالد أوسط أبواب الجنة، فاحفظ ذلك الباب أو ضيع".',
      },
      {
        'title': 'أخبرني عن الاستغفار',
        'icon': Icons.replay,
        'color': const Color(0xFF795548),
        'hadithIndices': [5, 10],
        'duaIndices': [6],
        'explanation': 'الاستغفار سبب للمغفرة والرزق والبركة. قال النبي ﷺ: "من لزم الاستغفار جعل الله له من كل هم فرجاً ومن كل ضيق مخرجاً ورزقه من حيث لا يحتسب".',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollCtrl) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollCtrl,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B46C1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.smart_toy_rounded,
                          color: Color(0xFF6B46C1),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'سند الذكي',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: context.appColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اختر موضوعاً لأساعدك في فهمه',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...suggestions.map(
                    (suggestion) => _buildAISuggestionItem(context, suggestion),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAISuggestionItem(
    BuildContext context,
    Map<String, dynamic> suggestion,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: (suggestion['color'] as Color).withValues(alpha: 0.15),
          ),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: (suggestion['color'] as Color).withValues(alpha: 0.15),
          ),
        ),
        backgroundColor: context.appColors.surface,
        collapsedBackgroundColor: context.appColors.surface,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (suggestion['color'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            suggestion['icon'] as IconData,
            color: suggestion['color'] as Color,
            size: 22,
          ),
        ),
        title: Text(
          suggestion['title'] as String,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: context.appColors.textPrimary,
          ),
        ),
        children: [
          if (suggestion['explanation'] != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6B46C1).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF6B46C1).withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF6B46C1),
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      const Text(
                        'الإجابة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF6B46C1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    suggestion['explanation'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.appColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          if ((suggestion['hadithIndices'] as List).isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'أحاديث متعلقة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: context.appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...(suggestion['hadithIndices'] as List).map((i) {
              final idx = int.tryParse(i.toString()) ?? 0;
              final h = hadithData[idx % hadithData.length];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      h.text,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.appColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      h.source,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          if ((suggestion['wisdomIndices'] as List?)?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Text(
              'حكم ومواعظ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: context.appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...(suggestion['wisdomIndices'] as List).map((i) {
              final idx = int.tryParse(i.toString()) ?? 0;
              final w = wisdomData[idx % wisdomData.length];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.deepOrange.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      w.text,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.appColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    if (w.source != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        w.source!,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
          if ((suggestion['duaIndices'] as List?)?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Text(
              'أدعية متعلقة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: context.appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...(suggestion['duaIndices'] as List).map((i) {
              final idx = int.tryParse(i.toString()) ?? 0;
              final d = duasData[idx % duasData.length];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.purple.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.text,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.appColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    if (d.source != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        d.source!,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildAsmaAlHusnaCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/asma-al-husna'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0B5E56),
              const Color(0xFF0F766E).withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F766E).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF0F766E).withValues(alpha: 0.12),
              blurRadius: 40,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -20,
              top: -20,
              child: Icon(
                Icons.auto_awesome,
                size: 120,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'أسماء الله الحسنى',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'تعرف على أسماء الله الحسنى ومعانيها وآثارها الإيمانية في حياتك',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'استعرض الأسماء',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnThisDayCard(BuildContext context) {
    final eventAsync = ref.watch(todayIslamicEventProvider);
    return eventAsync.when(
      data: (event) {
        if (event == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () => context.push('/islamic-event', extra: event),
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0F5A3A),
                    const Color(0xFF1E7D4F),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F5A3A).withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.08),
                    blurRadius: 40,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: -10,
                    top: -10,
                    child: Icon(
                      Icons.auto_stories,
                      size: 100,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Transform.rotate(
                      angle: 0.3,
                      child: Icon(
                        Icons.star,
                        size: 70,
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37)
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.auto_stories,
                              color: Color(0xFFD4AF37),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'في مثل هذا اليوم',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        event.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          event.description,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 11),
                                const SizedBox(width: 4),
                                Text(
                                  event.hijriDate,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.info_outline,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'اعرف المزيد',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildRuqyahCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/ruqyah'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF182848),
              const Color(0xFF1E3A8A).withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.12),
              blurRadius: 40,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -20,
              top: -20,
              child: Icon(
                Icons.shield_rounded,
                size: 120,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.shield_moon_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الرقية الشرعية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'آيات وأدعية صحيحة من القرآن والسنة للتحصين والرقية الشرعية',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.healing_rounded,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'ابدأ الرقية',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTajweedCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/tajweed'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0B6B6A),
              const Color(0xFF0EA5A4).withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0EA5A4).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.08),
              blurRadius: 40,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.mic,
                size: 120,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.mic_external_on_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تعلم التجويد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'أتقن تلاوة القرآن الكريم وفق أحكام التجويد الصحيحة',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.school_rounded,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'ابدأ التعلم',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuslimWomanCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/muslim-woman'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF9C6B7D),
              const Color(0xFFC08497).withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC08497).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFFC08497).withValues(alpha: 0.12),
              blurRadius: 40,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -20,
              top: -20,
              child: Icon(
                Icons.woman_rounded,
                size: 120,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.woman_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المرأة المسلمة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'أحكام وعبادات وآداب المرأة المسلمة وفق الكتاب والسنة',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.stars_rounded,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'استعرض القسم',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiqhCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/fiqh'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF8B3A0A),
              const Color(0xFFB45309).withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB45309).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFFB45309).withValues(alpha: 0.12),
              blurRadius: 40,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -20,
              top: -20,
              child: Icon(
                Icons.mosque_rounded,
                size: 120,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.mosque_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'فقه العبادات',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'تعلم أحكام الطهارة والصلاة والزكاة والصيام والحج بطريقة سهلة ومبسطة',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.menu_book_rounded,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'ابدأ التعلم',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryEntryCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/library'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF075E37),
              const Color(0xFF0B7A45).withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B7A45).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF0B7A45).withValues(alpha: 0.12),
              blurRadius: 40,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -20,
              top: -20,
              child: Icon(
                Icons.auto_stories,
                size: 120,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.library_books,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'المكتبة الإسلامية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'استكشف مئات الكتب في التفسير والحديث والفقه والعقيدة والسيرة',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'تصفح المكتبة',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
