import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/zakat_models.dart';
import '../../data/zakat_provider.dart';
import '../../data/gold_price_service.dart';

class ZakatScreen extends ConsumerWidget {
  const ZakatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(zakatProvider);

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: context.appColors.background,
              title: Text(
                'حاسبة الزكاة',
                style: TextStyle(
                  color: context.appColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh, color: context.appColors.textSecondary),
                  onPressed: () => ref.read(zakatProvider.notifier).refreshPrice(),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoBanner(context).animate().fadeIn(delay: 50.ms),
                    const SizedBox(height: 16),
                    _buildNisaabCard(context, state)
                        .animate()
                        .fadeIn(delay: 100.ms),
                    const SizedBox(height: 20),
                    _buildCurrencySelector(context, ref, state)
                        .animate()
                        .fadeIn(delay: 150.ms),
                    const SizedBox(height: 20),
                    _buildFields(context, ref, state)
                        .animate()
                        .fadeIn(delay: 200.ms),
                    const SizedBox(height: 24),
                    _buildCalculateButton(context, ref, state)
                        .animate()
                        .fadeIn(delay: 300.ms),
                    if (state.result != null) ...[
                      const SizedBox(height: 20),
                      _buildResultCard(context, ref, state)
                          .animate()
                          .fadeIn(delay: 350.ms)
                          .slideY(begin: 0.1),
                      if (state.showBreakdown) ...[
                        const SizedBox(height: 16),
                        _buildBreakdown(context, state)
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.1),
                      ],
                      const SizedBox(height: 16),
                      _buildResetButton(context, ref),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => _showInfoSheet(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.9),
              AppColors.primaryLight.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_outline, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('أحكام الزكاة',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    'تجب الزكاة إذا بلغ المال النصاب وحال عليه الحول، ومقدارها 2.5%',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        height: 1.4),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: Colors.white.withValues(alpha: 0.5), size: 16),
          ],
        ),
      ),
    );
  }

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('أحكام الزكاة في الإسلام',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _infoItem(Icons.monetization_on, 'ما هو النصاب؟',
                  'النصاب هو الحد الأدنى من المال الذي إذا بلغه المسلم وجبت عليه الزكاة. ونصاب الزكاة الشرعي هو 85 جراماً من الذهب.'),
              _infoItem(
                  Icons.calendar_month,
                  'معنى حولان الحول',
                  'الحول هو مرور سنة قمرية كاملة (12 شهراً) على امتلاك النصاب. لا تجب الزكاة إلا بعد مضي الحول.'),
              _infoItem(Icons.account_balance, 'الأموال التي تجب فيها الزكاة',
                  'النقود والمدخرات\nالذهب والفضة\nعروض التجارة\nالأسهم والاستثمارات\nالأموال المستحقة'),
              _infoItem(
                  Icons.warning_amber,
                  'تنبيه مهم',
                  'هذه الحاسبة أداة مساعدة فقط، ويجب مراجعة أهل العلم والفتوى لتحديد الزكاة بدقة في الحالات المعقدة.',
                  isWarning: true),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _infoItem(IconData icon, String title, String desc,
      {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isWarning
                  ? Colors.orange.withValues(alpha: 0.1)
                  : AppColors.primaryLight.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                size: 18,
                color: isWarning ? Colors.orange : AppColors.primaryLight),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc,
                    style: TextStyle(
                        fontSize: 13,
                        color: isWarning
                            ? Colors.orange.shade700
                            : Colors.grey.shade600,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNisaabCard(BuildContext context, ZakatState state) {
    final goldPrice = state.goldPrice;

    if (goldPrice == null && state.isLoadingPrice) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text('جاري تحميل سعر الذهب...',
                style: TextStyle(
                    color: context.appColors.textSecondary, fontSize: 13)),
          ],
        ),
      );
    }

    if (goldPrice == null && state.priceError != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(state.priceError!,
                  style: const TextStyle(color: Colors.orange, fontSize: 13)),
            ),
          ],
        ),
      );
    }

    if (goldPrice == null) return const SizedBox.shrink();

    final nisaab =
        85 * GoldPriceService.convertToCurrency(goldPrice.pricePerGram, state.currency);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.monetization_on, color: AppColors.gold, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('النصاب الحالي (85 جرام ذهب)',
                    style: TextStyle(
                        fontSize: 12,
                        color: context.appColors.textSecondary)),
                const SizedBox(height: 4),
                Text('${_formatNumber(nisaab)} ${state.currency.symbol}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.appColors.textPrimary)),
              ],
            ),
          ),
          if (goldPrice.isFallback)
            Tooltip(
              message: 'قيمة تقريبية - غير متصل بالإنترنت',
              child: Icon(Icons.cloud_off,
                  size: 18,
                  color:
                      context.appColors.textSecondary.withValues(alpha: 0.5)),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector(
      BuildContext context, WidgetRef ref, ZakatState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.currency_exchange,
              size: 20, color: context.appColors.textSecondary),
          const SizedBox(width: 10),
          Text('العملة:',
              style: TextStyle(
                  color: context.appColors.textSecondary, fontSize: 14)),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Currency>(
                value: state.currency,
                isExpanded: true,
                dropdownColor: context.appColors.surface,
                style: TextStyle(
                  color: context.appColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                items: Currency.values
                    .map((c) => DropdownMenuItem(
                        value: c, child: Text('${c.code} - ${c.symbol}')))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    ref.read(zakatProvider.notifier).setCurrency(v);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFields(BuildContext context, WidgetRef ref, ZakatState state) {
    return Column(
      children: [
        _field(context, ref, 'cashSavings', 'النقد والمدخرات',
            Icons.account_balance_wallet, 'مثال: 50000', state.cashSavings),
        _field(context, ref, 'goldGrams', 'الذهب (بالجرام)', Icons.circle,
            'عدد جرامات الذهب', state.goldGrams),
        _field(context, ref, 'silverGrams', 'الفضة (بالجرام)',
            Icons.circle_outlined, 'عدد جرامات الفضة', state.silverGrams),
        _field(context, ref, 'investments', 'الأسهم والاستثمارات',
            Icons.trending_up, 'مثال: 25000', state.investments),
        _field(context, ref, 'businessAssets', 'الأموال التجارية', Icons.store,
            'قيمة البضاعة', state.businessAssets),
        _field(context, ref, 'receivables', 'الديون المرجو سدادها',
            Icons.currency_exchange, 'مثال: 10000', state.receivables),
        _field(context, ref, 'debts', 'الديون المستحقة عليك',
            Icons.remove_circle_outline, 'مثال: 5000', state.debts,
            isNegative: true),
      ],
    );
  }

  Widget _field(BuildContext context, WidgetRef ref, String key, String label,
      IconData icon, String hint, String value,
      {bool isNegative = false}) {
    final color =
        isNegative ? Colors.red.shade400 : AppColors.primaryLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isNegative
                ? Colors.red.withValues(alpha: 0.1)
                : AppColors.primaryLight.withValues(alpha: 0.08),
          ),
        ),
        child: TextField(
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: value,
              selection: TextSelection.collapsed(offset: value.length),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 15,
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            hintStyle: TextStyle(
                color: context.appColors.textSecondary.withValues(alpha: 0.5)),
            labelStyle: TextStyle(
              color: isNegative
                  ? Colors.red.shade400
                  : context.appColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: Colors.transparent,
          ),
          onChanged: (v) =>
              ref.read(zakatProvider.notifier).updateField(key, v),
        ),
      ),
    );
  }

  Widget _buildCalculateButton(
      BuildContext context, WidgetRef ref, ZakatState state) {
    final enabled = state.goldPrice != null && !state.isLoadingPrice;

    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: enabled
            ? () => ref.read(zakatProvider.notifier).calculate()
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: context.appColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calculate, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            const Text('احسب الزكاة',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(
      BuildContext context, WidgetRef ref, ZakatState state) {
    final r = state.result!;
    final meetsNisaab = r.meetsNisaab;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: meetsNisaab
              ? [
                  AppColors.primary.withValues(alpha: 0.9),
                  AppColors.primaryLight.withValues(alpha: 0.7),
                ]
              : [Colors.grey.shade400, Colors.grey.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('إجمالي الأموال الزكوية',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: meetsNisaab
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  meetsNisaab ? 'بلغ النصاب' : 'لم يبلغ النصاب',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('${_formatNumber(r.totalWealth)} ${state.currency.symbol}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('النصاب',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(
                        '${_formatNumber(r.nisaab)} ${state.currency.symbol}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.15),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(meetsNisaab ? 'الزكاة الواجبة' : 'لا زكاة',
                        style: TextStyle(
                            color: meetsNisaab ? Colors.white : Colors.white54,
                            fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(
                      meetsNisaab
                          ? '${_formatNumber(r.zakatAmount)} ${state.currency.symbol}'
                          : '—',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  ref.read(zakatProvider.notifier).toggleBreakdown(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              icon: Icon(
                  state.showBreakdown
                      ? Icons.expand_less
                      : Icons.info_outline,
                  color: Colors.white,
                  size: 18),
              label: Text(
                state.showBreakdown ? 'إخفاء التفاصيل' : 'كيف تم الحساب؟',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdown(BuildContext context, ZakatState state) {
    final r = state.result!;
    final s = state.currency.symbol;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calculate,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Text('تفصيل الحساب',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: context.appColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          _row('النقد والمدخرات', '${_formatNumber(r.cashSavingsValue)} $s',
              context),
          _row('الذهب', '${_formatNumber(r.goldValue)} $s', context),
          _row('الفضة', '${_formatNumber(r.silverValue)} $s', context),
          _row('الأسهم والاستثمارات', '${_formatNumber(r.investmentsValue)} $s',
              context),
          _row('الأموال التجارية',
              '${_formatNumber(r.businessAssetsValue)} $s', context),
          _row('الديون المرجو سدادها',
              '${_formatNumber(r.receivablesValue)} $s', context),
          Divider(color: context.appColors.textSecondary.withValues(alpha: 0.2)),
          _row('المجموع',
              '${_formatNumber(r.cashSavingsValue + r.goldValue + r.silverValue + r.investmentsValue + r.businessAssetsValue + r.receivablesValue)} $s',
              context,
              bold: true),
          _row(
              'الديون المستحقة',
              '-${_formatNumber(r.debtsValue)} $s',
              context,
              color: Colors.red),
          Divider(color: AppColors.primary.withValues(alpha: 0.15),
              thickness: 1.5),
          _row('صافي المال الزكوي',
              '${_formatNumber(r.totalWealth)} $s', context,
              bold: true, color: AppColors.primary),
          Divider(color: context.appColors.textSecondary.withValues(alpha: 0.2)),
          _row('النصاب (85 جرام ذهب)',
              '${_formatNumber(r.nisaab)} $s', context),
          _row(
              'الحالة',
              r.meetsNisaab ? 'بلغ النصاب ✅' : 'لم يبلغ النصاب ❌',
              context,
              bold: true,
              color: r.meetsNisaab ? AppColors.primary : Colors.orange),
          if (r.meetsNisaab) ...[
            Divider(color: AppColors.gold.withValues(alpha: 0.2),
                thickness: 1.5),
            _row('الزكاة الواجبة (2.5%)',
                '${_formatNumber(r.zakatAmount)} $s', context,
                bold: true, color: AppColors.gold, large: true),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value, BuildContext context,
      {bool bold = false, Color? color, bool large = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: large ? 15 : 13,
                    fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                    color: color ?? context.appColors.textPrimary)),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: large ? 16 : 13,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                  color: color ?? context.appColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () => ref.read(zakatProvider.notifier).resetAll(),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
            color: context.appColors.textSecondary.withValues(alpha: 0.2)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      icon: Icon(Icons.refresh,
          size: 18, color: context.appColors.textSecondary),
      label: Text('إعادة تعيين',
          style: TextStyle(color: context.appColors.textSecondary)),
    );
  }

  String _formatNumber(double value) {
    if (value == 0) return '0';
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
      count++;
    }
    return '${buffer.toString().split('').reversed.join()}.$decPart';
  }
}
