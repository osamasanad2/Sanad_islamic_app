import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HisnDuaItem {
  final String text;
  final String source;
  const HisnDuaItem({required this.text, required this.source});
}

class HisnCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<HisnDuaItem> duas;
  const HisnCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.duas,
  });
}

IconData _iconForCategory(String name) {
  if (name.contains('الصباح') || name.contains('المساء')) return Icons.wb_sunny_rounded;
  if (name.contains('النوم') || name.contains('الاستيقاظ') || name.contains('تقلب')) return Icons.bedtime_rounded;
  if (name.contains('الخروج من المنزل') || name.contains('الدخول المنزل')) return Icons.door_front_door_rounded;
  if (name.contains('الأكل') || name.contains('الطعام') || name.contains('الشرب')) return Icons.restaurant_rounded;
  if (name.contains('السفر') || name.contains('ركوب') || name.contains('المركوب')) return Icons.flight_rounded;
  if (name.contains('المسجد') || name.contains('الأذان')) return Icons.mosque_rounded;
  if (name.contains('الصلاة') || name.contains('السلام من الصلاة') || name.contains('الركوع') || name.contains('السجود') || name.contains('التشهد') || name.contains('الاستفتاح') || name.contains('الوتر')) return Icons.self_improvement_rounded;
  if (name.contains('القنوت') || name.contains('الاستخارة')) return Icons.nightlight_round_rounded;
  if (name.contains('الوضوء')) return Icons.water_drop_rounded;
  if (name.contains('الخلاء') || name.contains('الخلا')) return Icons.cleaning_services_rounded;
  if (name.contains('الثوب') || name.contains('اللبس')) return Icons.checkroom_rounded;
  if (name.contains('الهم') || name.contains('الحزن') || name.contains('الكرب')) return Icons.heart_broken_rounded;
  if (name.contains('العدو') || name.contains('السلطان') || name.contains('الظلم') || name.contains('خاف')) return Icons.shield_rounded;
  if (name.contains('الدين') || name.contains('القضاء')) return Icons.account_balance_rounded;
  if (name.contains('الوسوسة') || name.contains('الشيطان')) return Icons.auto_fix_high_rounded;
  if (name.contains('المرض') || name.contains('المريض') || name.contains('العيادة') || name.contains('وجع')) return Icons.local_hospital_rounded;
  if (name.contains('الميت') || name.contains('الموت') || name.contains('الجنائز') || name.contains('القبر') || name.contains('الدفن') || name.contains('الوفاة') || name.contains('المحتضر') || name.contains('المصيبة') || name.contains('التعزية') || name.contains('الزيارة')) return Icons.vertical_distribute_rounded;
  if (name.contains('المولود') || name.contains('الأولاد') || name.contains('الفرط')) return Icons.child_care_rounded;
  if (name.contains('المطر') || name.contains('الاستسقاء') || name.contains('الرعد') || name.contains('الريح')) return Icons.water_rounded;
  if (name.contains('الهلال') || name.contains('الصوم') || name.contains('الصائم') || name.contains('الإفطار')) return Icons.nights_stay_rounded;
  if (name.contains('العطاس')) return Icons.air_rounded;
  if (name.contains('الزوج') || name.contains('النكاح') || name.contains('الزواج')) return Icons.favorite_rounded;
  if (name.contains('الغضب')) return Icons.whatshot_rounded;
  if (name.contains('المجلس') || name.contains('الكلام')) return Icons.chat_rounded;
  if (name.contains('الدجال')) return Icons.warning_rounded;
  if (name.contains('الشرك')) return Icons.cleaning_services_rounded;
  if (name.contains('الطيرة')) return Icons.visibility_off_rounded;
  if (name.contains('السوق')) return Icons.shopping_cart_rounded;
  if (name.contains('الحج') || name.contains('العمرة') || name.contains('عرفة') || name.contains('المشعر') || name.contains('الصفا') || name.contains('المروة') || name.contains('الجمار') || name.contains('الركن')) return Icons.mosque_rounded;
  if (name.contains('التسبيح') || name.contains('الذكر') || name.contains('التحميد') || name.contains('التكبير') || name.contains('التهليل')) return Icons.repeat_rounded;
  if (name.contains('السلام') || name.contains('الكافر')) return Icons.emoji_people_rounded;
  if (name.contains('الصلاة على النبي') || name.contains('الشفاعة')) return Icons.self_improvement_rounded;
  if (name.contains('الاستغفار') || name.contains('التوبة')) return Icons.restore_rounded;
  if (name.contains('الساعة') || name.contains('القيامة')) return Icons.access_time_rounded;
  if (name.contains('المقدمة')) return Icons.menu_book_rounded;
  if (name.contains('فضل الذكر') || name.contains('فضل')) return Icons.star_rounded;
  if (name.contains('الديك') || name.contains('الكلاب') || name.contains('الحمار')) return Icons.pets_rounded;
  if (name.contains('الرؤيا') || name.contains('الحلم') || name.contains('الفزع')) return Icons.nightlight_round_rounded;
  if (name.contains('الذبح') || name.contains('النحر')) return Icons.restaurant_rounded;
  if (name.contains('كل شيء') || name.contains('الخير') || name.contains('الآداب')) return Icons.list_alt_rounded;
  if (name.contains('ما يقول') || name.contains('ما يفعل')) return Icons.record_voice_over_rounded;
  if (name.contains('المدح') || name.contains('الثناء')) return Icons.thumb_up_rounded;
  if (name.contains('الشراء') || name.contains('البائع')) return Icons.shopping_bag_rounded;
  if (name.contains('الدعاء لمن') || name.contains('جواب')) return Icons.reply_rounded;
  if (name.contains('العين') || name.contains('بعينه')) return Icons.visibility_rounded;
  return Icons.menu_book_rounded;
}

Color _colorForCategory(String name) {
  if (name.contains('الصباح') || name.contains('المساء')) return const Color(0xFFE8A040);
  if (name.contains('النوم') || name.contains('الاستيقاظ') || name.contains('تقلب') || name.contains('الرؤيا') || name.contains('الحلم')) return const Color(0xFF7B6B9E);
  if (name.contains('الخروج من المنزل') || name.contains('الدخول المنزل')) return const Color(0xFF4A8C7C);
  if (name.contains('الأكل') || name.contains('الطعام') || name.contains('الشرب') || name.contains('الذبح')) return const Color(0xFFC4865A);
  if (name.contains('السفر') || name.contains('ركوب') || name.contains('المركوب')) return const Color(0xFF5A8FA8);
  if (name.contains('المسجد') || name.contains('الأذان') || name.contains('الحج') || name.contains('العمرة')) return const Color(0xFF6A9A6A);
  if (name.contains('الصلاة') || name.contains('السلام من الصلاة') || name.contains('الركوع') || name.contains('السجود') || name.contains('التشهد')) return const Color(0xFF5A8A7A);
  if (name.contains('الاستفتاح') || name.contains('القنوت') || name.contains('الوتر') || name.contains('الاستخارة')) return const Color(0xFF7A6A9A);
  if (name.contains('الوضوء')) return const Color(0xFF4A8ABF);
  if (name.contains('الخلاء') || name.contains('الخلا')) return const Color(0xFF8A9A9A);
  if (name.contains('الثوب') || name.contains('اللبس')) return const Color(0xFF9A8A7A);
  if (name.contains('الهم') || name.contains('الحزن') || name.contains('الكرب')) return const Color(0xFFBF8A7A);
  if (name.contains('العدو') || name.contains('السلطان') || name.contains('الظلم') || name.contains('خاف')) return const Color(0xFF7A8ABF);
  if (name.contains('الدين') || name.contains('القضاء')) return const Color(0xFF6A8A6A);
  if (name.contains('الوسوسة') || name.contains('الشيطان') || name.contains('الشرك')) return const Color(0xFF9A7A7A);
  if (name.contains('المرض') || name.contains('المريض') || name.contains('العيادة') || name.contains('وجع')) return const Color(0xFFBF8A8A);
  if (name.contains('الميت') || name.contains('الموت') || name.contains('الجنائز') || name.contains('القبر') || name.contains('الدفن') || name.contains('الوفاة') || name.contains('المحتضر') || name.contains('المصيبة') || name.contains('التعزية') || name.contains('الزيارة')) return const Color(0xFF8A8A9A);
  if (name.contains('المولود') || name.contains('الأولاد') || name.contains('الفرط')) return const Color(0xFFBF9A7A);
  if (name.contains('المطر') || name.contains('الاستسقاء') || name.contains('الرعد') || name.contains('الريح')) return const Color(0xFF6A9ABF);
  if (name.contains('الهلال') || name.contains('الصوم') || name.contains('الصائم') || name.contains('الإفطار')) return const Color(0xFF7A8A9A);
  if (name.contains('العطاس')) return const Color(0xFF9ABF8A);
  if (name.contains('الزوج') || name.contains('النكاح') || name.contains('الزواج')) return const Color(0xFFBF8ABF);
  if (name.contains('الغضب')) return const Color(0xFFBF6A5A);
  if (name.contains('المجلس') || name.contains('الكلام')) return const Color(0xFF8ABF8A);
  if (name.contains('الدجال') || name.contains('الساعة') || name.contains('القيامة')) return const Color(0xFF8A7A6A);
  if (name.contains('الطيرة')) return const Color(0xFF9A8ABF);
  if (name.contains('السوق')) return const Color(0xFFBF8A6A);
  if (name.contains('التسبيح') || name.contains('الذكر') || name.contains('التحميد') || name.contains('التكبير') || name.contains('التهليل')) return const Color(0xFF6ABF8A);
  if (name.contains('السلام') || name.contains('الكافر')) return const Color(0xFF8ABF9A);
  if (name.contains('الصلاة على النبي') || name.contains('الشفاعة')) return const Color(0xFFBFBF8A);
  if (name.contains('الاستغفار') || name.contains('التوبة')) return const Color(0xFF8ABFBF);
  if (name.contains('المقدمة')) return const Color(0xFFBF9A8A);
  if (name.contains('فضل الذكر') || name.contains('فضل')) return const Color(0xFFD4AF37);
  if (name.contains('الديك') || name.contains('الكلاب') || name.contains('الحمار')) return const Color(0xFF9ABF7A);
  if (name.contains('الفزع')) return const Color(0xFFBF7A7A);
  if (name.contains('كل شيء') || name.contains('الخير') || name.contains('الآداب')) return const Color(0xFF7ABF9A);
  if (name.contains('ما يقول') || name.contains('ما يفعل')) return const Color(0xFF8A9ABF);
  if (name.contains('المدح') || name.contains('الثناء')) return const Color(0xFFBFBF7A);
  if (name.contains('الشراء') || name.contains('البائع')) return const Color(0xFFBF9A6A);
  if (name.contains('الدعاء لمن') || name.contains('جواب')) return const Color(0xFF9ABF8A);
  if (name.contains('العين') || name.contains('بعينه')) return const Color(0xFF8ABF7A);
  return const Color(0xFF8A9A7A);
}

class HisnAlmuslimRepository {
  static Future<List<HisnCategory>> load() async {
    final jsonString = await rootBundle.loadString('assets/data/hisn_almuslim.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    final categories = <HisnCategory>[];
    for (final entry in data.entries) {
      final name = entry.key;
      final item = entry.value as Map<String, dynamic>;
      final texts = (item['text'] as List<dynamic>).cast<String>();
      final footnotes = (item['footnote'] as List<dynamic>?)?.cast<String>() ?? [];

      final duas = <HisnDuaItem>[];
      for (int i = 0; i < texts.length; i++) {
        duas.add(HisnDuaItem(
          text: texts[i],
          source: i < footnotes.length ? footnotes[i] : '',
        ));
      }

      categories.add(HisnCategory(
        name: name,
        icon: _iconForCategory(name),
        color: _colorForCategory(name),
        duas: duas,
      ));
    }

    return categories;
  }
}
