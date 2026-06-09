import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

// Provider to hold the profile image path
class ProfileImageNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setImage(String? path) {
    state = path;
  }
}

final profileImageProvider = NotifierProvider<ProfileImageNotifier, String?>(
  ProfileImageNotifier.new,
);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImagePath = ref.watch(profileImageProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderAndCover(context, ref, profileImagePath),
            const SizedBox(height: 24.0),
            _buildSectionTitle('إحصائياتي').animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16.0),
            _buildStatisticsGrid(context),
            const SizedBox(height: 32.0),
            _buildSectionTitle(
              'الأوسمة والشارات',
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 16.0),
            _buildBadgesSection(),
            const SizedBox(height: 32.0),
            _buildSectionTitle('الإعدادات').animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSettingsSection(
                context,
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
            ),
            const SizedBox(
              height: 100.0,
            ), // Padding below everything to prevent cut-off
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildHeaderAndCover(
    BuildContext context,
    WidgetRef ref,
    String? imagePath,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Cover Photo
        Container(
          height: 220,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primaryLight],
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
              // Mosque watermark
              Positioned(
                right: -40,
                bottom: -20,
                child: Icon(
                  Icons.mosque,
                  size: 200,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              const Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'الملف الشخصي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // User Info Card overlapping the cover
        Container(
          margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20.0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'أحمد المسلم',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'اللهم اجعل القرآن ربيع قلوبنا 🌿',
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24.0),
              // Level Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'مستوى: طالب علم',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '80%',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: LinearProgressIndicator(
                  value: 0.8,
                  minHeight: 8.0,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryLight,
                  ),
                ),
              ).animate().slideX(duration: 1.seconds, begin: -1).fadeIn(),
              const SizedBox(height: 8.0),
              const Text(
                'باقي 20 نقطة للوصول لمستوى "حافظ"',
                style: TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
        // Avatar positioned exactly overlapping the top edge of the User Info Card
        Positioned(
          top: 100,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.amber,
                    width: 4.0,
                  ), // Golden border for level
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.surface,
                  backgroundImage: imagePath != null
                      ? NetworkImage(imagePath)
                      : null,
                  child: imagePath == null
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.primaryLight,
                        )
                      : null,
                ),
              ),
              GestureDetector(
                onTap: () => _showImagePickerBottomSheet(context, ref),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ).animate().scale(duration: 500.ms, delay: 200.ms),
        ),
      ],
    );
  }

  void _showImagePickerBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'تغيير الصورة الشخصية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.primary,
                ),
                title: const Text(
                  'اختيار من المعرض',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () {
                  ref
                      .read(profileImageProvider.notifier)
                      .setImage('https://picsum.photos/200');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text(
                  'التقاط صورة',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () {
                  ref
                      .read(profileImageProvider.notifier)
                      .setImage('https://picsum.photos/201');
                  Navigator.pop(context);
                },
              ),
              if (ref.read(profileImageProvider) != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: AppColors.error),
                  title: const Text(
                    'حذف الصورة',
                    style: TextStyle(color: AppColors.error),
                  ),
                  onTap: () {
                    ref.read(profileImageProvider.notifier).setImage(null);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatisticsGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.1,
        children: [
          _buildStatCard(
            context,
            title: 'أيام التلاوة',
            value: '12',
            icon: Icons.local_fire_department,
            color: Colors.orange,
            delay: 300,
          ),
          _buildStatCard(
            context,
            title: 'الأذكار',
            value: '850',
            icon: Icons.sign_language, // Hands raised like dua
            color: Colors.teal,
            delay: 400,
          ),
          _buildStatCard(
            context,
            title: 'الختمات',
            value: '2',
            icon: Icons.menu_book,
            color: Colors.purple,
            delay: 500,
          ),
          _buildStatCard(
            context,
            title: 'الاستماع (ساعة)',
            value: '45',
            icon: Icons.headphones,
            color: Colors.blue,
            delay: 600,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Mock action for tapping a stat card
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('عرض تفاصيل وإحصائيات $title...'),
              backgroundColor: color,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: color.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 10.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.1);
  }

  Widget _buildBadgesSection() {
    return SizedBox(
      height: 110.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildBadgeItem(
            title: 'الذاكرين',
            icon: Icons.star,
            color: Colors.amber,
            isLocked: false,
            delay: 500,
          ),
          _buildBadgeItem(
            title: 'قيام الليل',
            icon: Icons.nights_stay,
            color: Colors.indigo,
            isLocked: false,
            delay: 600,
          ),
          _buildBadgeItem(
            title: 'ختمة النور',
            icon: Icons.menu_book,
            color: Colors.green,
            isLocked: true,
            delay: 700,
          ),
          _buildBadgeItem(
            title: 'المواظب',
            icon: Icons.local_fire_department,
            color: Colors.orange,
            isLocked: true,
            delay: 800,
          ),
          _buildBadgeItem(
            title: 'المبكر',
            icon: Icons.wb_sunny,
            color: Colors.redAccent,
            isLocked: true,
            delay: 900,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem({
    required String title,
    required IconData icon,
    required Color color,
    required bool isLocked,
    required int delay,
  }) {
    final displayColor = isLocked ? Colors.grey.shade400 : color;

    return Container(
      width: 80.0,
      margin: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked
                  ? Colors.grey.shade100
                  : displayColor.withValues(alpha: 0.1),
              border: Border.all(
                color: isLocked
                    ? Colors.grey.shade300
                    : displayColor.withValues(alpha: 0.5),
                width: 2.0,
              ),
              boxShadow: isLocked
                  ? null
                  : [
                      BoxShadow(
                        color: displayColor.withValues(alpha: 0.3),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
            ),
            child: Icon(
              isLocked ? Icons.lock_outline : icon,
              color: displayColor,
              size: 28.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: isLocked ? Colors.grey.shade500 : AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().scale(delay: delay.ms).fadeIn();
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSettingsGroup(
          title: 'التفضيلات',
          children: [
            _buildSettingsTile(
              title: 'المظهر',
              subtitle: 'الوضع النهاري',
              icon: Icons.dark_mode_outlined,
              onTap: () => _showThemeDialog(context),
            ),
            const Divider(height: 1, indent: 56),
            _buildSettingsTile(
              title: 'الإشعارات',
              subtitle: 'مفعلة',
              icon: Icons.notifications_active_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم الانتقال لإعدادات الإشعارات'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            const Divider(height: 1, indent: 56),
            _buildSettingsTile(
              title: 'اللغة',
              subtitle: 'العربية',
              icon: Icons.language,
              onTap: () => _showLanguageDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        _buildSettingsGroup(
          title: 'حول التطبيق',
          children: [
            _buildSettingsTile(
              title: 'عن تطبيق سند',
              icon: Icons.info_outline,
              onTap: () => _showAboutAppDialog(context),
            ),
            const Divider(height: 1, indent: 56),
            _buildSettingsTile(
              title: 'مشاركة التطبيق',
              icon: Icons.share_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('جاري فتح قائمة المشاركة...'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            const Divider(height: 1, indent: 56),
            _buildSettingsTile(
              title: 'قيّمنا',
              icon: Icons.star_border_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم الانتقال إلى صفحة التقييم في المتجر'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        _buildSettingsGroup(
          title: 'الحساب',
          children: [
            _buildSettingsTile(
              title: 'تسجيل الخروج',
              icon: Icons.logout,
              color: AppColors.error,
              onTap: () => _showLogoutDialog(context),
            ),
            const Divider(height: 1, indent: 56),
            _buildSettingsTile(
              title: 'حذف الحساب',
              icon: Icons.delete_forever,
              color: Colors.red.shade700,
              onTap: () => _showDeleteAccountDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required String title,
    String? subtitle,
    required IconData icon,
    Color color = AppColors.textPrimary,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 4.0,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'اختيار المظهر',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.wb_sunny_outlined,
                color: Colors.orange,
              ),
              title: const Text('الوضع النهاري'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(
                Icons.nights_stay_outlined,
                color: Colors.indigo,
              ),
              title: const Text('الوضع الليلي'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_suggest_outlined,
                color: Colors.grey,
              ),
              title: const Text('حسب النظام'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'اختيار اللغة',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              trailing: const Icon(Icons.check, color: AppColors.primary),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('English'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'تطبيق سند',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.mosque, size: 40, color: AppColors.primary),
      ),
      applicationLegalese: '© 2026 جميع الحقوق محفوظة',
      children: [
        const SizedBox(height: 16),
        const Text(
          'تطبيق إسلامي شامل يهدف إلى تقديم محتوى ديني موثوق وأدوات يومية للمسلم كالأذكار والقرآن ومواقيت الصلاة.',
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.5),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
              );
            },
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'حذف الحساب',
          style: TextStyle(color: AppColors.error),
        ),
        content: const Text(
          'تحذير: سيتم حذف جميع بياناتك وإحصائياتك بشكل نهائي ولا يمكن التراجع عن هذا الإجراء. هل أنت متأكد؟',
          style: TextStyle(height: 1.5),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال طلب حذف الحساب')),
              );
            },
            child: const Text(
              'تأكيد الحذف',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
