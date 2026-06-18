import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ChallengeCategory { quran, tasbeeh, azkar, prayer, general }

enum ChallengePeriod { daily, weekly }

class LeaderboardEntry {
  final String id;
  final String name;
  final int points;
  final String badge;
  final int quranPoints;
  final int tasbeehPoints;
  final int azkarPoints;
  final int streakDays;
  final int rank;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.id,
    required this.name,
    required this.points,
    this.badge = '',
    this.quranPoints = 0,
    this.tasbeehPoints = 0,
    this.azkarPoints = 0,
    this.streakDays = 0,
    this.rank = 0,
    this.isCurrentUser = false,
  });

  LeaderboardEntry copyWith({int? rank}) {
    return LeaderboardEntry(
      id: id,
      name: name,
      points: points,
      badge: badge,
      quranPoints: quranPoints,
      tasbeehPoints: tasbeehPoints,
      azkarPoints: azkarPoints,
      streakDays: streakDays,
      rank: rank ?? this.rank,
      isCurrentUser: isCurrentUser,
    );
  }
}

class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final ChallengeCategory category;
  final IconData icon;
  final int xpReward;
  final int targetCount;
  final int currentCount;
  final bool isCompleted;

  const DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    this.xpReward = 20,
    this.targetCount = 1,
    this.currentCount = 0,
    this.isCompleted = false,
  });

  DailyChallenge copyWith({int? currentCount, bool? isCompleted}) {
    return DailyChallenge(
      id: id,
      title: title,
      description: description,
      category: category,
      icon: icon,
      xpReward: xpReward,
      targetCount: targetCount,
      currentCount: currentCount ?? this.currentCount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  double get progress => (currentCount / targetCount).clamp(0.0, 1.0);
}

class KhatmahMember {
  final String id;
  final String name;
  final int juzCompleted;
  final int totalJuz;
  final String? currentJuz;

  const KhatmahMember({
    required this.id,
    required this.name,
    this.juzCompleted = 0,
    this.totalJuz = 30,
    this.currentJuz,
  });

  KhatmahMember copyWith({int? juzCompleted, String? currentJuz}) {
    return KhatmahMember(
      id: id,
      name: name,
      juzCompleted: juzCompleted ?? this.juzCompleted,
      totalJuz: totalJuz,
      currentJuz: currentJuz ?? this.currentJuz,
    );
  }

  double get progress => totalJuz > 0 ? juzCompleted / totalJuz : 0.0;
}

class KhatmahGroup {
  final String id;
  final String name;
  final String description;
  final int targetPages;
  final int pagesRead;
  final List<KhatmahMember> members;
  final String createdBy;
  final String inviteCode;

  const KhatmahGroup({
    required this.id,
    required this.name,
    this.description = '',
    this.targetPages = 604,
    this.pagesRead = 0,
    this.members = const [],
    required this.createdBy,
    this.inviteCode = '',
  });

  KhatmahGroup copyWith({
    int? pagesRead,
    List<KhatmahMember>? members,
  }) {
    return KhatmahGroup(
      id: id,
      name: name,
      description: description,
      targetPages: targetPages,
      pagesRead: pagesRead ?? this.pagesRead,
      members: members ?? this.members,
      createdBy: createdBy,
      inviteCode: inviteCode,
    );
  }

  double get progress => targetPages > 0 ? pagesRead / targetPages : 0.0;

  int get totalJuz => (targetPages / 20).ceil();
  int get juzCompleted => (pagesRead / 20).floor();
}

enum LeaderboardPeriod { weekly, monthly, allTime }

class SocialState {
  final List<LeaderboardEntry> leaderboard;
  final List<DailyChallenge> dailyChallenges;
  final List<DailyChallenge> weeklyChallenges;
  final List<KhatmahGroup> khatmahGroups;
  final LeaderboardPeriod selectedPeriod;
  final int userPoints;
  final int userLevel;
  final int userStreak;

  const SocialState({
    this.leaderboard = const [],
    this.dailyChallenges = const [],
    this.weeklyChallenges = const [],
    this.khatmahGroups = const [],
    this.selectedPeriod = LeaderboardPeriod.monthly,
    this.userPoints = 0,
    this.userLevel = 1,
    this.userStreak = 0,
  });

  SocialState copyWith({
    List<LeaderboardEntry>? leaderboard,
    List<DailyChallenge>? dailyChallenges,
    List<DailyChallenge>? weeklyChallenges,
    List<KhatmahGroup>? khatmahGroups,
    LeaderboardPeriod? selectedPeriod,
    int? userPoints,
    int? userLevel,
    int? userStreak,
  }) {
    return SocialState(
      leaderboard: leaderboard ?? this.leaderboard,
      dailyChallenges: dailyChallenges ?? this.dailyChallenges,
      weeklyChallenges: weeklyChallenges ?? this.weeklyChallenges,
      khatmahGroups: khatmahGroups ?? this.khatmahGroups,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      userPoints: userPoints ?? this.userPoints,
      userLevel: userLevel ?? this.userLevel,
      userStreak: userStreak ?? this.userStreak,
    );
  }
}

final socialProvider = NotifierProvider<SocialNotifier, SocialState>(SocialNotifier.new);

class SocialNotifier extends Notifier<SocialState> {
  int _nextGroupId = 0;
  int _nextMemberId = 0;

  @override
  SocialState build() {
    _initSampleData();
    return state;
  }

  void _initSampleData() {
    state = SocialState(
      leaderboard: _generateLeaderboard(),
      dailyChallenges: _generateDailyChallenges(),
      weeklyChallenges: _generateWeeklyChallenges(),
      khatmahGroups: _generateSampleGroups(),
      userPoints: 2450,
      userLevel: 8,
      userStreak: 12,
    );
  }

  List<LeaderboardEntry> _generateLeaderboard() {
    final rng = Random(42);
    final names = [
      'أحمد', 'محمد', 'فاطمة', 'عائشة', 'علي', 'خالد', 'نورة', 'سارة',
      'عمر', 'مريم', 'حسن', 'زينب', 'ياسر', 'ليلى', 'عبدالله', 'هند',
      'إبراهيم', 'رنا', 'يوسف', 'سمية',
    ];
    final badges = [
      'القارئ الذهبي', 'حافظ', 'الذاكر', 'المسبح', 'المجتهد',
      'الخاشع', 'القائم', 'الصائم', 'الدّاعي', 'الساعي',
    ];

    final entries = List.generate(20, (i) {
      final points = rng.nextInt(5000) + 500;
      return LeaderboardEntry(
        id: 'user_$i',
        name: names[i % names.length],
        points: points,
        badge: badges[rng.nextInt(badges.length)],
        quranPoints: rng.nextInt(2000),
        tasbeehPoints: rng.nextInt(1500),
        azkarPoints: rng.nextInt(1000),
        streakDays: rng.nextInt(30) + 1,
        isCurrentUser: i == 3,
      );
    });
    entries.sort((a, b) => b.points.compareTo(a.points));
    return [for (var i = 0; i < entries.length; i++) entries[i].copyWith(rank: i + 1)];
  }

  List<DailyChallenge> _generateDailyChallenges() {
    return [
      const DailyChallenge(
        id: 'd_quran_juz',
        title: 'اقرأ جزءاً واحداً',
        description: 'ختم وردك اليومي من القرآن',
        category: ChallengeCategory.quran,
        icon: Icons.menu_book,
        xpReward: 50,
        targetCount: 1,
      ),
      const DailyChallenge(
        id: 'd_tasbeeh',
        title: '١٠٠ تسبيحة',
        description: 'سبحان الله ١٠٠ مرة',
        category: ChallengeCategory.tasbeeh,
        icon: Icons.ads_click,
        xpReward: 30,
        targetCount: 100,
      ),
      const DailyChallenge(
        id: 'd_azkar_morning',
        title: 'أذكار الصباح',
        description: 'أذكار الصباح كاملة',
        category: ChallengeCategory.azkar,
        icon: Icons.wb_sunny,
        xpReward: 25,
        targetCount: 1,
      ),
      const DailyChallenge(
        id: 'd_azkar_evening',
        title: 'أذكار المساء',
        description: 'أذكار المساء كاملة',
        category: ChallengeCategory.azkar,
        icon: Icons.nights_stay,
        xpReward: 25,
        targetCount: 1,
      ),
      const DailyChallenge(
        id: 'd_prayer_on_time',
        title: 'صلِّ في وقتها',
        description: 'صلِّ جميع الصلوات في أوقاتها',
        category: ChallengeCategory.prayer,
        icon: Icons.mosque,
        xpReward: 40,
        targetCount: 5,
      ),
    ];
  }

  List<DailyChallenge> _generateWeeklyChallenges() {
    return [
      const DailyChallenge(
        id: 'w_khatma',
        title: 'ختمة الأسبوع',
        description: 'اختم ٣ أجزاء هذا الأسبوع',
        category: ChallengeCategory.quran,
        icon: Icons.done_all,
        xpReward: 200,
        targetCount: 3,
      ),
      const DailyChallenge(
        id: 'w_tasbeeh',
        title: '١٠٠٠ تسبيحة',
        description: 'سبح الله ١٠٠٠ مرة هذا الأسبوع',
        category: ChallengeCategory.tasbeeh,
        icon: Icons.replay,
        xpReward: 150,
        targetCount: 1000,
      ),
      const DailyChallenge(
        id: 'w_azkar',
        title: 'أذكار كاملة ٧ أيام',
        description: 'حافظ على الأذكار يومياً',
        category: ChallengeCategory.azkar,
        icon: Icons.star,
        xpReward: 180,
        targetCount: 7,
      ),
      const DailyChallenge(
        id: 'w_prayer',
        title: 'صلِّ في المسجد ٥ مرات',
        description: 'صلاة الجماعة في المسجد',
        category: ChallengeCategory.prayer,
        icon: Icons.mosque,
        xpReward: 160,
        targetCount: 5,
      ),
    ];
  }

  List<KhatmahGroup> _generateSampleGroups() {
    return [
      KhatmahGroup(
        id: _nextId(),
        name: 'ختمة المسجد',
        description: 'ختمة جماعية لأهل الحي',
        targetPages: 604,
        pagesRead: 320,
        createdBy: 'أحمد',
        inviteCode: 'KH123',
        members: [
          KhatmahMember(id: _nextMember(), name: 'أحمد', juzCompleted: 8, currentJuz: 'الجزء ٩'),
          KhatmahMember(id: _nextMember(), name: 'محمد', juzCompleted: 5, currentJuz: 'الجزء ٦'),
          KhatmahMember(id: _nextMember(), name: 'فاطمة', juzCompleted: 3, currentJuz: 'الجزء ٤'),
        ],
      ),
      KhatmahGroup(
        id: _nextId(),
        name: 'عائلتي',
        description: 'ختمة عائلية',
        targetPages: 604,
        pagesRead: 180,
        createdBy: 'فاطمة',
        inviteCode: 'KH456',
        members: [
          KhatmahMember(id: _nextMember(), name: 'فاطمة', juzCompleted: 4, currentJuz: 'الجزء ٥'),
          KhatmahMember(id: _nextMember(), name: 'علي', juzCompleted: 2, currentJuz: 'الجزء ٣'),
          KhatmahMember(id: _nextMember(), name: 'مريم', juzCompleted: 3, currentJuz: 'الجزء ٤'),
          KhatmahMember(id: _nextMember(), name: 'حسن', juzCompleted: 0, currentJuz: 'الجزء ١'),
        ],
      ),
      KhatmahGroup(
        id: _nextId(),
        name: 'الأصدقاء',
        description: 'ختمة مع الأصحاب',
        targetPages: 604,
        pagesRead: 590,
        createdBy: 'خالد',
        inviteCode: 'KH789',
        members: [
          KhatmahMember(id: _nextMember(), name: 'خالد', juzCompleted: 15, currentJuz: 'الجزء ١٦'),
          KhatmahMember(id: _nextMember(), name: 'عمر', juzCompleted: 12, currentJuz: 'الجزء ١٣'),
          KhatmahMember(id: _nextMember(), name: 'ياسر', juzCompleted: 3, currentJuz: 'الجزء ٤'),
        ],
      ),
    ];
  }

  String _nextId() => 'group_${_nextGroupId++}';
  String _nextMember() => 'member_${_nextMemberId++}';

  void setPeriod(LeaderboardPeriod period) {
    state = state.copyWith(selectedPeriod: period);
  }

  void updateChallengeProgress(String challengeId, int increment) {
    for (final list in [state.dailyChallenges, state.weeklyChallenges]) {
      final idx = list.indexWhere((c) => c.id == challengeId);
      if (idx >= 0 && !list[idx].isCompleted) {
        final challenge = list[idx];
        final newCount = challenge.currentCount + increment;
        final isCompleted = newCount >= challenge.targetCount;
        final updated = challenge.copyWith(
          currentCount: isCompleted ? challenge.targetCount : newCount,
          isCompleted: isCompleted,
        );
        final newList = [...list];
        newList[idx] = updated;

        var pts = state.userPoints;
        if (isCompleted) pts += challenge.xpReward;

        if (identical(list, state.dailyChallenges)) {
          state = state.copyWith(dailyChallenges: newList, userPoints: pts);
        } else {
          state = state.copyWith(weeklyChallenges: newList, userPoints: pts);
        }
        return;
      }
    }
  }

  void completeChallenge(String challengeId) {
    for (final list in [state.dailyChallenges, state.weeklyChallenges]) {
      final idx = list.indexWhere((c) => c.id == challengeId);
      if (idx >= 0 && !list[idx].isCompleted) {
        final challenge = list[idx];
        final updated = challenge.copyWith(
          currentCount: challenge.targetCount,
          isCompleted: true,
        );
        final newList = [...list];
        newList[idx] = updated;

        final pts = state.userPoints + challenge.xpReward;

        if (identical(list, state.dailyChallenges)) {
          state = state.copyWith(dailyChallenges: newList, userPoints: pts);
        } else {
          state = state.copyWith(weeklyChallenges: newList, userPoints: pts);
        }
        return;
      }
    }
  }

  KhatmahGroup createGroup(String name, String description) {
    final group = KhatmahGroup(
      id: _nextId(),
      name: name,
      description: description,
      createdBy: 'أحمد',
      inviteCode: 'KH${Random().nextInt(9000) + 1000}',
      members: [
        KhatmahMember(
          id: _nextMember(),
          name: 'أحمد',
          juzCompleted: 0,
          currentJuz: 'الجزء ١',
        ),
      ],
    );
    state = state.copyWith(khatmahGroups: [...state.khatmahGroups, group]);
    return group;
  }

  void joinGroup(String inviteCode) {
    final groups = state.khatmahGroups.map((g) {
      if (g.inviteCode == inviteCode) {
        final hasMember = g.members.any((m) => m.id == 'member_new');
        if (!hasMember) {
          return g.copyWith(members: [
            ...g.members,
            KhatmahMember(
              id: _nextMember(),
              name: 'أحمد',
              juzCompleted: 0,
              currentJuz: 'الجزء ١',
            ),
          ]);
        }
      }
      return g;
    }).toList();
    state = state.copyWith(khatmahGroups: groups);
  }

  void advanceMemberJuz(String groupId, String memberId) {
    final groups = state.khatmahGroups.map((g) {
      if (g.id != groupId) return g;
      final members = g.members.map((m) {
        if (m.id != memberId) return m;
        final nextJuz = m.juzCompleted + 1;
        return m.copyWith(
          juzCompleted: m.juzCompleted + 1,
          currentJuz: nextJuz >= m.totalJuz ? null : 'الجزء ${nextJuz + 1}',
        );
      }).toList();
      final totalRead = members.fold<int>(0, (sum, m) => sum + m.juzCompleted * 20);
      return g.copyWith(
        members: members,
        pagesRead: totalRead > g.targetPages ? g.targetPages : totalRead,
      );
    }).toList();
    state = state.copyWith(khatmahGroups: groups);
  }
}
