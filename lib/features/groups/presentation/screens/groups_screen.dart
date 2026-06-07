import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'المجموعات',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3.0,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
          tabs: const [
            Tab(text: 'مجموعاتي'),
            Tab(text: 'استكشف'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildMyGroupsTab(),
          _buildDiscoverTab(),
        ],
      ),
    );
  }

  Widget _buildMyGroupsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16.0),
          _buildGroupSelector().animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 16.0),
          _buildSharedQuote().animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          const SizedBox(height: 24.0),
          _buildSectionTitle('فقاعات الحالة والتواصي').animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 12.0),
          _buildStatusBubbles().animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 24.0),
          _buildSectionTitle('التعاون الروحي').animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 16.0),
          _buildSharedKhatma().animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
          const SizedBox(height: 16.0),
          _buildMillionTasbeeh().animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
          const SizedBox(height: 16.0),
          _buildSanadAlMuhtaj().animate().fadeIn(delay: 800.ms).slideY(begin: 0.1),
          const SizedBox(height: 100.0), // Padding below everything
        ],
      ),
    );
  }

  Widget _buildDiscoverTab() {
    return const Center(
      child: Text(
        'قريباً.. انضم لملايين المسلمين حول العالم!',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildGroupSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Row(
              children: [
                Icon(Icons.family_restroom, color: AppColors.primaryDark, size: 20),
                SizedBox(width: 8.0),
                Text(
                  'عائلة الشمري',
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4.0),
                Icon(Icons.keyboard_arrow_down, color: AppColors.primaryDark),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildSharedQuote() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: const Text('أ', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8.0),
              const Text(
                'أحمد شارك حكمة اليوم',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12.0),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          const Text(
            '« من لزم الاستغفار جعل الله له من كل هم فرجا »',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildInteractionButton('آمين', '🙏', true),
              const SizedBox(width: 12.0),
              _buildInteractionButton('3', '❤️', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(String label, String emoji, bool isFilled) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isFilled ? AppColors.primaryLight.withValues(alpha: 0.1) : Colors.transparent,
        border: Border.all(color: isFilled ? AppColors.primaryLight : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14.0)),
          const SizedBox(width: 4.0),
          Text(
            label,
            style: TextStyle(
              color: isFilled ? AppColors.primaryDark : AppColors.textSecondary,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildStatusBubbles() {
    final members = [
      {'name': 'أنت', 'done': true, 'avatar': '👦'},
      {'name': 'يوسف', 'done': true, 'avatar': '👨'},
      {'name': 'علي', 'done': false, 'avatar': '👱'},
      {'name': 'عمر', 'done': false, 'avatar': '👨‍🦱'},
      {'name': 'سالم', 'done': true, 'avatar': '🧔'},
    ];

    return SizedBox(
      height: 90.0,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: members.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16.0),
        itemBuilder: (context, index) {
          final member = members[index];
          final isDone = member['done'] as bool;
          final isMe = member['name'] == 'أنت';
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(
                        color: isDone ? Colors.green.shade400 : Colors.grey.shade300,
                        width: 3.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      member['avatar'] as String,
                      style: const TextStyle(fontSize: 28.0),
                    ),
                  ),
                  if (!isDone && !isMe)
                    GestureDetector(
                      onTap: () {
                        // Nudge Action
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade400,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.background, width: 2.0),
                        ),
                        child: const Icon(Icons.notifications_active, color: Colors.white, size: 12.0),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                member['name'] as String,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSharedKhatma() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3), width: 1.5), // Gold border
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.menu_book, color: Color(0xFFD4AF37)),
                  SizedBox(width: 8.0),
                  Text(
                    'الختمة المشتركة',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ],
              ),
              Text(
                '18/30 جزء',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade600),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // 30 parts grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: 30,
            itemBuilder: (context, index) {
              final isCompleted = index < 18;
              return Container(
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFFD4AF37) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              );
            },
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                foregroundColor: const Color(0xFFD4AF37),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              child: const Text('احجز الجزء 19', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMillionTasbeeh() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade300, Colors.teal.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.3),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'الصلاة على النبي ﷺ',
            style: TextStyle(color: Colors.white70, fontSize: 12.0),
          ),
          const SizedBox(height: 8.0),
          const Text(
            '654,420',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const Text(
            'الهدف: 1,000,000',
            style: TextStyle(color: Colors.white54, fontSize: 10.0),
          ),
          const SizedBox(height: 16.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: LinearProgressIndicator(
              value: 0.65,
              minHeight: 6.0,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
            ),
            child: const Text('ساهم الآن', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSanadAlMuhtaj() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.volunteer_activism, color: Colors.blue),
          ),
          const SizedBox(width: 16.0),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سند المحتاج',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 4.0),
                Text(
                  'أحد الإخوة يمر بضائقة، لا تنسوه من الدعاء.',
                  style: TextStyle(fontSize: 12.0, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
            child: const Text('دعوت لك', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
