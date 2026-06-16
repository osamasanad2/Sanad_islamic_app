import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/asma_al_husna_model.dart';
import '../../data/asma_al_husna_provider.dart';

class AsmaAlHusnaScreen extends ConsumerStatefulWidget {
  const AsmaAlHusnaScreen({super.key});

  @override
  ConsumerState<AsmaAlHusnaScreen> createState() => _AsmaAlHusnaScreenState();
}

class _AsmaAlHusnaScreenState extends ConsumerState<AsmaAlHusnaScreen> {
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(asmaAlHusnaProvider);
    final displayNames =
        _showFavoritesOnly ? state.favorites : state.names;

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        title: Text(
          'أسماء الله الحسنى',
          style: TextStyle(
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.appColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(
                  child: Text(
                    state.error!,
                    style: TextStyle(color: context.appColors.textSecondary),
                  ),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    if (state.nameOfTheDay != null)
                      SliverToBoxAdapter(
                        child: _buildNameOfTheDayCard(
                            context, state.nameOfTheDay!),
                      ),
                    SliverToBoxAdapter(
                      child: _buildFilterBar(context, state),
                    ),
                    if (displayNames.isEmpty && _showFavoritesOnly)
                      SliverFillRemaining(
                        child: _buildEmptyFavorites(context),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final name = displayNames[index];
                              return _buildNameCard(context, name, state);
                            },
                            childCount: displayNames.length,
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _buildNameOfTheDayCard(BuildContext context, AsmaAlHusnaName name) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F5A3A),
            const Color(0xFF128C5A).withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F5A3A).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'اسم اليوم',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name.meaning,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, AsmaAlHusnaState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip(
            context,
            label: 'الكل (${state.names.length})',
            selected: !_showFavoritesOnly,
            onTap: () => setState(() => _showFavoritesOnly = false),
          ),
          const SizedBox(width: 10),
          _buildFilterChip(
            context,
            label: 'المفضلة (${state.favorites.length})',
            selected: _showFavoritesOnly,
            onTap: () => setState(() => _showFavoritesOnly = true),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF0F5A3A)
              : context.appColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(0xFF0F5A3A)
                : context.appColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : context.appColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildNameCard(
      BuildContext context, AsmaAlHusnaName name, AsmaAlHusnaState state) {
    final isFavorite = state.favoriteIds.contains(name.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0F5A3A),
                      const Color(0xFF128C5A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${name.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.name,
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name.meaning,
                      style: TextStyle(
                        color: const Color(0xFF128C5A),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () =>
                    ref.read(asmaAlHusnaProvider.notifier).toggleFavorite(name.id),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red[400] : context.appColors.textSecondary,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildInfoRow(
            context,
            icon: Icons.info_outline,
            title: 'الشرح',
            content: name.explanation,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            context,
            icon: Icons.favorite_outline,
            title: 'الأثر الإيماني',
            content: name.impact,
          ),
          if (name.evidence != null) ...[
            const SizedBox(height: 10),
            _buildInfoRow(
              context,
              icon: Icons.menu_book,
              title: 'الدليل',
              content: name.evidence!,
              isEvidence: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    bool isEvidence = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF128C5A).withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: context.appColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: TextStyle(
                  color: context.appColors.textPrimary,
                  fontSize: 14,
                  height: 1.5,
                  fontFamily: isEvidence ? 'uthmani' : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyFavorites(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: context.appColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لم تضف أي اسم إلى المفضلة بعد',
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على القلب بجانب الاسم لإضافته',
            style: TextStyle(
              color: context.appColors.textSecondary.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
