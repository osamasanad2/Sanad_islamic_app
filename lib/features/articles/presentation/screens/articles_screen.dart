import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ArticleItem {
  final String title;
  final String description;
  final String fullContent;
  final String category;
  final IconData icon;
  final Color categoryColor;

  const ArticleItem({
    required this.title,
    required this.description,
    required this.fullContent,
    required this.category,
    required this.icon,
    required this.categoryColor,
  });
}

const List<ArticleItem> articlesData = [
  ArticleItem(
    title: 'أركان الإيمان الستة',
    description: 'تعرف على أركان الإيمان التي لا يصح إيمان العبد إلا بها',
    fullContent: 'أركان الإيمان ستة، كما جاء في حديث جبريل عليه السلام: الإيمان أن تؤمن بالله، وملائكته، وكتبه، ورسله، واليوم الآخر، وتؤمن بالقدر خيره وشره. الإيمان بالله: وهو التصديق الجازم بوجود الله وربوبيته وألوهيته وأسمائه وصفاته. الإيمان بالملائكة: خلق من نور، يعبدون الله ولا يعصونه. الإيمان بالكتب: الكتب السماوية التي أنزلها الله على رسله، وآخرها القرآن المهيمن عليها. الإيمان بالرسل: جميع الرسل من أولهم نوح إلى آخرهم محمد ﷺ. الإيمان باليوم الآخر: البعث والحساب والجنة والنار. الإيمان بالقدر: أن كل شيء بقضاء الله وقدره.',
    category: 'عقيدة',
    icon: Icons.star,
    categoryColor: Color(0xFF4CAF50),
  ),
  ArticleItem(
    title: 'فضل الصلاة وأهميتها في حياة المسلم',
    description: 'الصلاة عمود الدين وأهم ركن بعد الشهادتين',
    fullContent: 'الصلاة هي الركن الثاني من أركان الإسلام، وهي عمود الدين الذي لا يقوم إلا به. فرضها الله على النبي ﷺ ليلة الإسراء والمعراج. قال النبي ﷺ: "العهد الذي بيننا وبينهم الصلاة، فمن تركها فقد كفر". الصلاة تنهى عن الفحشاء والمنكر، وتقوي الصلة بين العبد وربه، وتغسل الذنوب والخطايا. قال تعالى: "إن الصلاة كانت على المؤمنين كتاباً موقوتاً". يجب المحافظة على الصلوات الخمس في أوقاتها بخشوع وتدبر.',
    category: 'فقه',
    icon: Icons.mosque,
    categoryColor: Color(0xFF2196F3),
  ),
  ArticleItem(
    title: 'التوكل على الله: معناه وثمراته',
    description: 'التوكل هو صدق الاعتماد على الله مع الأخذ بالأسباب',
    fullContent: 'التوكل على الله هو عبادة عظيمة من أجلّ العبادات، وهو صدق الاعتماد على الله والثقة به مع الأخذ بالأسباب المشروعة. قال تعالى: "وعلى الله فتوكلوا إن كنتم مؤمنين". التوكل لا ينافي الأخذ بالأسباب، بل هو جمع بينهما. فالمؤمن يأخذ بالأسباب التي شرعها الله، ثم يتوكل على الله في تحقيق النتائج. من ثمرات التوكل: كفاية الله للمتوكّل، وحفظه وتأييده، ورزقه من حيث لا يحتسب. قال تعالى: "ومن يتوكل على الله فهو حسبه".',
    category: 'رقائق',
    icon: Icons.verified,
    categoryColor: Color(0xFF9C27B0),
  ),
  ArticleItem(
    title: 'قصة الهجرة النبوية: دروس وعبر',
    description: 'الهجرة النبوية حدث تاريخي عظيم يحمل دروساً لكل مسلم',
    fullContent: 'الهجرة النبوية من مكة إلى المدينة هي نقطة تحول كبرى في تاريخ الإسلام. هاجر النبي ﷺ بعد أن أذن الله له، بعد 13 سنة من الدعوة في مكة. صحبه أبو بكر الصديق، واختبآ في غار ثور ثلاثة أيام. قصة سراقة بن مالك الذي لحق بهم ثم رجع بعد أن رأى الآية، وقصة أم معبد التي استضافتهم، كلها دروس في اليقين والتوكل. من الدروس: أن النصر مع الصبر، وأن العاقبة للمتقين، وأن الأرض لله يورثها من يشاء من عباده. الهجرة ليست مجرد انتقال مكان، بل هجرة إلى الله ورسوله.',
    category: 'سيرة',
    icon: Icons.flight_takeoff,
    categoryColor: Color(0xFFFF9800),
  ),
  ArticleItem(
    title: 'آداب الطعام والشراب في الإسلام',
    description: 'هدي النبي ﷺ في الطعام والشراب وآدابهما',
    fullContent: 'شرع الإسلام آداباً عظيمة للطعام والشراب تجعلها عبادة يؤجر عليها المسلم. من الآداب: التسمية قبل الأكل (بسم الله)، والأكل باليمين، والأكل مما يليه، وعدم عيب الطعام، وغسل اليدين قبل الأكل وبعده. قال النبي ﷺ: "يا غلام، سم الله، وكل بيمينك، وكل مما يليك". ومن الآداب: عدم الإسراف، وشرب الماء على ثلاث دفعات، والدعاء بعد الطعام (الحمد لله الذي أطعمنا وسقانا وجعلنا مسلمين).',
    category: 'فقه',
    icon: Icons.restaurant,
    categoryColor: Color(0xFF2196F3),
  ),
  ArticleItem(
    title: 'صفة صلاة النبي ﷺ',
    description: 'كيف كان النبي ﷺ يصلي؟ دليل عملي للصلاة الصحيحة',
    fullContent: 'كان النبي ﷺ يصلي كما أمره الله: يستقبل القبلة، يكبر تكبيرة الإحرام رافعاً يديه حذو منكبيه، يضع يده اليمنى على اليسرى على صدره، يقرأ الفاتحة وسورة بعدها، يركع مطمئناً بقدر تسبيحة، يرفع من الركوع قائلاً "سمع الله لمن حمده"، يسجد على سبعة أعضاء، يجلس بين السجدتين، ثم يسلم عن يمينه وشماله. قال ﷺ: "صلوا كما رأيتموني أصلي". السنة أن يطمئن المصلي في جميع أركان الصلاة.',
    category: 'فقه',
    icon: Icons.mosque,
    categoryColor: Color(0xFF2196F3),
  ),
  ArticleItem(
    title: 'ذكر الله: أنواعه وفضائله',
    description: 'الذكر غذاء الروح وأنيس المؤمن في حياته',
    fullContent: 'الذكر هو أعظم قربة يتقرب بها العبد إلى ربه. أنواع الذكر: ذكر اللسان (التسبيح والتحميد والتهليل والتكبير)، وذكر القلب (التفكر في ملكوت الله)، وذكر الجوارح (فعل الطاعات). قال تعالى: "فاذكروني أذكركم واشكروا لي ولا تكفرون". أفضل الذكر: لا إله إلا الله، وأفضل الدعاء: الحمد لله. من فضائل الذكر: طمأنينة القلب، ومغفرة الذنوب، ورفعة الدرجات، ودوام الصلة بالله. كان النبي ﷺ يذكر الله على كل أحيانه.',
    category: 'رقائق',
    icon: Icons.self_improvement,
    categoryColor: Color(0xFF9C27B0),
  ),
  ArticleItem(
    title: 'بر الوالدين: فضله وأحكامه',
    description: 'بر الوالدين من أعظم القربات وأوجب الواجبات',
    fullContent: 'بر الوالدين قرنها الله بتوحيده في عدة آيات، قال تعالى: "وقضى ربك ألا تعبدوا إلا إياه وبالوالدين إحساناً". بر الوالدين يشمل: طاعتهما في المعروف، الإنفاق عليهما، خفض الجناح لهما بالرحمة، الدعاء لهما، خدمتهما، إدخال السرور عليهما، عدم التضجر والتأفف منهما. بر الوالدين من أحب الأعمال إلى الله، قال النبي ﷺ لما سئل: أي العمل أحب إلى الله؟ قال: "الصلاة على وقتها". قيل: ثم أي؟ قال: "بر الوالدين".',
    category: 'أخلاق',
    icon: Icons.favorite,
    categoryColor: Color(0xFFE91E63),
  ),
  ArticleItem(
    title: 'الصبر: معناه وأنواعه وأجره',
    description: 'الصبر نصف الإيمان وطريق الفرج',
    fullContent: 'الصبر هو حبس النفس عن الجزع والتسخط، وحبس اللسان عن الشكوى، وحبس الجوارح عن فعل ما لا يرضي الله. أنواع الصبر ثلاثة: صبر على طاعة الله، وصبر عن محارم الله، وصبر على أقدار الله المؤلمة. قال تعالى: "إنما يوفى الصابرون أجرهم بغير حساب". الصبر مفتاح الفرج، قال النبي ﷺ: "واعلم أن النصر مع الصبر، وأن الفرج مع الكرب، وأن مع العسر يسراً". الصبر من صفات المؤمنين، بل هو نصف الإيمان.',
    category: 'رقائق',
    icon: Icons.hourglass_empty,
    categoryColor: Color(0xFF9C27B0),
  ),
  ArticleItem(
    title: 'الزكاة: أحكامها ومقاصدها',
    description: 'الزكاة الركن الثالث من أركان الإسلام وفريضة مالية',
    fullContent: 'الزكاة فريضة مالية شرعها الله تطهيراً للنفوس والأموال. قال تعالى: "خذ من أموالهم صدقة تطهرهم وتزكيهم بها". نصاب الزكاة: ما يعادل 85 جراماً من الذهب، ونسبة الزكاة 2.5%. مصارف الزكاة ثمانية: الفقراء، المساكين، العاملين عليها، المؤلفة قلوبهم، الرقاب، الغارمين، في سبيل الله، ابن السبيل. تستحب الزكاة في رمضان لمضاعفة الأجر، وتجب متى بلغ المال النصاب وحال عليه الحول. الزكاة تطهر المال وتنمي البركة وتدعم التكافل الاجتماعي.',
    category: 'فقه',
    icon: Icons.volunteer_activism,
    categoryColor: Color(0xFF2196F3),
  ),
];

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final Set<int> _expandedArticles = {};
  String? _selectedCategory;

  List<String> get _categories {
    final cats = articlesData.map((a) => a.category).toSet().toList();
    return cats;
  }

  List<ArticleItem> get _filteredArticles {
    if (_selectedCategory == null) return articlesData;
    return articlesData.where((a) => a.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredArticles;
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: Text(
          'المقالات',
          style: TextStyle(color: context.appColors.textPrimary),
        ),
        backgroundColor: context.appColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.appColors.textPrimary),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildCategoryFilter(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                physics: const BouncingScrollPhysics(),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return _buildArticleCard(filtered[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = (index == 0 && _selectedCategory == null) ||
              (index > 0 && _categories[index - 1] == _selectedCategory);
          final label = index == 0 ? 'الكل' : _categories[index - 1];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = index == 0 ? null : _categories[index - 1];
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : context.appColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : context.appColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleCard(ArticleItem article, int index) {
    final isExpanded = _expandedArticles.contains(index);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: article.categoryColor.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedArticles.remove(index);
                } else {
                  _expandedArticles.add(index);
                }
              });
            },
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: article.categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(article.icon, color: article.categoryColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: article.categoryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            article.category,
                            style: TextStyle(
                              color: article.categoryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.appColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          article.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.appColors.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isExpanded ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: context.appColors.textSecondary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.appColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  article.fullContent,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.appColors.textPrimary,
                    height: 1.7,
                  ),
                ),
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
