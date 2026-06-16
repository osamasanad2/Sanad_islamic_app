import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final String description;
  final String coverImage;
  final int chaptersCount;
  final int pagesCount;
  final String language;
  final List<String> tags;
  final String source;
  final bool featured;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.coverImage,
    required this.chaptersCount,
    required this.pagesCount,
    required this.language,
    required this.tags,
    required this.source,
    required this.featured,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      coverImage: json['coverImage'] as String? ?? '',
      chaptersCount: json['chaptersCount'] as int? ?? 0,
      pagesCount: json['pagesCount'] as int? ?? 0,
      language: json['language'] as String? ?? 'ar',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      source: json['source'] as String? ?? '',
      featured: json['featured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'category': category,
        'description': description,
        'coverImage': coverImage,
        'chaptersCount': chaptersCount,
        'pagesCount': pagesCount,
        'language': language,
        'tags': tags,
        'source': source,
        'featured': featured,
      };

  IconData get categoryIcon {
    switch (category) {
      case 'القرآن وعلومه':
        return Icons.menu_book;
      case 'التفسير':
        return Icons.explore;
      case 'الحديث':
        return Icons.format_quote;
      case 'الفقه':
        return Icons.balance;
      case 'العقيدة':
        return Icons.shield;
      case 'السيرة والشمائل':
        return Icons.history_edu;
      case 'الرقائق والتزكية':
        return Icons.favorite;
      default:
        return Icons.library_books;
    }
  }

  Color get categoryColor {
    switch (category) {
      case 'القرآن وعلومه':
        return const Color(0xFFD4AF37);
      case 'التفسير':
        return const Color(0xFF4CAF50);
      case 'الحديث':
        return const Color(0xFF2196F3);
      case 'الفقه':
        return const Color(0xFFFF9800);
      case 'العقيدة':
        return const Color(0xFF9C27B0);
      case 'السيرة والشمائل':
        return const Color(0xFF795548);
      case 'الرقائق والتزكية':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF607D8B);
    }
  }
}
