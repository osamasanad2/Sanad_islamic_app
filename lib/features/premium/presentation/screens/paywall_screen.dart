import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/premium_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/premium_badge.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _isAnnual = true;
  bool _isLoading = false;

  final List<_FeatureItem> _features = const [
    _FeatureItem(
      icon: Icons.block,
      title: 'بدون إعلانات',
      subtitle: 'تصفح التطبيق بدون أي إعلانات مزعجة',
    ),
    _FeatureItem(
      icon: Icons.record_voice_over,
      title: 'قراء متعددون',
      subtitle: 'استمع للقرآن بأصوات أشهر القراء',
    ),
    _FeatureItem(
      icon: Icons.menu_book,
      title: 'أدوات قرآن متقدمة',
      subtitle: 'تفسير، تجويد، وإعراب الآيات',
    ),
    _FeatureItem(
      icon: Icons.palette,
      title: 'ثيمات مميزة',
      subtitle: 'ألوان وتصاميم حصرية للتطبيق',
    ),
    _FeatureItem(
      icon: Icons.offline_bolt,
      title: 'الاستماع بدون نت',
      subtitle: 'حمل القرآن واستمتع به في أي وقت',
    ),
    _FeatureItem(
      icon: Icons.psychology,
      title: 'الذكاء الاصطناعي',
      subtitle: 'أسئلة وأجوبة دينية ذكية',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(premiumServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildPricingToggle(),
            const SizedBox(height: 24),
            _buildFeatureList(),
            const SizedBox(height: 32),
            _buildSubscribeButton(service),
            const SizedBox(height: 16),
            _buildRestoreButton(service),
            const SizedBox(height: 12),
            _buildContinueFreeButton(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Icon(
              Icons.mosque,
              size: 220,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -20,
            child: Icon(
              Icons.star,
              size: 160,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            right: 60,
            bottom: 80,
            child: Icon(
              Icons.mosque,
              size: 80,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                const PremiumBadge(size: 56),
                const SizedBox(height: 16),
                const Text(
                  'سند برو',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أطلق العنان للتجربة الكاملة',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.gold, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'اشتراك مميز - تجربة بدون حدود',
                        style: TextStyle(color: AppColors.goldLight, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isAnnual = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _isAnnual ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'سنوي',
                        style: TextStyle(
                          color: _isAnnual ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ريال ٩٩٫٩٩ / سنة',
                        style: TextStyle(
                          color: _isAnnual
                              ? Colors.white.withValues(alpha: 0.85)
                              : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      if (_isAnnual)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'وفر ٥٠٪',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isAnnual = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: !_isAnnual ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'شهري',
                        style: TextStyle(
                          color: !_isAnnual ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ريال ١٤٫٩٩ / شهر',
                        style: TextStyle(
                          color: !_isAnnual
                              ? Colors.white.withValues(alpha: 0.85)
                              : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            'جميع المميزات المتاحة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ..._features.map((feature) => _buildFeatureItem(feature)),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(_FeatureItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.primaryLight, size: 22),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton(PremiumService service) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : () => _handleSubscribe(service),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            shadowColor: AppColors.primary.withValues(alpha: 0.3),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  _isAnnual ? 'اشترك سنوياً - ريال ٩٩٫٩٩' : 'اشترك شهرياً - ريال ١٤٫٩٩',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRestoreButton(PremiumService service) {
    return TextButton(
      onPressed: _isLoading
          ? null
          : () async {
              setState(() => _isLoading = true);
              await service.restorePurchases();
              setState(() => _isLoading = false);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تمت استعادة المشتريات بنجاح'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
      child: Text(
        'استعادة المشتريات',
        style: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.8),
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildContinueFreeButton(BuildContext context) {
    return TextButton(
      onPressed: () => context.pop(),
      child: Text(
        'استمرار مجاناً',
        style: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.6),
          fontSize: 15,
        ),
      ),
    );
  }

  Future<void> _handleSubscribe(PremiumService service) async {
    setState(() => _isLoading = true);
    final productId = _isAnnual
        ? PremiumProductIds.annualAndroid
        : PremiumProductIds.monthlyAndroid;
    await service.purchaseSubscription(productId);
    setState(() => _isLoading = false);
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
