import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/database_service.dart';
import '../../data/models/user_model.dart';

final _bgImages = [
  'assets/images/login_bg_1.jpg',
  'assets/images/login_bg_2.jpg',
  'assets/images/login_bg_3.jpg',
  'assets/images/login_bg_4.jpg',
];

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  int _currentBgIndex = 0;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      _showSnackbar('يرجى ملء جميع الحقول');
      return;
    }

    if (password.length < 6) {
      _showSnackbar('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final existing = await DatabaseService().getUserByEmail(email);
      if (existing != null) {
        if (!mounted) return;
        _showSnackbar('البريد الإلكتروني مسجل بالفعل');
        setState(() => _isLoading = false);
        return;
      }

      final user = UserModel(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      await DatabaseService().insertUser(user);

      if (!mounted) return;
      _showSnackbar('تم إنشاء الحساب بنجاح');
      context.pop();
    } catch (e) {
      if (!mounted) return;
      _showSnackbar('حدث خطأ، يرجى المحاولة مرة أخرى');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            items: _bgImages
                .map(
                  (img) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(img),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: 6.seconds,
              autoPlayAnimationDuration: 1.seconds,
              enlargeCenterPage: false,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index, reason) {
                setState(() => _currentBgIndex = index);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.3),
                  AppColors.primaryDark.withValues(alpha: 0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildDotsIndicator(),
                    const SizedBox(height: 30),
                    _buildSignupForm(),
                    const SizedBox(height: 24),
                    _buildSignupButton(),
                    const SizedBox(height: 16),
                    _buildLoginPrompt(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.goldLight.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person_add_alt_1,
                size: 34,
                color: AppColors.goldLight,
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0, 0), curve: Curves.elasticOut),
        const SizedBox(height: 16),
        Text(
          'إنشاء حساب جديد',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.3),
      ],
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _bgImages.length,
        (i) => Container(
          width: _currentBgIndex == i ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentBgIndex == i
                ? AppColors.gold
                : Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildSignupForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'الاسم الكامل',
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            prefixIcon: Icon(
              Icons.person_outline,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.goldLight.withValues(alpha: 0.6),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),
        const SizedBox(height: 14),
        TextField(
          controller: _emailController,
          textDirection: TextDirection.rtl,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'البريد الإلكتروني',
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.goldLight.withValues(alpha: 0.6),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.1),
        const SizedBox(height: 14),
        TextField(
          controller: _phoneController,
          textDirection: TextDirection.rtl,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'رقم الهاتف',
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.goldLight.withValues(alpha: 0.6),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 1000.ms).slideX(begin: 0.1),
        const SizedBox(height: 14),
        TextField(
          controller: _passwordController,
          textDirection: TextDirection.rtl,
          obscureText: _obscurePassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'كلمة المرور',
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.goldLight.withValues(alpha: 0.6),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 1200.ms).slideX(begin: 0.1),
      ],
    );
  }

  Widget _buildSignupButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.gold, AppColors.goldLight],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isLoading ? null : _signup,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primaryDark,
                    ),
                  )
                : const Text(
                    'إنشاء حساب',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.2);
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'لديك حساب بالفعل؟ ',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'تسجيل الدخول',
              style: TextStyle(
                color: AppColors.goldLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1600.ms);
  }
}
