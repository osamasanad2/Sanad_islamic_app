import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/hisn_model.dart';

class HisnDetailsScreen extends StatefulWidget {
  final HisnCategory category;
  final Color color;

  const HisnDetailsScreen({
    super.key,
    required this.category,
    required this.color,
  });

  @override
  State<HisnDetailsScreen> createState() => _HisnDetailsScreenState();
}

class _HisnDetailsScreenState extends State<HisnDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final azkar = widget.category.azkar;

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: Column(
        children: [
          // Header
          _buildHeader(azkar.length),
          // Page view for azkar
          Expanded(
            child: azkar.isEmpty
                ? const Center(child: Text('لا توجد أذكار في هذا القسم'))
                : PageView.builder(
                    controller: _pageController,
                    itemCount: azkar.length,
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildZikrCard(azkar[index], index, azkar.length);
                    },
                  ),
          ),
          // Bottom Navigation
          _buildBottomNav(azkar.length),
        ],
      ),
    );
  }

  Widget _buildHeader(int total) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.color.withValues(alpha: 0.9),
            widget.color,
            HSLColor.fromColor(widget.color)
                .withHue((HSLColor.fromColor(widget.color).hue + 30) % 360)
                .toColor(),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
        child: Column(
          children: [
            // Top row
            Row(
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: () => context.pop(),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    widget.category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                // Counter badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentPage + 1} / $total',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: total > 0 ? (_currentPage + 1) / total : 0,
                  minHeight: 4,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildZikrCard(HisnZikr zikr, int index, int total) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        children: [
          // Main card
          Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.appColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Decorative top
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Zikr text
                    SelectableText(
                      _cleanText(zikr.text),
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontSize: 20,
                        height: 2.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 24),
                    // Decorative bottom
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: 100.ms)
              .scale(begin: const Offset(0.97, 0.97)),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                icon: Icons.copy_rounded,
                label: 'نسخ',
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _cleanText(zikr.text)));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'تم النسخ ✓',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: widget.color,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              _buildActionButton(
                icon: Icons.share_rounded,
                label: 'مشاركة',
                onTap: () {
                  Share.share(
                    '${widget.category.name}\n\n${_cleanText(zikr.text)}\n\n— حصن المسلم 📖',
                  );
                },
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),
          // Footnotes
          if (widget.category.footnotes.isNotEmpty &&
              index == widget.category.azkar.length - 1) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber.shade700,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'المصادر',
                        style: TextStyle(
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...widget.category.footnotes.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• $f',
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: widget.color.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: widget.color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(int total) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous
          _buildNavButton(
            icon: Icons.arrow_back_ios_rounded,
            enabled: _currentPage > 0,
            onTap: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
              );
            },
          ),
          const Spacer(),
          // Page dots (show max 7)
          _buildPageDots(total),
          const Spacer(),
          // Next
          _buildNavButton(
            icon: Icons.arrow_forward_ios_rounded,
            enabled: _currentPage < total - 1,
            onTap: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2);
  }

  Widget _buildNavButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled ? widget.color : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.grey.shade400,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildPageDots(int total) {
    if (total <= 7) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(total, (i) => _dot(i == _currentPage)),
      );
    }
    // Show condensed dots for large counts
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_currentPage > 1) _dot(false),
        if (_currentPage > 2)
          const Text('  ·  ', style: TextStyle(color: Colors.grey)),
        if (_currentPage > 0) _dot(false),
        _dot(true),
        if (_currentPage < total - 1) _dot(false),
        if (_currentPage < total - 3)
          const Text('  ·  ', style: TextStyle(color: Colors.grey)),
        if (_currentPage < total - 2) _dot(false),
      ],
    );
  }

  Widget _dot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? widget.color : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  String _cleanText(String text) {
    // Remove asterisks and extra whitespace
    return text.replaceAll('*', '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
