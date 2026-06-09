import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/database_service.dart';

final _bgImages = [
  'assets/images/login_bg_1.jpg',
  'assets/images/login_bg_2.jpg',
  'assets/images/login_bg_3.jpg',
  'assets/images/login_bg_4.jpg',
];

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  int _currentBgIndex = 0;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar('يرجى ملء جميع الحقول');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await DatabaseService().login(email, password);
      if (!mounted) return;

      if (user != null) {
        context.go('/');
      } else {
        _showSnackbar('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      }
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
                    const SizedBox(height: 80),
                    _buildHeader(),
                    const SizedBox(height: 60),
                    _buildDotsIndicator(),
                    const SizedBox(height: 50),
                    _buildLoginForm(),
                    const SizedBox(height: 24),
                    _buildLoginButton(),
                    const SizedBox(height: 16),
                    _buildForgotPassword(),
                    const SizedBox(height: 40),
                    _buildSignupPrompt(),
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
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.goldLight.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Icon(Icons.mosque, size: 40, color: AppColors.goldLight),
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0, 0), curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text(
          'سند',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 4,
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.3),
        const SizedBox(height: 8),
        Text(
          'تطبيقك الإسلامي الشامل',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w300,
          ),
        ).animate().fadeIn(delay: 400.ms),
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
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          textDirection: TextDirection.rtl,
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
        const SizedBox(height: 16),
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
        ).animate().fadeIn(delay: 1000.ms).slideX(begin: 0.1),
      ],
    );
  }

  Widget _buildLoginButton() {
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
          onTap: _isLoading ? null : _login,
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
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.2);
  }

  Widget _buildForgotPassword() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text(
          'نسيت كلمة المرور؟',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1400.ms);
  }

  Widget _buildSignupPrompt() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ليس لديك حساب؟ ',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          ),
          TextButton(
            onPressed: () => context.push('/signup'),
            child: const Text(
              'إنشاء حساب',
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
