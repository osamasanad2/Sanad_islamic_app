import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RuqyahItem {
  final String type;
  final String text;
  final String source;
  final String reference;

  const RuqyahItem({
    required this.type,
    required this.text,
    required this.source,
    required this.reference,
  });

  factory RuqyahItem.fromJson(Map<String, dynamic> json) {
    return RuqyahItem(
      type: json['type'] as String,
      text: json['text'] as String,
      source: json['source'] as String,
      reference: json['reference'] as String,
    );
  }

  IconData get icon =>
      type == 'ayah' ? Icons.menu_book : Icons.pan_tool;
}

class RuqyahCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<RuqyahItem> items;

  const RuqyahCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  static IconData _parseIcon(String iconName) {
    switch (iconName) {
      case 'healing':
        return Icons.healing_rounded;
      case 'visibility':
        return Icons.remove_red_eye;
      case 'auto_fix_high':
        return Icons.auto_fix_high;
      case 'shield':
        return Icons.shield_rounded;
      case 'lock':
        return Icons.lock_rounded;
      default:
        return Icons.healing_rounded;
    }
  }

  static Color _parseColor(String hex) {
    final c = int.parse(hex.replaceFirst('#', '0xFF'));
    return Color(c);
  }

  factory RuqyahCategory.fromJson(Map<String, dynamic> json) {
    return RuqyahCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: _parseIcon(json['icon'] as String),
      color: _parseColor(json['color'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => RuqyahItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

List<RuqyahCategory>? _cachedCategories;

Future<List<RuqyahCategory>> loadRuqyahCategories() async {
  if (_cachedCategories != null) return _cachedCategories!;
  final jsonString =
      await rootBundle.loadString('assets/data/ruqyah_data.json');
  final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
  _cachedCategories = jsonList
      .map((e) => RuqyahCategory.fromJson(e as Map<String, dynamic>))
      .toList();
  return _cachedCategories!;
}
