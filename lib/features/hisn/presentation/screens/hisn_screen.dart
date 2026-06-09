import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/providers/hisn_provider.dart';
import '../../data/models/hisn_model.dart';

class HisnScreen extends ConsumerStatefulWidget {
  const HisnScreen({super.key});
  @override
  ConsumerState<HisnScreen> createState() => _HisnScreenState();
}

class _HisnScreenState extends ConsumerState<HisnScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hisnAsync = ref.watch(hisnProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: hisnAsync.when(
        loading: () => _buildLoadingState(),
        error: (err, _) => Center(child: Text('حدث خطأ: $err')),
        data: (categories) {
          // Filter out intro/preface sections and apply search
          final filtered = categories.where((cat) {
            if (cat.name == 'المقدمة' || cat.name == 'فضل الذكر') return false;
            if (_searchQuery.isEmpty) return true;
            return cat.name.contains(_searchQuery);
          }).toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${filtered.length} قسم',
                          style: TextStyle(
                            color: Colors.purple.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'أقسام الأذكار والأدعية',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final cat = filtered[index];
                    final catIndex = categories.indexOf(cat);
                    return _buildCategoryTile(cat, catIndex, index);
                  }, childCount: filtered.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_rounded,
              size: 48,
              color: Colors.purple.shade300,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'جارٍ تحميل حصن المسلم...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 120,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.purple.shade50,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.shade800,
                Colors.purple.shade600,
                Colors.deepPurple.shade400,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                right: -30,
                top: -20,
                child: Icon(
                  Icons.shield_rounded,
                  size: 200,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              Positioned(
                left: -40,
                bottom: -30,
                child: Icon(
                  Icons.auto_awesome,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.shield_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'حصن المسلم',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'من أذكار الكتاب والسنة',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 13,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'ابحث عن ذكر أو دعاء...',
            hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.purple.shade300,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildCategoryTile(HisnCategory cat, int catIndex, int animIndex) {
    final colors = [
      Colors.purple.shade400,
      Colors.deepPurple.shade400,
      Colors.indigo.shade400,
      Colors.blue.shade400,
      Colors.teal.shade400,
      Colors.green.shade400,
      Colors.amber.shade600,
      Colors.orange.shade400,
      Colors.pink.shade300,
      Colors.cyan.shade400,
    ];
    final color = colors[animIndex % colors.length];

    final icons = [
      Icons.wb_sunny_rounded,
      Icons.nights_stay_rounded,
      Icons.mosque_rounded,
      Icons.self_improvement_rounded,
      Icons.favorite_rounded,
      Icons.shield_rounded,
      Icons.menu_book_rounded,
      Icons.home_rounded,
      Icons.directions_walk_rounded,
      Icons.restaurant_rounded,
      Icons.water_drop_rounded,
      Icons.bedtime_rounded,
      Icons.local_hospital_rounded,
      Icons.cloud_rounded,
      Icons.travel_explore_rounded,
    ];
    final icon = icons[animIndex % icons.length];

    return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.push(
                  '/hisn/details',
                  extra: {'category': cat, 'color': color},
                );
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: color.withValues(alpha: 0.12),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(width: 14),
                    // Title & count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${cat.azkar.length} ${cat.azkar.length == 1 ? 'ذكر' : 'أذكار'}',
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: color,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (80 * animIndex).clamp(0, 800).ms)
        .slideX(begin: 0.05);
  }
}
