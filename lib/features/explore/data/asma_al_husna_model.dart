import 'package:flutter/material.dart';

class AsmaAlHusnaName {
  final int id;
  final String name;
  final String transliteration;
  final String meaning;
  final String explanation;
  final String impact;
  final String? evidence;

  const AsmaAlHusnaName({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.meaning,
    required this.explanation,
    required this.impact,
    this.evidence,
  });

  factory AsmaAlHusnaName.fromJson(Map<String, dynamic> json) {
    return AsmaAlHusnaName(
      id: json['id'] as int,
      name: json['name'] as String,
      transliteration: json['transliteration'] as String,
      meaning: json['meaning'] as String,
      explanation: json['explanation'] as String,
      impact: json['impact'] as String,
      evidence: json['evidence'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'transliteration': transliteration,
        'meaning': meaning,
        'explanation': explanation,
        'impact': impact,
        'evidence': evidence,
      };

  IconData get icon => Icons.auto_awesome;
}
