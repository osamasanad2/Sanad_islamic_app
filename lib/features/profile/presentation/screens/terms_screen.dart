import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

class TermsScreen extends ConsumerWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: const Text('شروط الاستخدام'),
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
                  content: 'مرحباً بك في تطبيق "سند". باستخدامك لهذا التطبيق، فإنك توافق على '
                      'الالتزام بشروط الاستخدام هذه. إذا كنت لا توافق على أي جزء من هذه '
                      'الشروط، يرجى عدم استخدام التطبيق. نحن نحتفظ بالحق في تحديث هذه '
                      'الشروط في أي وقت.',
                ),
                _Section(
                  title: 'الشروط والأحكام',
                  content: 'عند استخدام تطبيق "سند"، فإنك تتعهد بما يلي:\n\n'
                      '• استخدام التطبيق للأغراض المشروعة فقط.\n'
                      '• عدم انتهاك القوانين واللوائح المحلية.\n'
                      '• تقديم معلومات دقيقة عند إنشاء حساب.\n'
                      '• الحفاظ على سرية معلومات حسابك.\n'
                      '• عدم استخدام التطبيق لأي نشاط غير قانوني.\n'
                      '• عدم محاولة الوصول غير المصرح به إلى أنظمة التطبيق.\n\n'
                      'يجب أن يكون عمرك 13 عاماً على الأقل لاستخدام هذا التطبيق.',
                ),
                _Section(
                  title: 'المسؤوليات',
                  content: 'تطبيق "سند" يقدم محتوى إسلامياً وتعليمياً لأغراض إعلامية ودينية. '
                      'نحن نبذل قصارى جهدنا لضمان دقة المعلومات المقدمة، لكننا لا نضمن '
                      'اكتمالها أو خلوه من الأخطاء.\n\n'
                      '• التطبيق لا يتحمل مسؤولية أي قرارات تتخذها بناءً على المحتوى المقدم.\n'
                      '• المحتوى الديني يقدم كمرجع وليس كفتوى ملزمة.\n'
                      '• يجب استشارة أهل العلم في الأمور الدينية الدقيقة.\n'
                      '• نحن غير مسؤولين عن أي أضرار ناتجة عن استخدام التطبيق.',
                ),
                _Section(
                  title: 'الملكية الفكرية',
                  content: 'جميع المحتويات في تطبيق "سند"، بما في ذلك النصوص والرسومات '
                      'والشعارات والصور، هي ملك لتطبيق "سند" أو مرخصة لنا. هذه المحتويات '
                      'محمية بموجب قوانين الملكية الفكرية.\n\n'
                      '• لا يجوز نسخ أو توزيع أو تعديل محتوى التطبيق دون إذن خطي.\n'
                      '• النصوص القرآنية والأدعية هي وقف لله ولا تطبق عليها قيود الملكية.\n'
                      '• الأذكار والأدعية المأثورة هي من التراث الإسلامي المشاع.',
                ),
                _Section(
                  title: 'المحتوى',
                  content: 'يقدم تطبيق "سند" المحتويات التالية:\n\n'
                      '• القرآن الكريم مع تلاوات وتفاسير.\n'
                      '• الأذكار والأدعية المأثورة.\n'
                      '• مواقيت الصلاة والقبلة.\n'
                      '• محتوى تعليمي إسلامي.\n'
                      '• كتب ومقالات إسلامية.\n\n'
                      'نحن نسعى لتقديم محتوى دقيق وموثوق، ونرحب بملاحظاتك حول أي '
                      'أخطاء أو معلومات غير دقيقة.',
                ),
                _Section(
                  title: 'إنهاء الخدمة',
                  content: 'نحتفظ بالحق في تعليق أو إنهاء وصولك إلى التطبيق في أي وقت، '
                      'بدون إشعار مسبق، إذا انتهكت شروط الاستخدام هذه أو قمت بأي نشاط '
                      'قد يضر بالتطبيق أو مستخدميه.\n\n'
                      '• يمكنك حذف حسابك في أي وقت من إعدادات التطبيق.\n'
                      '• عند إنهاء الخدمة، ستستمر بعض الأحكام في السريان.\n'
                      '• قد نحتفظ ببعض المعلومات للامتثال للالتزامات القانونية.',
                ),
                _Section(
                  title: 'القوانين المنظمة',
                  content: 'تخضع شروط الاستخدام هذه وتفسر وفقاً لقوانين المملكة العربية '
                      'السعودية. أي نزاع ينشأ عن هذه الشروط سيتم حله عن طريق التحكيم '
                      'في المدينة المنورة.\n\n'
                      'إذا تم اعتبار أي شرط من هذه الشروط غير قانوني أو غير قابل للتنفيذ، '
                      'فستظل الشروط المتبقية سارية المفعول.',
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
