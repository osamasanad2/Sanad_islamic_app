import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TajweedExample {
  final String text;
  final String highlight;

  const TajweedExample({
    required this.text,
    required this.highlight,
  });

  factory TajweedExample.fromJson(Map<String, dynamic> json) {
    return TajweedExample(
      text: json['text'] as String,
      highlight: json['highlight'] as String,
    );
  }
}

class TajweedLesson {
  final String id;
  final String title;
  final String definition;
  final String letters;
  final String lettersDisplay;
  final String rule;
  final List<TajweedExample> examples;
  final String notes;

  const TajweedLesson({
    required this.id,
    required this.title,
    required this.definition,
    required this.letters,
    required this.lettersDisplay,
    required this.rule,
    required this.examples,
    required this.notes,
  });

  factory TajweedLesson.fromJson(Map<String, dynamic> json) {
    return TajweedLesson(
      id: json['id'] as String,
      title: json['title'] as String,
      definition: json['definition'] as String,
      letters: json['letters'] as String,
      lettersDisplay: json['lettersDisplay'] as String,
      rule: json['rule'] as String,
      examples: (json['examples'] as List<dynamic>)
          .map((e) => TajweedExample.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String,
    );
  }
}

class TajweedCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<TajweedLesson> lessons;

  const TajweedCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.lessons,
  });

  static IconData _parseIcon(String name) {
    switch (name) {
      case 'text_fields': return Icons.text_fields;
      case 'horizontal_rule': return Icons.horizontal_rule;
      case 'mic': return Icons.mic;
      case 'palette': return Icons.palette;
      case 'format_bold': return Icons.format_bold;
      case 'stop_circle': return Icons.stop_circle;
      case 'link': return Icons.link;
      default: return Icons.menu_book;
    }
  }

  static Color _parseColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xFF')));

  factory TajweedCategory.fromJson(Map<String, dynamic> json) {
    return TajweedCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: _parseIcon(json['icon'] as String),
      color: _parseColor(json['color'] as String),
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => TajweedLesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

List<TajweedCategory>? _cachedTajweed;

Future<List<TajweedCategory>> loadTajweedCategories() async {
  if (_cachedTajweed != null) return _cachedTajweed!;
  final jsonString =
      await rootBundle.loadString('assets/data/tajweed_data.json');
  final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
  _cachedTajweed = jsonList
      .map((e) => TajweedCategory.fromJson(e as Map<String, dynamic>))
      .toList();
  return _cachedTajweed!;
}
