import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class FatawaItem {
  final String question;
  final String answer;
  final String category;
  final IconData icon;

  const FatawaItem({
    required this.question,
    required this.answer,
    required this.category,
    required this.icon,
  });
}

const List<FatawaItem> fatawaData = [
  FatawaItem(
    question: 'ما حكم من ترك صلاة الفجر عمداً حتى طلعت الشمس؟',
    answer: 'من ترك صلاة الفجر حتى طلعت الشمس فعليه أن يصليها قضاءً فور تذكرها، مع التوبة النصوح إلى الله. والواجب على المسلم المحافظة على جميع الصلوات في أوقاتها. قال النبي ﷺ: "من نام عن صلاة أو نسيها فليصلها إذا ذكرها". والأفضل أن يقضيها بعد طلوع الشمس بنصف ساعة تقريباً.',
    category: 'الصلاة',
    icon: Icons.mosque,
  ),
  FatawaItem(
    question: 'ما حكم إفطار المريض في رمضان؟',
    answer: 'يجوز للمريض الذي يشق عليه الصوم أو يضره أن يفطر في رمضان، وعليه قضاء الأيام التي أفطرها بعد أن يشفيه الله. قال تعالى: "فمن كان منكم مريضاً أو على سفر فعدة من أيام أخر". أما إذا كان المرض مزمناً لا يرجى برؤه، فيجب عليه إطعام مسكين عن كل يوم.',
    category: 'الصيام',
    icon: Icons.restaurant,
  ),
  FatawaItem(
    question: 'ما هو نصاب الزكاة وكيف تحسب؟',
    answer: 'نصاب الزكاة هو ما يعادل 85 جراماً من الذهب عيار 21. فإذا بلغ المال هذا النصاب وحال عليه الحول (سنة قمرية)، وجبت فيه الزكاة بنسبة 2.5% (ربع العشر). وتخرج الزكاة للأصناف الثمانية التي ذكرها الله في سورة التوبة: الفقراء، المساكين، العاملين عليها، المؤلفة قلوبهم، وفي الرقاب، والغارمين، وفي سبيل الله، وابن السبيل.',
    category: 'الزكاة',
    icon: Icons.calculate,
  ),
  FatawaItem(
    question: 'ما حكم الزواج عن طريق مواقع التعارف والتواصل الاجتماعي؟',
    answer: 'يجوز التعارف بغرض الزواج عبر وسائل التواصل بشرط أن يكون ذلك بضوابط شرعية: غض البصر، وعدم الخلوة، وأن يكون الكلام في حدود الأدب والاحترام وبهدف التعرف الجاد للزواج. ويُفضل أن يكون هناك وسيط ثقة (ولي أو محرم) للإشراف على التواصل. ويجب التحري الجاد عن الطرف الآخر قبل إتمام العقد.',
    category: 'النكاح',
    icon: Icons.favorite,
  ),
  FatawaItem(
    question: 'ما حكم الربا وأنواعه في الإسلام؟',
    answer: 'الربا محرم قطعاً بنص القرآن والسنة والإجماع. قال تعالى: "وأحل الله البيع وحرم الربا". والربا نوعان: ربا الفضل (بيع الذهب بالذهب متفاضلاً) وربا النسيئة (تأخير الدين مع زيادة). ويشمل الربا المعاملات البنكية الربوية، والقروض بفائدة، وبطاقات الائتمان التي تفرض فوائد. على المسلم أن يتجنب الربا ويتوب إلى الله مما مضى.',
    category: 'المعاملات',
    icon: Icons.monetization_on,
  ),
  FatawaItem(
    question: 'ما حكم الاستماع إلى القرآن أثناء العمل أو القيادة؟',
    answer: 'يستحب الاستماع إلى القرآن في كل وقت، سواء في العمل أو أثناء القيادة، وهو من ذكر الله وفيه خير عظيم. لكن ينبغي الإنصات والتدبر عند سماع آيات السجدة أو عند قراءة الإمام في الصلاة. والأفضل أن يجعل الإنسان وقتاً خاصاً لقراءة القرآن وتدبره بعيداً عن المشاغل.',
    category: 'القرآن',
    icon: Icons.menu_book,
  ),
  FatawaItem(
    question: 'ما حكم صلاة التراويح في البيت منفرداً؟',
    answer: 'صلاة التراويح سنة مؤكدة، ويجوز أداؤها في المسجد جماعة أو في البيت منفرداً. والأفضل أن يصليها المسلم في المسجد مع الجماعة لأنه أجمل وأكثر أجراً، خاصة للرجال. لكن إن صلى في بيته فلا حرج عليه، وله أجرها إن شاء الله. قال النبي ﷺ: "من قام رمضان إيماناً واحتساباً غفر له ما تقدم من ذنبه".',
    category: 'الصلاة',
    icon: Icons.mosque,
  ),
  FatawaItem(
    question: 'ما هي كيفية التيمم وحكمه؟',
    answer: 'التيمم بديل عن الوضوء عند عدم وجود الماء أو عند المرض الذي يمنع استعمال الماء. والتيمم ضربة واحدة على التراب الطاهر يمسح بها الوجه، ثم ضربة أخرى يمسح بها الكفين. قال تعالى: "فتيمموا صعيداً طيباً فامسحوا بوجوهكم وأيديكم منه". ويبطل التيمم بوجود الماء (للمسافر) أو بزوال العذر.',
    category: 'الطهارة',
    icon: Icons.water_drop,
  ),
  FatawaItem(
    question: 'ما حكم الاحتفال بالمولد النبوي؟',
    answer: 'الاحتفال بالمولد النبوي ليس من السنة ولم يفعله النبي ﷺ ولا الصحابة ولا التابعون، وإنما هو بدعة محدثة. والأولى بالمسلم أن يكثر من الصلاة على النبي ﷺ واتباع سنته في كل وقت، وأن يحيي السنة ويعمر قلبه بحب النبي ﷺ باتباعه والاقتداء به في جميع الأوقات.',
    category: 'البدع',
    icon: Icons.info_outline,
  ),
  FatawaItem(
    question: 'ما حكم أخذ العمولة على السمسرة والوساطة؟',
    answer: 'تجوز السمسرة والوساطة بأجر معلوم متفق عليه بين الأطراف، وذلك لأنها من باب الإجارة على عمل مباح. فالسمسار يستحق أجرته مقابل جهده ووقته في التوسط بين البائع والمشتري. ويشترط أن يكون العمل مباحاً (لا وساطة في حرام)، وأن تكون العمولة معلومة متفقاً عليها مسبقاً.',
    category: 'المعاملات',
    icon: Icons.handshake,
  ),
  FatawaItem(
    question: 'ما حكم لبس البنطال للنساء؟',
    answer: 'يجوز للمرأة لبس البنطال بشروط: ألا يكون ضيقاً يصف تفاصيل الجسم، وألا يكون شفافاً أو مثيراً للفتنة، وأن يكون فوقه ثوب ساتر كالجلباب أو العباءة، وألا تشبه بالرجال في لبسهم. والأفضل للمرأة المسلمة لبس الفساتين الواسعة والجلباب الشرعي ستراً وتحصناً.',
    category: 'اللباس',
    icon: Icons.checkroom,
  ),
  FatawaItem(
    question: 'ما حكم من عليه ديون ولم يستطع الحج؟',
    answer: 'الحج واجب على المستطيع، ومن كان عليه دين فإن الحج لا يجب عليه إلا بعد سداد الدين، لأن الدين مقدم على الحج. أما إذا كان صاحب الدين قد أذن له بالحج أو أمهله فلا حرج. والأفضل أن يبدأ بسداد الدين ثم يحج، لقوله ﷺ: "نفس المؤمن معلقة بدينه حتى يقضى عنه".',
    category: 'الحج',
    icon: Icons.flight,
  ),
  FatawaItem(
    question: 'ما حكم الصور الفوتوغرافية والتصوير؟',
    answer: 'جمهور العلماء المعاصرين على جواز التصوير الفوتوغرافي (بالكاميرا) للأشخاص والأشياء، وذلك لأنه حبس للظل وليس خلقاً وتصويراً باليد. أما التصوير اليدوي (الرسم والنحت) للذوات ذات الأرواح ففيه تفصيل بين العلماء. ويشترط لجواز التصوير الفوتوغرافي مراعاة الضوابط الشرعية كالحجاب وغض البصر.',
    category: 'العادات',
    icon: Icons.camera_alt,
  ),
];

class FatawaScreen extends StatefulWidget {
  const FatawaScreen({super.key});

  @override
  State<FatawaScreen> createState() => _FatawaScreenState();
}

class _FatawaScreenState extends State<FatawaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<int> _expandedItems = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FatawaItem> get _filteredFatawa {
    if (_searchQuery.isEmpty) return fatawaData;
    final q = _searchQuery.trim().toLowerCase();
    return fatawaData.where((f) {
      return f.question.toLowerCase().contains(q) ||
          f.answer.toLowerCase().contains(q) ||
          f.category.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredFatawa;
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: Text(
          'الفتاوى',
          style: TextStyle(color: context.appColors.textPrimary),
        ),
        backgroundColor: context.appColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.appColors.textPrimary),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            if (filtered.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, size: 64,
                          color: context.appColors.textSecondary.withValues(alpha: 0.4)),
                      const SizedBox(height: 16),
                      Text('لا توجد نتائج مطابقة',
                          style: TextStyle(color: context.appColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('جرّب كلمة أخرى',
                          style: TextStyle(color: context.appColors.textSecondary, fontSize: 14)),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _buildFatwaCard(filtered[index], index);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ]),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: 'ابحث في الفتاوى...',
            hintStyle: TextStyle(color: context.appColors.textSecondary, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: context.appColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFatwaCard(FatawaItem fatwa, int index) {
    final isExpanded = _expandedItems.contains(index);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedItems.remove(index);
                } else {
                  _expandedItems.add(index);
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
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(fatwa.icon, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            fatwa.category,
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fatwa.question,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: context.appColors.textPrimary,
                            height: 1.4,
                          ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 3,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      fatwa.answer,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.appColors.textSecondary,
                        height: 1.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: '${fatwa.question}\n\n${fatwa.answer}'));
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('تم نسخ الفتوى'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.primary,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text('نسخ', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
