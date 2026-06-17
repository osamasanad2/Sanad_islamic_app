import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('سياسة الخصوصية'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionCard(
              context: context,
              sections: [
                _Section(
                  title: 'المقدمة',
                  content: 'نحن في تطبيق "سند" نولي خصوصية مستخدمينا أهمية بالغة. '
                      'توضح سياسة الخصوصية هذه كيفية جمع واستخدام وحماية المعلومات الشخصية '
                      'التي تقدمها عند استخدام تطبيق "سند". باستخدامك للتطبيق، فإنك توافق '
                      'على جمع واستخدام المعلومات وفقاً لهذه السياسة.',
                ),
                _Section(
                  title: 'جمع المعلومات',
                  content: 'قد نقوم بجمع الأنواع التالية من المعلومات:\n\n'
                      '• المعلومات الشخصية: مثل الاسم والبريد الإلكتروني عند إنشاء حساب.\n'
                      '• معلومات الاستخدام: مثل الصفحات التي تزورها والميزات التي تستخدمها.\n'
                      '• معلومات الجهاز: مثل نوع الجهاز ونظام التشغيل والإصدار.\n'
                      '• المفضلات والإعدادات: مثل تفضيلات الأذكار والقراءة والإشعارات.\n\n'
                      'نحن لا نجمع أي معلومات حساسة دون موافقة صريحة منك.',
                ),
                _Section(
                  title: 'استخدام المعلومات',
                  content: 'نستخدم المعلومات التي نجمعها للأغراض التالية:\n\n'
                      '• تقديم وتحسين خدمات التطبيق.\n'
                      '• تخصيص تجربتك داخل التطبيق.\n'
                      '• إرسال إشعارات حول مواقيت الصلاة والأذكار.\n'
                      '• تحسين أداء التطبيق وإصلاح الأخطاء.\n'
                      '• التواصل معك بخصوص دعم المستخدم.\n\n'
                      'نحن لا نبيع معلوماتك الشخصية إلى أطراف ثالثة تحت أي ظرف.',
                ),
                _Section(
                  title: 'حماية المعلومات',
                  content: 'نتخذ إجراءات أمنية مناسبة لحماية معلوماتك من الوصول غير المصرح به، '
                      'أو التعديل، أو الإفشاء، أو الإتلاف. تشمل هذه الإجراءات:\n\n'
                      '• تشفير البيانات أثناء النقل.\n'
                      '• تخزين آمن للبيانات.\n'
                      '• تقييد الوصول إلى المعلومات الشخصية.\n'
                      '• مراجعة دورية لممارسات جمع البيانات.\n\n'
                      'ومع ذلك، لا يمكن ضمان أمان مطلق للبيانات المنقولة عبر الإنترنت.',
                ),
                _Section(
                  title: 'حقوق المستخدم',
                  content: 'لديك الحقوق التالية فيما يتعلق بمعلوماتك الشخصية:\n\n'
                      '• الحق في الوصول إلى معلوماتك الشخصية.\n'
                      '• الحق في تصحيح أي معلومات غير دقيقة.\n'
                      '• الحق في حذف معلوماتك الشخصية.\n'
                      '• الحق في تقييد معالجة بياناتك.\n'
                      '• الحق في سحب الموافقة في أي وقت.\n'
                      '• الحق في تصدير بياناتك.\n\n'
                      'يمكنك ممارسة هذه الحقوق عن طريق التواصل معنا.',
                ),
                _Section(
                  title: 'التعديلات',
                  content: 'قد نقوم بتحديث سياسة الخصوصية هذه من وقت لآخر. سنقوم بإعلامك '
                      'بأي تغييرات عن طريق نشر السياسة الجديدة في التطبيق. ننصحك بمراجعة '
                      'هذه الصفحة بشكل دوري للاطلاع على أي تغييرات.',
                ),
                _Section(
                  title: 'اتصل بنا',
                  content: 'إذا كانت لديك أي أسئلة أو استفسارات حول سياسة الخصوصية هذه، '
                      'يرجى التواصل معنا عبر البريد الإلكتروني:\n\n'
                      'sanad.app@email.com',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'آخر تحديث: يناير 2026',
                style: TextStyle(
                  fontSize: 13,
                  color: context.appColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Section {
  final String title;
  final String content;
  const _Section({required this.title, required this.content});
}

class _SectionCard extends StatelessWidget {
  final BuildContext context;
  final List<_Section> sections;

  const _SectionCard({required this.context, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(sections.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey.shade200);
          }
          final section = sections[index ~/ 2];
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      section.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  section.content,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
