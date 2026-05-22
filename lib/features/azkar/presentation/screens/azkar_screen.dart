import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/azkar_data.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});
  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  int _selectedCategory = 0;
  bool _isPlayingAll = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'الصباح', 'icon': Icons.wb_sunny_rounded, 'color': Colors.orange},
    {'name': 'المساء', 'icon': Icons.nights_stay_rounded, 'color': Colors.indigo},
    {'name': 'النوم', 'icon': Icons.bed_rounded, 'color': Colors.deepPurple},
    {'name': 'بعد الصلاة', 'icon': Icons.mosque_rounded, 'color': Colors.teal},
  ];

  // Each category has its own list of azkar with remaining counts
  late final List<List<Map<String, dynamic>>> _azkarData;

  @override
  void initState() {
    super.initState();
    // Create a deep copy of the static data so modifications to 'remaining' 
    // don't affect the original template data when reopening the screen.
    _azkarData = AzkarData.azkarData.map((category) {
      return category.map((zikr) => Map<String, dynamic>.from(zikr)).toList();
    }).toList();
  }

  List<Map<String, dynamic>> get _currentAzkar => _azkarData[_selectedCategory];
  Map<String, dynamic> get _currentCat => _categories[_selectedCategory];
  Color get _accent => _currentCat['color'] as Color;

  int get _completedCount => _currentAzkar.where((z) => (z['remaining'] as int) == 0).length;
  double get _progress => _currentAzkar.isEmpty ? 0 : _completedCount / _currentAzkar.length;

  void _decrementZikr(int index) {
    final zikr = _currentAzkar[index];
    if ((zikr['remaining'] as int) > 0) {
      setState(() => zikr['remaining'] = (zikr['remaining'] as int) - 1);
      if (zikr['remaining'] == 0) {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildCategorySelector().animate().fadeIn(delay: 100.ms),
            _buildProgressHeader().animate().fadeIn(delay: 200.ms),
            Expanded(child: _buildAzkarList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => context.pop()),
          const Spacer(),
          const Text('أذكاري', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
          const Spacer(),
          // Play All button
          GestureDetector(
            onTap: () => setState(() => _isPlayingAll = !_isPlayingAll),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isPlayingAll ? _accent : _accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_isPlayingAll ? Icons.pause : Icons.play_arrow, color: _isPlayingAll ? Colors.white : _accent, size: 18),
                  const SizedBox(width: 4),
                  Text('تشغيل', style: TextStyle(color: _isPlayingAll ? Colors.white : _accent, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) {
          final cat = _categories[i];
          final isSelected = i == _selectedCategory;
          final c = cat['color'] as Color;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              decoration: BoxDecoration(
                color: isSelected ? c : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? c : c.withValues(alpha: 0.2), width: 1.5),
                boxShadow: isSelected ? [BoxShadow(color: c.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))] : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icon'] as IconData, color: isSelected ? Colors.white : c, size: 28),
                  const SizedBox(height: 6),
                  Text(cat['name'] as String, style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48, height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _progress, strokeWidth: 5,
                  backgroundColor: _accent.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(_accent),
                  strokeCap: StrokeCap.round,
                ),
                Text('${(_progress * 100).toInt()}%', style: TextStyle(color: _accent, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _progress >= 1.0 ? 'ما شاء الله! أتممت أذكار ${_currentCat['name']} 🎉' : 'أذكار ${_currentCat['name']} — $_completedCount من ${_currentAzkar.length}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: _progress >= 1.0 ? 14 : 13),
                ),
                if (_progress < 1.0)
                  Text('اضغط على الذكر للعدّ، اضغط ⓘ لفضل الذكر', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAzkarList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: _currentAzkar.length,
      itemBuilder: (ctx, i) {
        final zikr = _currentAzkar[i];
        final remaining = zikr['remaining'] as int;
        final total = zikr['total'] as int;
        final isDone = remaining == 0;
        final progress = 1.0 - (remaining / total);

        return GestureDetector(
          onTap: () => _decrementZikr(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDone ? _accent.withValues(alpha: 0.08) : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDone ? _accent.withValues(alpha: 0.4) : Colors.grey.shade200, width: isDone ? 2 : 1),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        zikr['text'] as String,
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, height: 1.5,
                          color: isDone ? _accent : AppColors.textPrimary,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          decorationColor: _accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Info button
                    GestureDetector(
                      onTap: () => _showFadlDialog(zikr),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: _accent.withValues(alpha: 0.1)),
                        child: Icon(Icons.info_outline, color: _accent, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Counter badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDone ? _accent : _accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isDone ? '✓' : '$remaining',
                        style: TextStyle(color: isDone ? Colors.white : _accent, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress, minHeight: 5,
                          backgroundColor: _accent.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(isDone ? _accent : _accent.withValues(alpha: 0.5)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('$total', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (100 * i).ms).slideX(begin: 0.05);
      },
    );
  }

  void _showFadlDialog(Map<String, dynamic> zikr) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: _accent.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(Icons.auto_awesome, color: _accent, size: 28),
              ),
              const SizedBox(height: 16),
              Text(zikr['text'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _accent), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.format_quote, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(zikr['fadl'] as String, style: const TextStyle(color: AppColors.textPrimary, height: 1.6, fontSize: 14))),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('العدد المطلوب: ${zikr['total']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
