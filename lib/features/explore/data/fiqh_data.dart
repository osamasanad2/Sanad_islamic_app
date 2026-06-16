import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FiqhItem {
  final String type;
  final String title;
  final String content;
  final String? text;
  final String source;
  final String? reference;

  const FiqhItem({
    required this.type,
    required this.title,
    required this.content,
    this.text,
    required this.source,
    this.reference,
  });

  factory FiqhItem.fromJson(Map<String, dynamic> json) {
    return FiqhItem(
      type: json['type'] as String,
      title: (json['title'] ?? json['source'] ?? '') as String,
      content: (json['content'] ?? json['text'] ?? '') as String,
      text: json['text'] as String?,
      source: json['source'] as String,
      reference: json['reference'] as String?,
    );
  }

  IconData get icon => type == 'ayah' ? Icons.menu_book : Icons.info_outline;

  String get displayText => text ?? content;
}

class FiqhSection {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<FiqhItem> items;

  const FiqhSection({
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
      case 'volunteer_activism': return Icons.volunteer_activism;
      case 'nights_stay': return Icons.nights_stay;
      case 'airplanemode_active': return Icons.airplanemode_active;
      default: return Icons.menu_book;
    }
  }

  static Color _parseColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xFF')));

  factory FiqhSection.fromJson(Map<String, dynamic> json) {
    return FiqhSection(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: _parseIcon(json['icon'] as String),
      color: _parseColor(json['color'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => FiqhItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

List<FiqhSection>? _cachedFiqh;

Future<List<FiqhSection>> loadFiqhSections() async {
  if (_cachedFiqh != null) return _cachedFiqh!;
  final jsonString =
      await rootBundle.loadString('assets/data/fiqh_data.json');
  final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
  _cachedFiqh = jsonList
      .map((e) => FiqhSection.fromJson(e as Map<String, dynamic>))
      .toList();
  return _cachedFiqh!;
}
