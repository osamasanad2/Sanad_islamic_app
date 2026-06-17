import 'package:flutter/material.dart';

enum ActivityCategory { quran, azkar, prayer, hadith, dua, seerah, challenge }

enum ActivityPeriod { daily, weekly, monthly, seasonal }

enum ActivityDifficulty { easy, medium, hard }

class Activity {
  final String id;
  final String title;
  final String description;
  final ActivityCategory category;
  final ActivityPeriod period;
  final ActivityDifficulty difficulty;
  final IconData icon;
  final int xpReward;
  final bool isCompleted;
  final double progress;
  final String? actionRoute;
  final String? seasonalEvent;

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.period,
    required this.difficulty,
    required this.icon,
    this.xpReward = 10,
    this.isCompleted = false,
    this.progress = 0.0,
    this.actionRoute,
    this.seasonalEvent,
  });

  Activity copyWith({
    bool? isCompleted,
    double? progress,
  }) {
    return Activity(
      id: id,
      title: title,
      description: description,
      category: category,
      period: period,
      difficulty: difficulty,
      icon: icon,
      xpReward: xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
      actionRoute: actionRoute,
      seasonalEvent: seasonalEvent,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'isCompleted': isCompleted,
        'progress': progress,
      };

  static Activity fromJson(Map<String, dynamic> json, Activity template) {
    return template.copyWith(
      isCompleted: json['isCompleted'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class PathStage {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final bool isCompleted;
  final double progress;

  const PathStage({
    required this.id,
    required this.title,
    required this.description,
    this.xpReward = 20,
    this.isCompleted = false,
    this.progress = 0.0,
  });

  PathStage copyWith({bool? isCompleted, double? progress}) {
    return PathStage(
      id: id,
      title: title,
      description: description,
      xpReward: xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'isCompleted': isCompleted,
        'progress': progress,
      };

  static PathStage fromJson(Map<String, dynamic> json, PathStage template) {
    return template.copyWith(
      isCompleted: json['isCompleted'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SpiritualPath {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<PathStage> stages;
  final int currentStageIndex;
  final bool isActive;
  final bool isCompleted;

  const SpiritualPath({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.color = Colors.green,
    this.stages = const [],
    this.currentStageIndex = 0,
    this.isActive = false,
    this.isCompleted = false,
  });

  SpiritualPath copyWith({
    List<PathStage>? stages,
    int? currentStageIndex,
    bool? isActive,
    bool? isCompleted,
  }) {
    return SpiritualPath(
      id: id,
      title: title,
      description: description,
      icon: icon,
      color: color,
      stages: stages ?? this.stages,
      currentStageIndex: currentStageIndex ?? this.currentStageIndex,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  double get overallProgress {
    if (stages.isEmpty) return 0.0;
    final completed = stages.where((s) => s.isCompleted).length;
    return completed / stages.length;
  }
}

class UserStats {
  final int level;
  final int xp;
  final int xpToNextLevel;
  final Map<ActivityCategory, int> categoryCounts;
  final int streakDays;
  final List<String> badges;
  final int totalCompletedToday;
  final int dailyGoal;

  const UserStats({
    this.level = 1,
    this.xp = 0,
    this.xpToNextLevel = 100,
    this.categoryCounts = const {},
    this.streakDays = 0,
    this.badges = const [],
    this.totalCompletedToday = 0,
    this.dailyGoal = 5,
  });

  double get progressToNextLevel => xp / xpToNextLevel;

  UserStats copyWith({
    int? level,
    int? xp,
    int? xpToNextLevel,
    Map<ActivityCategory, int>? categoryCounts,
    int? streakDays,
    List<String>? badges,
    int? totalCompletedToday,
    int? dailyGoal,
  }) {
    return UserStats(
      level: level ?? this.level,
      xp: xp ?? this.xp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      streakDays: streakDays ?? this.streakDays,
      badges: badges ?? this.badges,
      totalCompletedToday: totalCompletedToday ?? this.totalCompletedToday,
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }
}
