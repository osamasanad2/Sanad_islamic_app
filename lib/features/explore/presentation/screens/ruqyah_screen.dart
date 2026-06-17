import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/ruqyah_data.dart';

class RuqyahScreen extends StatefulWidget {
  const RuqyahScreen({super.key});

  @override
  State<RuqyahScreen> createState() => _RuqyahScreenState();
}

class _RuqyahScreenState extends State<RuqyahScreen> {
  List<RuqyahCategory>? _categories;
  final Set<String> _expandedIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cats = await loadRuqyahCategories();
    if (mounted) {
      setState(() {
        _categories = cats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        backgroundColor: context.appColors.background,
        elevation: 0,
        title: Text(
          'الرقية الشرعية',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories == null || _categories!.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد بيانات',
                    style: TextStyle(color: context.appColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: _categories!.length,
                  itemBuilder: (context, index) {
                    final cat = _categories![index];
                    final isExpanded = _expandedIds.contains(cat.id);
                    return _buildCategoryCard(context, cat, isExpanded);
                  },
                ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, RuqyahCategory cat, bool isExpanded) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedIds.remove(cat.id);
                } else {
                  _expandedIds.add(cat.id);
                }
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cat.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(cat.icon, color: cat.color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      cat.title,
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.appColors.textSecondary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: context.appColors.textSecondary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                children: cat.items
                    .map((item) => _buildItemRow(context, item))
                    .toList(),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, RuqyahItem item) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.type == 'ayah'
            ? const Color(0xFF0F5A3A).withValues(alpha: 0.05)
            : const Color(0xFF128C5A).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (item.type == 'ayah'
                  ? const Color(0xFF0F5A3A)
                  : const Color(0xFF128C5A))
              .withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (item.type == 'ayah'
                          ? const Color(0xFF0F5A3A)
                          : const Color(0xFF128C5A))
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  size: 16,
                  color: item.type == 'ayah'
                      ? const Color(0xFF0F5A3A)
                      : const Color(0xFF128C5A),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.text,
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontSize: 15,
                        height: 1.7,
                        fontFamily: item.type == 'ayah' ? 'uthmani' : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.source_outlined,
                          size: 12,
                          color: context.appColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${item.source} - ${item.reference}',
                            style: TextStyle(
                              color: context.appColors.textSecondary,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: item.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم النسخ',
                        textAlign: TextAlign.center,
                      ),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      backgroundColor: const Color(0xFF0F5A3A),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.appColors.textSecondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
