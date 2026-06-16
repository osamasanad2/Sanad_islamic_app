import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/providers/font_provider.dart';

class FontSettingsScreen extends ConsumerWidget {
  const FontSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFont = ref.watch(fontProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      appBar: AppBar(
        title: const Text('الخطوط'),
        backgroundColor: const Color(0xFF0E6B3A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اختر خط التطبيق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'اختر الخط الذي تفضله لعرض المحتوى في جميع أنحاء التطبيق',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...FontOption.options.map(
            (font) => _FontTile(
              font: font,
              isSelected: currentFont == font.id,
              onTap: () {
                ref.read(fontProvider.notifier).setFont(font.id);
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildPreview(context, currentFont),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context, String fontFamily) {
    final previewFont = GoogleFonts.getFont(fontFamily);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0E6B3A).withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E6B3A).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.text_fields, color: const Color(0xFF0E6B3A), size: 20),
              const SizedBox(width: 8),
              Text(
                'معاينة حية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0E6B3A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text(
            'بسم الله الرحمن الرحيم',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A2E),
            ).merge(previewFont),
          ),
          const SizedBox(height: 12),
          Text(
            '﴿ إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ ﴾',
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: const Color(0xFF2E7D32),
            ).merge(previewFont),
          ),
          const SizedBox(height: 12),
          Text(
            'الحمد لله رب العالمين، والصلاة والسلام على أشرف الأنبياء والمرسلين. أما بعد: فهذا تطبيق سند الإسلامي،\nنسأل الله أن ينفع به.',
            style: TextStyle(
              fontSize: 14,
              height: 1.7,
              color: const Color(0xFF555555),
            ).merge(previewFont),
          ),
        ],
      ),
    );
  }
}

class _FontTile extends StatelessWidget {
  final FontOption font;
  final bool isSelected;
  final VoidCallback onTap;

  const _FontTile({
    required this.font,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final previewTextStyle = GoogleFonts.getFont(font.id, fontSize: 18);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0E6B3A).withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF0E6B3A)
              : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        font.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ).merge(previewTextStyle),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'السلام عليكم ورحمة الله وبركاته',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ).merge(previewTextStyle),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0E6B3A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
