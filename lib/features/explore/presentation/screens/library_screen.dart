import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/book_model.dart';
import '../../data/library_provider.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(libraryProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48,
                    color: context.appColors.error),
                const SizedBox(height: 16),
                Text('فشل تحميل المكتبة',
                    style: TextStyle(color: context.appColors.textPrimary)),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(libraryProvider.notifier).retry(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
          data: (data) {
            if (data.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: context.appColors.background,
                  title: Text(
                    'المكتبة الإسلامية',
                    style: TextStyle(
                      color: context.appColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(70.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16.0, 0.0, 16.0, 16.0),
                      child: _buildSearchBar(context),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildCategoriesRow(context, data),
                  ),
                ),
                if (data.books.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 64,
                              color: context.appColors.textSecondary),
                          const SizedBox(height: 16),
                          Text(
                            data.searchQuery.isEmpty
                                ? 'لا توجد كتب في هذا التصنيف'
                                : 'لا توجد نتائج للبحث',
                            style: TextStyle(
                              color: context.appColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final book = data.books[index];
                          return _buildBookCard(context, book, index)
                              .animate()
                              .fadeIn(
                                  delay: (50 * (index % 10)).ms,
                                  duration: 300.ms)
                              .slideX(
                                  begin: 0.05,
                                  duration: 300.ms,
                                  curve: Curves.easeOut);
                        },
                        childCount: data.books.length,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
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
        onChanged: (v) =>
            ref.read(libraryProvider.notifier).search(v),
        decoration: InputDecoration(
          hintText: 'ابحث عن كتاب، مؤلف، أو تصنيف...',
          hintStyle: TextStyle(
            color: context.appColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon:
              const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(libraryProvider.notifier).search('');
                  },
                )
              : null,
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

  Widget _buildCategoriesRow(
      BuildContext context, LibraryState data) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: data.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = data.categories[index];
          final isSelected = cat == data.selectedCategory;
          return GestureDetector(
            onTap: () =>
                ref.read(libraryProvider.notifier).setCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : context.appColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : context.appColors.textSecondary
                          .withValues(alpha: 0.2),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : context.appColors.textPrimary,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookCard(
      BuildContext context, Book book, int index) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final icon = book.categoryIcon;
    final color = book.categoryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: GestureDetector(
        onTap: () => context.push('/library/book', extra: book),
        child: Container(
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topRight: isRtl ? const Radius.circular(0) : Radius.circular(20),
                      bottomRight: isRtl ? const Radius.circular(0) : Radius.circular(20),
                      topLeft: isRtl ? Radius.circular(20) : const Radius.circular(0),
                      bottomLeft: isRtl ? Radius.circular(20) : const Radius.circular(0),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(icon, color: color, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: context.appColors.textPrimary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.person_outline,
                                          size: 14,
                                          color: context
                                              .appColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          book.author,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: context
                                                .appColors.textSecondary,
                                          ),
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (book.featured)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.gold
                                      .withValues(alpha: 0.15),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome,
                                        size: 12,
                                        color: AppColors.gold),
                                    const SizedBox(width: 3),
                                    Text(
                                      'مميز',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.gold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          book.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.appColors.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildInfoChip(
                                Icons.collections_bookmark,
                                '${book.chaptersCount} فصل',
                                color),
                            const SizedBox(width: 12),
                            _buildInfoChip(
                                Icons.description_outlined,
                                '${book.pagesCount} صفحة',
                                color),
                            const Spacer(),
                            Icon(Icons.arrow_back_ios_new,
                                size: 14,
                                color: context.appColors.textSecondary),
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
      ),
    );
  }

  Widget _buildInfoChip(
      IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: color.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
