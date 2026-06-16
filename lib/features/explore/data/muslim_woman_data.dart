import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WomanItem {
  final String type;
  final String? title;
  final String content;
  final String? text;
  final String source;
  final String? reference;

  const WomanItem({
    required this.type,
    this.title,
    required this.content,
    this.text,
    required this.source,
    this.reference,
  });

  factory WomanItem.fromJson(Map<String, dynamic> json) {
    return WomanItem(
      type: json['type'] as String,
      title: json['title'] as String?,
      content: json['content'] as String? ?? json['text'] as String,
      text: json['text'] as String?,
      source: json['source'] as String,
      reference: json['reference'] as String?,
    );
  }

  IconData get icon => type == 'ayah' ? Icons.menu_book : Icons.info_outline;

  String get displayText => text ?? content;
}

class WomanSection {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<WomanItem> items;

  const WomanSection({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  static IconData _parseIcon(String name) {
    switch (name) {
      case 'water_drop': return Icons.water_drop;
      case 'mosque': return Icons.mosque;
      case 'favorite': return Icons.favorite;
      case 'checkroom': return Icons.checkroom;
      case 'stars': return Icons.stars;
      case 'family_restroom': return Icons.family_restroom;
      default: return Icons.menu_book;
    }
  }

  static Color _parseColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xFF')));

  factory WomanSection.fromJson(Map<String, dynamic> json) {
    return WomanSection(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: _parseIcon(json['icon'] as String),
      color: _parseColor(json['color'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => WomanItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

List<WomanSection>? _cachedWoman;

Future<List<WomanSection>> loadWomanSections() async {
  if (_cachedWoman != null) return _cachedWoman!;
  final jsonString =
      await rootBundle.loadString('assets/data/muslim_woman.json');
  final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
  _cachedWoman = jsonList
      .map((e) => WomanSection.fromJson(e as Map<String, dynamic>))
      .toList();
  return _cachedWoman!;
}
