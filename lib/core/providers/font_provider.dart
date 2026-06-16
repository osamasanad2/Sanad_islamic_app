import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';

class FontOption {
  final String id;
  final String name;

  const FontOption({required this.id, required this.name});

  static const List<FontOption> options = [
    FontOption(id: 'Cairo', name: 'القاهرة (Cairo)'),
    FontOption(id: 'Tajawal', name: 'تاجوال (Tajawal)'),
    FontOption(id: 'NotoNaskhArabic', name: 'نوتو ناسخ (Noto Naskh)'),
    FontOption(id: 'Amiri', name: 'أميري (Amiri)'),
    FontOption(id: 'IBMPlexSansArabic', name: 'آي بي إم بلكس (IBM Plex)'),
  ];
}

final fontProvider = NotifierProvider<FontNotifier, String>(FontNotifier.new);

class FontNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final stored = prefs.getString('app_font') ?? 'Cairo';
    if (stored == 'ArefRuqaa') return 'Cairo';
    return stored;
  }

  Future<void> setFont(String fontId) async {
    state = fontId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_font', fontId);
  }
}
