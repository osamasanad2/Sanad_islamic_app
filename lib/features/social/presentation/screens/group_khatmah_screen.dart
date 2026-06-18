import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/social_provider.dart';

class GroupKhatmahScreen extends ConsumerStatefulWidget {
  const GroupKhatmahScreen({super.key});

  @override
  ConsumerState<GroupKhatmahScreen> createState() => _GroupKhatmahScreenState();
}

class _GroupKhatmahScreenState extends ConsumerState<GroupKhatmahScreen> {
  bool _showCreateForm = false;
  bool _showJoinForm = false;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _inviteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(socialProvider).khatmahGroups;

    return Column(
      children: [
        _buildActions(),
        const SizedBox(height: 12),
        if (_showCreateForm) _buildCreateForm(),
        if (_showJoinForm) _buildJoinForm(),
        Expanded(
          child: groups.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return _buildGroupCard(groups[index]).animate().fadeIn(
                      delay: (index * 100).ms,
                      duration: 400.ms,
                    ).slideX(begin: 0.1);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.add_circle_outline,
              label: 'إنشاء ختمة',
              isActive: _showCreateForm,
              onTap: () => setState(() {
                _showCreateForm = !_showCreateForm;
                _showJoinForm = false;
              }),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.group_add_outlined,
              label: 'انضمام',
              isActive: _showJoinForm,
              onTap: () => setState(() {
                _showJoinForm = !_showJoinForm;
                _showCreateForm = false;
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.15),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isActive ? Colors.white : AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              labelText: 'اسم المجموعة',
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            textAlign: TextAlign.right,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'الوصف (اختياري)',
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isEmpty) return;
              ref.read(socialProvider.notifier).createGroup(name, _descController.text.trim());
              _nameController.clear();
              _descController.clear();
              setState(() => _showCreateForm = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('إنشاء', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2);
  }

  Widget _buildJoinForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _inviteController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'أدخل رمز الدعوة',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.vpn_key_outlined, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final code = _inviteController.text.trim();
              if (code.isEmpty) return;
              ref.read(socialProvider.notifier).joinGroup(code);
              _inviteController.clear();
              setState(() => _showJoinForm = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('انضمام', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.group_add, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد ختمات بعد',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أنشئ ختمة جديدة أو انضم إلى إحداها',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(KhatmahGroup group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.menu_book, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (group.description.isNotEmpty)
                      Text(
                        group.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.group, size: 12, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text(
                      '${group.members.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                '${group.juzCompleted}/${group.totalJuz} أجزاء',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${group.progress >= 1.0 ? 100 : (group.progress * 100).round()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: group.progress >= 1.0 ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: group.progress,
              minHeight: 6,
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(
                group.progress >= 1.0 ? AppColors.primary : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: group.members.map((m) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _buildMemberAvatar(m),
                );
              }).toList(),
            ),
          ),
          if (group.members.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...group.members.map((m) => _buildMemberRow(m, group.id)),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.share, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'رمز الدعوة: ${group.inviteCode}',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberAvatar(KhatmahMember member) {
    final pct = member.progress;
    return Tooltip(
      message: '${member.name}: ${(pct * 100).round()}%',
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: pct >= 1.0 ? AppColors.primary : AppColors.gold.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: pct >= 1.0
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.gold.withValues(alpha: 0.08),
          child: Text(
            member.name.substring(0, 1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: pct >= 1.0 ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberRow(KhatmahMember member, String groupId) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            child: Text(
              member.name.substring(0, 1),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              member.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '${member.juzCompleted}/${member.totalJuz}',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: member.progress,
                minHeight: 4,
                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(
                  member.progress >= 1.0 ? AppColors.primary : AppColors.gold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (!member.progress.isNaN && member.progress < 1.0)
            GestureDetector(
              onTap: () => ref.read(socialProvider.notifier).advanceMemberJuz(groupId, member.id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, size: 14, color: AppColors.primary),
              ),
            )
          else
            const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
        ],
      ),
    );
  }
}
