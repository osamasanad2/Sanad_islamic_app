import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/providers/shared_prefs_provider.dart';
import 'activity_models.dart';

const String _kActivityState = 'activity_state';
const String _kUserStats = 'activity_user_stats';
const String _kLastGeneration = 'activity_last_gen_date';
const String _kPathState = 'activity_path_state';

final activityProvider =
    NotifierProvider<ActivityNotifier, ActivityState>(ActivityNotifier.new);

class ActivityState {
  final List<Activity> dailyActivities;
  final List<Activity> weeklyChallenges;
  final List<Activity> monthlyGoals;
  final List<Activity> seasonalActivities;
  final List<SpiritualPath> spiritualPaths;
  final UserStats userStats;
  final String? currentSeason;
  final String todayHijriDate;
  final bool isLoading;

  const ActivityState({
    this.dailyActivities = const [],
    this.weeklyChallenges = const [],
    this.monthlyGoals = const [],
    this.seasonalActivities = const [],
    this.spiritualPaths = const [],
    this.userStats = const UserStats(),
    this.currentSeason,
    this.todayHijriDate = '',
    this.isLoading = true,
  });

  ActivityState copyWith({
    List<Activity>? dailyActivities,
    List<Activity>? weeklyChallenges,
    List<Activity>? monthlyGoals,
    List<Activity>? seasonalActivities,
    List<SpiritualPath>? spiritualPaths,
    UserStats? userStats,
    String? currentSeason,
    String? todayHijriDate,
    bool? isLoading,
  }) {
    return ActivityState(
      dailyActivities: dailyActivities ?? this.dailyActivities,
      weeklyChallenges: weeklyChallenges ?? this.weeklyChallenges,
      monthlyGoals: monthlyGoals ?? this.monthlyGoals,
      seasonalActivities: seasonalActivities ?? this.seasonalActivities,
      spiritualPaths: spiritualPaths ?? this.spiritualPaths,
      userStats: userStats ?? this.userStats,
      currentSeason: currentSeason ?? this.currentSeason,
      todayHijriDate: todayHijriDate ?? this.todayHijriDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<Activity> get filteredByCategory {
    return dailyActivities;
  }
}

class ActivityNotifier extends Notifier<ActivityState> {
  @override
  ActivityState build() {
    _init();
    return state;
  }

  Future<void> _init() async {
    final prefs = ref.read(sharedPrefsProvider);
    final lastGen = prefs.getString(_kLastGeneration);
    final today = _todayKey();

    HijriCalendar.setLocal('ar');
    final hijri = HijriCalendar.now();
    final hijriStr =
        '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} هـ';

    final season = _detectSeason(hijri);

    final stats = _loadStats(prefs);

    if (lastGen != today) {
      await _regenerateAll(prefs, stats, hijri, season);
    } else {
      _loadFromCache(prefs, stats, hijriStr, season);
    }
  }

  String _todayKey() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  String _weekKey() {
    final n = DateTime.now();
    final week = ((n.dayOfWeek == 6 ? n.day + 2 : n.day) / 7).ceil();
    return '${n.year}-W${week.toString().padLeft(2, '0')}';
  }

  String? _detectSeason(HijriCalendar today) {
    final m = today.hMonth;
    final d = today.hDay;

    if (m == 9) return 'ramadan';
    if (m == 10 && d <= 3) return 'eid_fitr';
    if (m == 12 && d <= 13) {
      if (d == 9) return 'arafah';
      if (d >= 10 && d <= 13) return 'eid_adha';
      return 'dhul_hijjah';
    }
    if (m == 1 && d == 10) return 'ashura';
    if (m == 7) return 'rajab';
    if (m == 8) return 'shaban';
    if (m == 3) return 'rabi_al_awwal';
    return null;
  }

  UserStats _loadStats(SharedPreferences prefs) {
    final raw = prefs.getString(_kUserStats);
    if (raw == null) return const UserStats();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final counts = <ActivityCategory, int>{};
      if (map['categoryCounts'] != null) {
        (map['categoryCounts'] as Map).forEach((k, v) {
          counts[ActivityCategory.values[int.parse(k)]] = v as int;
        });
      }
      return UserStats(
        level: map['level'] as int? ?? 1,
        xp: map['xp'] as int? ?? 0,
        xpToNextLevel: map['xpToNextLevel'] as int? ?? 100,
        categoryCounts: counts,
        streakDays: map['streakDays'] as int? ?? 0,
        badges: (map['badges'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        totalCompletedToday: map['totalCompletedToday'] as int? ?? 0,
        dailyGoal: map['dailyGoal'] as int? ?? 5,
      );
    } catch (_) {
      return const UserStats();
    }
  }

  void _saveStats(SharedPreferences prefs, UserStats stats) {
    final counts = <String, int>{};
    for (final entry in stats.categoryCounts.entries) {
      counts[entry.key.index.toString()] = entry.value;
    }
    prefs.setString(
      _kUserStats,
      jsonEncode({
        'level': stats.level,
        'xp': stats.xp,
        'xpToNextLevel': stats.xpToNextLevel,
        'categoryCounts': counts,
        'streakDays': stats.streakDays,
        'badges': stats.badges,
        'totalCompletedToday': stats.totalCompletedToday,
        'dailyGoal': stats.dailyGoal,
      }),
    );
  }

  void _loadFromCache(
    SharedPreferences prefs,
    UserStats stats,
    String hijriStr,
    String? season,
  ) {
    final raw = prefs.getString(_kActivityState);
    if (raw == null) {
      _regenerateAll(prefs, stats, HijriCalendar.now(), season);
      return;
    }
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final daily = (data['daily'] as List<dynamic>?)
              ?.map((e) => _activityFromTemplate(
                  e['id'] as String, e['completed'] as bool? ?? false,
                  (e['progress'] as num?)?.toDouble() ?? 0.0))
              .whereType<Activity>()
              .toList() ??
          <Activity>[];
      final weekly = (data['weekly'] as List<dynamic>?)
              ?.map((e) => _activityFromTemplate(
                  e['id'] as String, e['completed'] as bool? ?? false,
                  (e['progress'] as num?)?.toDouble() ?? 0.0))
              .whereType<Activity>()
              .toList() ??
          <Activity>[];
      final monthly = (data['monthly'] as List<dynamic>?)
              ?.map((e) => _activityFromTemplate(
                  e['id'] as String, e['completed'] as bool? ?? false,
                  (e['progress'] as num?)?.toDouble() ?? 0.0))
              .whereType<Activity>()
              .toList() ??
          <Activity>[];
      final seasonal = (data['seasonal'] as List<dynamic>?)
              ?.map((e) => _activityFromTemplate(
                  e['id'] as String, e['completed'] as bool? ?? false,
                  (e['progress'] as num?)?.toDouble() ?? 0.0))
              .whereType<Activity>()
              .toList() ??
          <Activity>[];

      final paths = _loadPaths(prefs);

      state = ActivityState(
        dailyActivities: daily,
        weeklyChallenges: weekly,
        monthlyGoals: monthly,
        seasonalActivities: seasonal,
        spiritualPaths: paths,
        userStats: stats,
        currentSeason: season,
        todayHijriDate: hijriStr,
        isLoading: false,
      );
    } catch (_) {
      _regenerateAll(prefs, stats, HijriCalendar.now(), season);
    }
  }

  Activity? _activityFromTemplate(String id, bool completed, double progress) {
    final template = _allTemplates.firstWhere(
      (t) => t.id == id,
      orElse: () => _allTemplates.first,
    );
    return template.copyWith(isCompleted: completed, progress: progress);
  }

  List<SpiritualPath> _loadPaths(SharedPreferences prefs) {
    final raw = prefs.getString(_kPathState);
    if (raw == null) return _defaultPaths;
    try {
      final data = jsonDecode(raw) as List<dynamic>;
      return _defaultPaths.asMap().entries.map((entry) {
        final i = entry.key;
        final path = entry.value;
        if (i >= data.length) return path;
        final saved = data[i] as Map<String, dynamic>;
        final stages = path.stages.asMap().entries.map((se) {
          final j = se.key;
          final stage = se.value;
          if (j >= ((saved['stages'] as List<dynamic>?)?.length ?? 0)) {
            return stage;
          }
          final ss = (saved['stages'] as List<dynamic>)[j] as Map<String, dynamic>;
          return stage.copyWith(
            isCompleted: ss['isCompleted'] as bool? ?? false,
            progress: (ss['progress'] as num?)?.toDouble() ?? 0.0,
          );
        }).toList();
        return path.copyWith(
          stages: stages,
          currentStageIndex: saved['currentStageIndex'] as int? ?? 0,
          isActive: saved['isActive'] as bool? ?? false,
        );
      }).toList();
    } catch (_) {
      return _defaultPaths;
    }
  }

  void _savePaths(SharedPreferences prefs) {
    prefs.setString(
      _kPathState,
      jsonEncode(
        state.spiritualPaths.map((p) {
          return {
            'currentStageIndex': p.currentStageIndex,
            'isActive': p.isActive,
            'stages': p.stages.map((s) => s.toJson()).toList(),
          };
        }).toList(),
      ),
    );
  }

  Future<void> _regenerateAll(
    SharedPreferences prefs,
    UserStats stats,
    HijriCalendar hijri,
    String? season,
  ) async {
    final weekChanged =
        prefs.getString('${_kLastGeneration}_week') != _weekKey();
    final monthChanged =
        prefs.getString('${_kLastGeneration}_month') != '${DateTime.now().month}';

    final daily = _generateDailyActivities(stats, season);
    final weekly = weekChanged ? _generateWeeklyChallenges(stats, season) : <Activity>[];
    final monthly = monthChanged ? _generateMonthlyGoals(stats, season) : <Activity>[];
    final seasonal = season != null ? _generateSeasonalActivities(season) : <Activity>[];

    prefs.setString(_kLastGeneration, _todayKey());
    prefs.setString('${_kLastGeneration}_week', _weekKey());
    prefs.setString('${_kLastGeneration}_month', '${DateTime.now().month}');

    final cache = {
      'daily': daily.map((a) => {'id': a.id, 'completed': a.isCompleted, 'progress': a.progress}).toList(),
      'weekly': weekly.map((a) => {'id': a.id, 'completed': a.isCompleted, 'progress': a.progress}).toList(),
      'monthly': monthly.map((a) => {'id': a.id, 'completed': a.isCompleted, 'progress': a.progress}).toList(),
      'seasonal': seasonal.map((a) => {'id': a.id, 'completed': a.isCompleted, 'progress': a.progress}).toList(),
    };
    prefs.setString(_kActivityState, jsonEncode(cache));

    HijriCalendar.setLocal('ar');
    final hijriToday = HijriCalendar.now();
    final hijriStr =
        '${hijriToday.hDay} ${hijriToday.longMonthName} ${hijriToday.hYear} هـ';

    final paths = _loadPaths(prefs);

    state = ActivityState(
      dailyActivities: daily,
      weeklyChallenges: weekly,
      monthlyGoals: monthly,
      seasonalActivities: seasonal,
      spiritualPaths: paths,
      userStats: stats,
      currentSeason: season,
      todayHijriDate: hijriStr,
      isLoading: false,
    );
  }

  // ─── Activity Templates ───

  static const List<Activity> _allTemplates = [
    // --- Daily Activities ---
    Activity(id: 'quran_page', title: 'اقرأ صفحة من القرآن', description: 'صفحة واحدة على الأقل', category: ActivityCategory.quran, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.menu_book, xpReward: 15),
    Activity(id: 'quran_three_pages', title: 'اقرأ ٣ صفحات', description: 'ختم وردك اليومي', category: ActivityCategory.quran, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.medium, icon: Icons.menu_book, xpReward: 30),
    Activity(id: 'quran_ayat', title: 'احفظ آية', description: 'احفظ آية جديدة اليوم', category: ActivityCategory.quran, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.medium, icon: Icons.auto_stories, xpReward: 25),
    Activity(id: 'quran_tafsir', title: 'اقرأ تفسير آية', description: 'افهم معنى آية من كتاب الله', category: ActivityCategory.quran, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.lightbulb_outline, xpReward: 20),
    Activity(id: 'azkar_morning', title: 'أذكار الصباح', description: 'ابدأ يومك بأذكار الصباح', category: ActivityCategory.azkar, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.wb_sunny, xpReward: 20),
    Activity(id: 'azkar_evening', title: 'أذكار المساء', description: 'اختتم يومك بالأذكار', category: ActivityCategory.azkar, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.nights_stay, xpReward: 20),
    Activity(id: 'azkar_sleep', title: 'أذكار النوم', description: 'أذكار قبل النوم', category: ActivityCategory.azkar, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.bedtime, xpReward: 15),
    Activity(id: 'hadith_read', title: 'اقرأ حديثاً', description: 'حديث نبوي شريف', category: ActivityCategory.hadith, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.format_quote, xpReward: 15),
    Activity(id: 'hadith_memorize', title: 'احفظ حديثاً', description: 'حفظ حديث قصير', category: ActivityCategory.hadith, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.medium, icon: Icons.psychology, xpReward: 25),
    Activity(id: 'dua_read', title: 'ادع الله', description: 'اقرأ أدعية متنوعة', category: ActivityCategory.dua, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.pan_tool, xpReward: 10),
    Activity(id: 'prayer_sunnah', title: 'صلاة الضحى', description: 'ركعتا الضحى', category: ActivityCategory.prayer, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.wb_cloudy, xpReward: 25),
    Activity(id: 'prayer_tahajjud', title: 'قيام الليل', description: 'تهجد ولو بركعتين', category: ActivityCategory.prayer, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.hard, icon: Icons.nightlight_round, xpReward: 40),
    Activity(id: 'prayer_mosque', title: 'صلاة الجماعة', description: 'صلِّ في المسجد', category: ActivityCategory.prayer, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.medium, icon: Icons.mosque, xpReward: 30),
    Activity(id: 'seerah_read', title: 'اقرأ في السيرة', description: 'تعرف على سيرة النبي ﷺ', category: ActivityCategory.seerah, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.auto_stories, xpReward: 20),
    Activity(id: 'istighfar', title: 'أكثر من الاستغفار', description: 'استغفر الله ١٠٠ مرة', category: ActivityCategory.azkar, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.replay, xpReward: 15),
    Activity(id: 'salawat', title: 'صلِّ على النبي ﷺ', description: 'أكثر من الصلاة على النبي', category: ActivityCategory.azkar, period: ActivityPeriod.daily, difficulty: ActivityDifficulty.easy, icon: Icons.favorite, xpReward: 15),
    // --- Weekly Challenges ---
    Activity(id: 'week_kahf', title: 'سورة الكهف', description: 'اقرأ سورة الكهف', category: ActivityCategory.quran, period: ActivityPeriod.weekly, difficulty: ActivityDifficulty.easy, icon: Icons.menu_book, xpReward: 50),
    Activity(id: 'week_juz', title: 'ختم جزء كامل', description: 'اقرأ جزءاً كاملاً هذا الأسبوع', category: ActivityCategory.quran, period: ActivityPeriod.weekly, difficulty: ActivityDifficulty.medium, icon: Icons.layers, xpReward: 80),
    Activity(id: 'week_azkar_streak', title: 'أذكار ٧ أيام', description: 'حافظ على أذكار الصباح والمساء', category: ActivityCategory.azkar, period: ActivityPeriod.weekly, difficulty: ActivityDifficulty.medium, icon: Icons.star, xpReward: 70),
    Activity(id: 'week_hadith', title: 'اقرأ ٢٠ حديثاً', description: 'تصفح ٢٠ حديثاً هذا الأسبوع', category: ActivityCategory.hadith, period: ActivityPeriod.weekly, difficulty: ActivityDifficulty.medium, icon: Icons.collections_bookmark, xpReward: 60),
    Activity(id: 'week_dua', title: 'سلسلة أدعية', description: 'ادعُ بـ ١٠ أدعية مختلفة', category: ActivityCategory.dua, period: ActivityPeriod.weekly, difficulty: ActivityDifficulty.easy, icon: Icons.favorite, xpReward: 40),
    // --- Monthly Goals ---
    Activity(id: 'month_khatma', title: 'ختمة هذا الشهر', description: 'اختم القرآن هذا الشهر', category: ActivityCategory.quran, period: ActivityPeriod.monthly, difficulty: ActivityDifficulty.hard, icon: Icons.done_all, xpReward: 200),
    Activity(id: 'month_ward', title: 'الورد اليومي ٣٠ يوماً', description: 'حافظ على ورد يومي طوال الشهر', category: ActivityCategory.quran, period: ActivityPeriod.monthly, difficulty: ActivityDifficulty.hard, icon: Icons.calendar_month, xpReward: 150),
    Activity(id: 'month_prayer', title: 'صلاة الجماعة ٣٠ يوماً', description: 'صلِّ الجماعة لمدة شهر كامل', category: ActivityCategory.prayer, period: ActivityPeriod.monthly, difficulty: ActivityDifficulty.hard, icon: Icons.mosque, xpReward: 180),
  ];

  static const Map<String, List<Activity>> _seasonalTemplates = {
    'ramadan': [
      Activity(id: 'ramadan_khatma', title: 'ختمة رمضان', description: 'اختم القرآن في الشهر الفضيل', category: ActivityCategory.quran, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.hard, icon: Icons.done_all, seasonalEvent: 'ramadan', xpReward: 300),
      Activity(id: 'ramadan_taraweeh', title: 'صلاة التراويح', description: 'صلاة التراويح كل ليلة', category: ActivityCategory.prayer, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.medium, icon: Icons.nightlight, seasonalEvent: 'ramadan', xpReward: 50),
      Activity(id: 'ramadan_qiyam', title: 'قيام رمضان', description: 'صلاة القيام في العشر الأواخر', category: ActivityCategory.prayer, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.hard, icon: Icons.nightlight_round, seasonalEvent: 'ramadan', xpReward: 80),
      Activity(id: 'ramadan_sadaqa', title: 'صدقة رمضان', description: 'تصدق ولو بالقليل', category: ActivityCategory.challenge, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.easy, icon: Icons.volunteer_activism, seasonalEvent: 'ramadan', xpReward: 30),
      Activity(id: 'ramadan_azkar', title: 'أذكار رمضان', description: 'أذكار و أدعية رمضانية', category: ActivityCategory.azkar, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.easy, icon: Icons.wb_sunny, seasonalEvent: 'ramadan', xpReward: 25),
    ],
    'dhul_hijjah': [
      Activity(id: 'dhulhijjah_fasting', title: 'صيام العشر', description: 'صُموا الأيام التسعة الأولى', category: ActivityCategory.prayer, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.medium, icon: Icons.restaurant, seasonalEvent: 'dhul_hijjah', xpReward: 60),
      Activity(id: 'dhulhijjah_takbeer', title: 'التكبير', description: 'أكثر من التكبير في أيام التشريق', category: ActivityCategory.azkar, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.easy, icon: Icons.volume_up, seasonalEvent: 'dhul_hijjah', xpReward: 30),
    ],
    'arafah': [
      Activity(id: 'arafah_fasting', title: 'صيام عرفة', description: 'صيام يوم عرفة يكفر سنتين', category: ActivityCategory.prayer, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.medium, icon: Icons.restaurant, seasonalEvent: 'arafah', xpReward: 80),
      Activity(id: 'arafah_dua', title: 'دعاء عرفة', description: 'أفضل الدعاء دعاء يوم عرفة', category: ActivityCategory.dua, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.easy, icon: Icons.pan_tool, seasonalEvent: 'arafah', xpReward: 50),
    ],
    'eid_adha': [
      Activity(id: 'eidadha_takbeer', title: 'تكبيرات العيد', description: 'التكبير في العيد', category: ActivityCategory.azkar, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.easy, icon: Icons.volume_up, seasonalEvent: 'eid_adha', xpReward: 20),
      Activity(id: 'eidadha_sunnah', title: 'سنن العيد', description: 'اغتسل وتطيب واذهب لصلاة العيد', category: ActivityCategory.prayer, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.easy, icon: Icons.checkroom, seasonalEvent: 'eid_adha', xpReward: 30),
    ],
    'eid_fitr': [
      Activity(id: 'eidfitr_takbeer', title: 'تكبيرات العيد', description: 'التكبير من ليلة العيد', category: ActivityCategory.azkar, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.easy, icon: Icons.volume_up, seasonalEvent: 'eid_fitr', xpReward: 20),
      Activity(id: 'eidfitr_zakat', title: 'زكاة الفطر', description: 'أخرج زكاة الفطر قبل الصلاة', category: ActivityCategory.challenge, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.medium, icon: Icons.volunteer_activism, seasonalEvent: 'eid_fitr', xpReward: 50),
    ],
    'ashura': [
      Activity(id: 'ashura_fasting', title: 'صيام عاشوراء', description: 'صيام يوم عاشوراء يكفر سنة', category: ActivityCategory.prayer, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.medium, icon: Icons.restaurant, seasonalEvent: 'ashura', xpReward: 60),
      Activity(id: 'ashura_reading', title: 'فضل عاشوراء', description: 'اقرأ عن فضل يوم عاشوراء', category: ActivityCategory.seerah, period: ActivityPeriod.seasonal, difficulty: ActivityDifficulty.easy, icon: Icons.auto_stories, seasonalEvent: 'ashura', xpReward: 20),
    ],
  };

  // ─── Generation Logic ───

  List<Activity> _generateDailyActivities(UserStats stats, String? season) {
    final today = DateTime.now().weekday;
    final isFriday = today == DateTime.friday;
    final rand = DateTime.now().millisecondsSinceEpoch % 100;

    final pool = <Activity>[..._allTemplates.where((a) => a.period == ActivityPeriod.daily)];
    final selected = <Activity>[];
    final usedIds = <String>{};

    void pick(int count, bool Function(Activity) filter) {
      final candidates = pool.where((a) => filter(a) && !usedIds.contains(a.id)).toList()..shuffle(Random(rand));
      for (var i = 0; i < count && i < candidates.length; i++) {
        selected.add(candidates[i]);
        usedIds.add(candidates[i].id);
      }
    }

    // Pick based on behavior
    final counts = stats.categoryCounts;
    final top = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topCategory = top.isNotEmpty ? top.first.key : null;

    final lowActivity = stats.totalCompletedToday < 2;

    if (lowActivity) {
      // Easy activities for low-activity users
      pick(3, (a) => a.difficulty == ActivityDifficulty.easy);
      pick(1, (a) => a.difficulty == ActivityDifficulty.medium);
    } else if (topCategory != null) {
      // Prioritize user's preferred category
      pick(2, (a) => a.category == topCategory && a.difficulty == ActivityDifficulty.easy);
      pick(2, (a) => a.category == topCategory && a.difficulty == ActivityDifficulty.medium);
      pick(1, (a) => a.difficulty == ActivityDifficulty.easy && a.category != topCategory);
      pick(1, (a) => a.difficulty == ActivityDifficulty.hard);
    } else {
      pick(2, (a) => a.difficulty == ActivityDifficulty.easy);
      pick(2, (a) => a.difficulty == ActivityDifficulty.medium);
      pick(1, (a) => a.difficulty == ActivityDifficulty.hard);
    }

    // Ensure variety: at least 2 different categories
    final cats = selected.map((a) => a.category).toSet();
    if (cats.length < 2 && selected.length >= 3) {
      final other = pool.where((a) => !usedIds.contains(a.id) && !cats.contains(a.category)).toList()..shuffle(Random(rand + 1));
      if (other.isNotEmpty) {
        selected.removeLast();
        selected.add(other.first);
        usedIds.add(other.first.id);
      }
    }

    // Add Friday-specific
    if (isFriday) {
      if (!usedIds.contains('week_kahf')) {
        selected.add(_allTemplates.firstWhere((a) => a.id == 'week_kahf'));
      }
    }

    return selected.take(6).toList();
  }

  List<Activity> _generateWeeklyChallenges(UserStats stats, String? season) {
    final pool = _allTemplates.where((a) => a.period == ActivityPeriod.weekly).toList()..shuffle(Random(DateTime.now().millisecondsSinceEpoch));
    return pool.take(3).toList();
  }

  List<Activity> _generateMonthlyGoals(UserStats stats, String? season) {
    return _allTemplates.where((a) => a.period == ActivityPeriod.monthly).toList();
  }

  List<Activity> _generateSeasonalActivities(String season) {
    return _seasonalTemplates[season] ?? [];
  }

  // ─── Default Spiritual Paths ───

  static const List<SpiritualPath> _defaultPaths = [
    SpiritualPath(
      id: 'tranquility',
      title: 'مسار الطمأنينة',
      description: 'أذكار القلق والراحة النفسية',
      icon: Icons.self_improvement,
      color: Color(0xFF64B5F6),
      stages: [
        PathStage(id: 'tranq_1', title: 'أذكار الصباح', description: 'المواظبة على أذكار الصباح لمدة ٣ أيام', xpReward: 30),
        PathStage(id: 'tranq_2', title: 'أذكار المساء', description: 'المواظبة على أذكار المساء لمدة ٣ أيام', xpReward: 30),
        PathStage(id: 'tranq_3', title: 'الاستغفار', description: 'استغفر الله ١٠٠ مرة يومياً لمدة أسبوع', xpReward: 50),
        PathStage(id: 'tranq_4', title: 'الصلاة على النبي', description: 'صلِّ على النبي ﷺ ١٠٠ مرة يومياً', xpReward: 50),
        PathStage(id: 'tranq_5', title: 'الطمأنينة', description: 'أكمل المسار وذق حلاوة الإيمان', xpReward: 100),
      ],
    ),
    SpiritualPath(
      id: 'habit_builder',
      title: 'بناء عادة',
      description: 'بناء عادات إيمانية يومية',
      icon: Icons.wb_sunny_rounded,
      color: Color(0xFFFFB74D),
      stages: [
        PathStage(id: 'habit_1', title: 'صلاة الضحى', description: 'صلاة ركعتا الضحى لمدة ٣ أيام', xpReward: 30),
        PathStage(id: 'habit_2', title: 'الورد القرآني', description: 'قراءة صفحة يومياً لمدة ٧ أيام', xpReward: 50),
        PathStage(id: 'habit_3', title: 'الذكر الدائم', description: 'ذكر الله في كل حال لمدة أسبوع', xpReward: 50),
        PathStage(id: 'habit_4', title: 'قيام الليل', description: 'قيام ركعتين قبل النوم لمدة ١٠ أيام', xpReward: 80),
        PathStage(id: 'habit_5', title: 'العادة الراسخة', description: 'أكمل ٢١ يوماً من العبادات اليومية', xpReward: 150),
      ],
    ),
    SpiritualPath(
      id: 'quran_path',
      title: 'مسار القرآن',
      description: 'رحلة مع كتاب الله',
      icon: Icons.menu_book,
      color: Color(0xFF81C784),
      stages: [
        PathStage(id: 'quran_1', title: 'صفحة يومياً', description: 'اقرأ صفحة كل يوم لمدة أسبوع', xpReward: 40),
        PathStage(id: 'quran_2', title: 'الحفظ', description: 'احفظ ٣ آيات أسبوعياً', xpReward: 50),
        PathStage(id: 'quran_3', title: 'التفسير', description: 'اقرأ تفسير الآيات التي تحفظها', xpReward: 40),
        PathStage(id: 'quran_4', title: 'المراجعة', description: 'راجع ما حفظته في الأسبوع الماضي', xpReward: 30),
        PathStage(id: 'quran_5', title: 'الختمة', description: 'أكمل قراءة جزء كامل', xpReward: 100),
      ],
    ),
    SpiritualPath(
      id: 'azkar_path',
      title: 'مسار الأذكار',
      description: 'حصنك اليومي',
      icon: Icons.favorite,
      color: Color(0xFFE57373),
      stages: [
        PathStage(id: 'azkar_1', title: 'أذكار الصباح', description: 'المواظبة أسبوع كامل', xpReward: 30),
        PathStage(id: 'azkar_2', title: 'أذكار المساء', description: 'المواظبة أسبوع كامل', xpReward: 30),
        PathStage(id: 'azkar_3', title: 'أذكار النوم', description: 'أذكار النوم يومياً', xpReward: 30),
        PathStage(id: 'azkar_4', title: 'أذكار متنوعة', description: 'تعلّم ١٠ أذكار جديدة', xpReward: 50),
        PathStage(id: 'azkar_5', title: 'الحصن المتين', description: 'أتممت بناء حصنك اليومي', xpReward: 100),
      ],
    ),
    SpiritualPath(
      id: 'istighfar_path',
      title: 'مسار الاستغفار',
      description: 'طريق المغفرة والرزق',
      icon: Icons.replay,
      color: Color(0xFF9575CD),
      stages: [
        PathStage(id: 'ist_1', title: 'البداية', description: 'استغفر ١٠٠ مرة في اليوم', xpReward: 20),
        PathStage(id: 'ist_2', title: 'المداومة', description: 'استغفر ٣٠٠ مرة يومياً لمدة أسبوع', xpReward: 40),
        PathStage(id: 'ist_3', title: 'سيد الاستغفار', description: 'تعلم وردد سيد الاستغفار يومياً', xpReward: 30),
        PathStage(id: 'ist_4', title: 'الاستغفار بالليل', description: 'استغفر في جوف الليل', xpReward: 50),
        PathStage(id: 'ist_5', title: 'المغفرة', description: 'أكمل مسار الاستغفار', xpReward: 100),
      ],
    ),
    SpiritualPath(
      id: 'prayer_path',
      title: 'مسار الصلاة',
      description: 'إحياء سنة الصلاة',
      icon: Icons.mosque,
      color: Color(0xFF4FC3F7),
      stages: [
        PathStage(id: 'pray_1', title: 'السنن الرواتب', description: 'حافظ على السنن الرواتب لمدة أسبوع', xpReward: 40),
        PathStage(id: 'pray_2', title: 'صلاة الضحى', description: 'صلِّ الضحى كل يوم لمدة أسبوع', xpReward: 40),
        PathStage(id: 'pray_3', title: 'صلاة الجماعة', description: 'صلِّ الجماعة في المسجد ٥ أيام', xpReward: 50),
        PathStage(id: 'pray_4', title: 'قيام الليل', description: 'قم الليل ولو بركعتين', xpReward: 60),
        PathStage(id: 'pray_5', title: 'خشوع', description: 'أكمل مسار الصلاة بخشوع', xpReward: 100),
      ],
    ),
  ];

  // ─── Public API ───

  void completeActivity(String activityId) {
    final prefs = ref.read(sharedPrefsProvider);

    for (final list in [
      state.dailyActivities,
      state.weeklyChallenges,
      state.monthlyGoals,
      state.seasonalActivities,
    ]) {
      final idx = list.indexWhere((a) => a.id == activityId);
      if (idx >= 0 && !list[idx].isCompleted) {
        final updated = list[idx].copyWith(isCompleted: true, progress: 1.0);
        final newList = [...list];
        newList[idx] = updated;

        var stats = state.userStats;
        final newXp = stats.xp + updated.xpReward;
        final newCounts = Map<ActivityCategory, int>.from(stats.categoryCounts);
        newCounts[updated.category] = (newCounts[updated.category] ?? 0) + 1;

        var newLevel = stats.level;
        var newXpToNext = stats.xpToNextLevel;
        var remainingXp = newXp;
        while (remainingXp >= newXpToNext) {
          remainingXp -= newXpToNext;
          newLevel++;
          newXpToNext = (newXpToNext * 1.3).round();
        }

        stats = stats.copyWith(
          xp: remainingXp,
          level: newLevel,
          xpToNextLevel: newXpToNext,
          categoryCounts: newCounts,
          totalCompletedToday: stats.totalCompletedToday + 1,
        );

        _saveStats(prefs, stats);

        // Determine which list to update
        if (identical(list, state.dailyActivities)) {
          state = state.copyWith(dailyActivities: newList, userStats: stats);
        } else if (identical(list, state.weeklyChallenges)) {
          state = state.copyWith(weeklyChallenges: newList, userStats: stats);
        } else if (identical(list, state.monthlyGoals)) {
          state = state.copyWith(monthlyGoals: newList, userStats: stats);
        } else if (identical(list, state.seasonalActivities)) {
          state = state.copyWith(seasonalActivities: newList, userStats: stats);
        }

        _saveActivityState(prefs);
        return;
      }
    }
  }

  void advancePathStage(int pathIndex) {
    if (pathIndex >= state.spiritualPaths.length) return;
    final path = state.spiritualPaths[pathIndex];
    if (path.currentStageIndex >= path.stages.length) return;

    final stages = [...path.stages];
    final stage = stages[path.currentStageIndex];
    stages[path.currentStageIndex] = stage.copyWith(isCompleted: true);

    final nextIndex = path.currentStageIndex + 1;
    final isCompleted = nextIndex >= stages.length;
    final updatedPath = path.copyWith(
      stages: stages,
      currentStageIndex: isCompleted ? path.currentStageIndex : nextIndex,
      isActive: !isCompleted,
      isCompleted: isCompleted,
    );

    final paths = [...state.spiritualPaths];
    paths[pathIndex] = updatedPath;

    state = state.copyWith(spiritualPaths: paths);

    // Award XP
    final prefs = ref.read(sharedPrefsProvider);
    var stats = state.userStats;
    final newXp = stats.xp + stage.xpReward;
    var newLevel = stats.level;
    var newXpToNext = stats.xpToNextLevel;
    var remainingXp = newXp;
    while (remainingXp >= newXpToNext) {
      remainingXp -= newXpToNext;
      newLevel++;
      newXpToNext = (newXpToNext * 1.3).round();
    }
    stats = stats.copyWith(
      xp: remainingXp,
      level: newLevel,
      xpToNextLevel: newXpToNext,
    );
    state = state.copyWith(userStats: stats);
    _saveStats(prefs, stats);
    _savePaths(prefs);
  }

  void startPath(int pathIndex) {
    if (pathIndex >= state.spiritualPaths.length) return;
    final paths = [...state.spiritualPaths];
    paths[pathIndex] = paths[pathIndex].copyWith(isActive: true);
    state = state.copyWith(spiritualPaths: paths);
    final prefs = ref.read(sharedPrefsProvider);
    _savePaths(prefs);
  }

  void _saveActivityState(SharedPreferences prefs) {
    prefs.setString(
      _kActivityState,
      jsonEncode({
        'daily': state.dailyActivities
            .map((a) => {'id': a.id, 'completed': a.isCompleted, 'progress': a.progress})
            .toList(),
        'weekly': state.weeklyChallenges
            .map((a) => {'id': a.id, 'completed': a.isCompleted, 'progress': a.progress})
            .toList(),
        'monthly': state.monthlyGoals
            .map((a) => {'id': a.id, 'completed': a.isCompleted, 'progress': a.progress})
            .toList(),
        'seasonal': state.seasonalActivities
            .map((a) => {'id': a.id, 'completed': a.isCompleted, 'progress': a.progress})
            .toList(),
      }),
    );
  }
}

extension on DateTime {
  int get dayOfWeek => weekday;
}
