import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/fiqh_data.dart';

class FiqhScreen extends StatefulWidget {
  const FiqhScreen({super.key});

  @override
  State<FiqhScreen> createState() => _FiqhScreenState();
}

class _FiqhScreenState extends State<FiqhScreen> {
  List<FiqhSection>? _sections;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sections = await loadFiqhSections();
    if (mounted) {
      setState(() {
        _sections = sections;
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
          'فقه العبادات',
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
          : _sections == null
              ? Center(
                  child: Text('لا توجد بيانات',
                      style: TextStyle(color: context.appColors.textSecondary)))
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader(context)),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildSectionCard(context, _sections![index]),
                          childCount: _sections!.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'فقه العبادات',
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'تعلم أحكام العبادات اليومية وفق الكتاب والسنة',
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, FiqhSection section) {
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
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: context.appColors.textSecondary,
        collapsedIconColor: context.appColors.textSecondary,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: section.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(section.icon, color: section.color, size: 24),
        ),
        title: Text(
          section.title,
          style: TextStyle(
            color: context.appColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        childrenPadding:
            const EdgeInsets.fromLTRB(18, 0, 18, 18),
        children: section.items
            .map((item) => _buildItemRow(context, item))
            .toList(),
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, FiqhItem item) {
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
            children: [
              Icon(Icons.title_rounded, size: 14,
                  color: const Color(0xFF0F5A3A)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                      item.displayText,
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontSize: 14,
                        height: 1.7,
                        fontFamily: item.type == 'ayah' ? 'uthmani' : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.source_outlined, size: 12,
                            color: context.appColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.reference != null
                                ? '${item.source} - ${item.reference}'
                                : item.source,
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
                  Clipboard.setData(ClipboardData(text: item.displayText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('تم النسخ',
                          textAlign: TextAlign.center),
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
                  child: Icon(Icons.copy_rounded, size: 18,
                      color: context.appColors.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
