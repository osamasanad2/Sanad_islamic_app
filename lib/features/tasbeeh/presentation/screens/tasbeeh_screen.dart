import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});
  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> with SingleTickerProviderStateMixin {
  int _count = 0;
  int _totalToday = 342;
  int _goal = 1000;
  int _selectedDhikrIndex = 0;
  bool _showRipple = false;
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _dhikrList = [
    {'text': 'سُبْحَانَ اللّه', 'target': 33, 'color': Colors.teal},
    {'text': 'الْحَمْدُ لِلّه', 'target': 33, 'color': Colors.orange},
    {'text': 'اللّهُ أَكْبَر', 'target': 34, 'color': Colors.blue},
    {'text': 'لا إلهَ إلاّ الله', 'target': 100, 'color': Colors.purple},
    {'text': 'أَسْتَغْفِرُ اللّه', 'target': 100, 'color': Colors.red.shade300},
    {'text': 'اللّهُمَّ صَلِّ عَلَى مُحَمَّد', 'target': 100, 'color': const Color(0xFFD4AF37)},
  ];

  // Mock weekly data
  final List<int> _weeklyData = [120, 340, 200, 500, 280, 410, 342];
  final List<String> _weekDays = ['سب', 'أح', 'إث', 'ثل', 'أر', 'خم', 'جم'];

  Map<String, dynamic> get _currentDhikr => _dhikrList[_selectedDhikrIndex];
  Color get _accentColor => _currentDhikr['color'] as Color;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() {
      _count++;
      _totalToday++;
      _showRipple = true;
    });
    _pulseController.forward().then((_) => _pulseController.reverse());

    // Smart haptic: milestone = heavy, normal = light
    final target = _currentDhikr['target'] as int;
    if (_count % target == 0) {
      HapticFeedback.heavyImpact();
      _showMilestoneSnack(target);
    } else if (_count % 33 == 0) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showRipple = false);
    });
  }

  void _showMilestoneSnack(int target) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 أحسنت! أتممت $target تسبيحة', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalToday / _goal;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: GestureDetector(
          onTap: _onTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // Ripple effect on tap
              if (_showRipple)
                Center(
                  child: Container(
                    width: 250, height: 250,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: _accentColor.withValues(alpha: 0.08)),
                  ).animate().scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5), duration: 300.ms).fadeOut(),
                ),
              Column(
                children: [
                  _buildTopBar(),
                  _buildGoalProgress(progress),
                  const Spacer(),
                  _buildCounterDisplay(),
                  const Spacer(),
                  _buildDhikrSelector(),
                  const SizedBox(height: 16),
                  _buildBottomStats(),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white70), onPressed: () => context.pop()),
          const Text('المسبحة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          IconButton(icon: const Icon(Icons.bar_chart_rounded, color: Colors.white70), onPressed: _showStatsSheet),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('هدف اليوم: $_goal', style: const TextStyle(color: Colors.white38, fontSize: 12)),
              Text('$_totalToday / $_goal', style: TextStyle(color: _accentColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterDisplay() {
    final target = _currentDhikr['target'] as int;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_currentDhikr['text'] as String, style: TextStyle(color: _accentColor.withValues(alpha: 0.8), fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        // Main counter circle
        ScaleTransition(
          scale: Tween(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut)),
          child: Container(
            width: 200, height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _accentColor.withValues(alpha: 0.3), width: 3),
              boxShadow: [BoxShadow(color: _accentColor.withValues(alpha: 0.15), blurRadius: 40, spreadRadius: 10)],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200, height: 200,
                  child: CircularProgressIndicator(
                    value: (_count % target) / target,
                    strokeWidth: 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$_count', style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold)),
                    Text('من $target', style: const TextStyle(color: Colors.white38, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('المس في أي مكان للتسبيح', style: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 12)),
        const SizedBox(height: 16),
        // Reset button
        GestureDetector(
          onTap: () => setState(() => _count = 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, color: Colors.white38, size: 16),
                SizedBox(width: 6),
                Text('إعادة العداد', style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDhikrSelector() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _dhikrList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final d = _dhikrList[i];
          final isSelected = i == _selectedDhikrIndex;
          final c = d['color'] as Color;
          return GestureDetector(
            onTap: () => setState(() { _selectedDhikrIndex = i; _count = 0; }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? c.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? c : Colors.transparent, width: 1.5),
              ),
              child: Text(d['text'] as String, style: TextStyle(color: isSelected ? c : Colors.white54, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('اليوم', '$_totalToday', Icons.today),
          Container(width: 1, height: 30, color: Colors.white.withValues(alpha: 0.1)),
          _buildStatItem('الأسبوع', '${_weeklyData.reduce((a, b) => a + b)}', Icons.date_range),
          Container(width: 1, height: 30, color: Colors.white.withValues(alpha: 0.1)),
          _buildStatItem('الهدف', '$_goal', Icons.flag_outlined),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white24, size: 18),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }

  // ─── Weekly Stats Sheet ───
  void _showStatsSheet() {
    final maxVal = _weeklyData.reduce((a, b) => a > b ? a : b).toDouble();
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(color: Color(0xFF252540), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('سجل الإنجاز الأسبوعي', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('أنت اليوم أنجزت أكثر من أمس بـ ${_totalToday > _weeklyData[5] ? _totalToday - _weeklyData[5] : 0} تسبيحة! 💪',
                  style: TextStyle(color: _accentColor, fontSize: 13)),
              const SizedBox(height: 24),
              SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (i) {
                    final isToday = i == 6;
                    final h = ((_weeklyData[i] / maxVal) * 80).clamp(8.0, 80.0);
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${_weeklyData[i]}', style: TextStyle(color: isToday ? _accentColor : Colors.white38, fontSize: 9)),
                          const SizedBox(height: 4),
                          Container(
                            height: h, margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isToday ? _accentColor : _accentColor.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(_weekDays[i], style: const TextStyle(color: Colors.white38, fontSize: 10)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              // Goal setter
              Row(
                children: [
                  const Icon(Icons.flag, color: Colors.white38, size: 18),
                  const SizedBox(width: 8),
                  const Text('تخصيص الهدف اليومي:', style: TextStyle(color: Colors.white54, fontSize: 13)),
                  const Spacer(),
                  ...[100, 500, 1000].map((g) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () { setState(() => _goal = g); Navigator.pop(ctx); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _goal == g ? _accentColor : Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('$g', style: TextStyle(color: _goal == g ? Colors.black : Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
