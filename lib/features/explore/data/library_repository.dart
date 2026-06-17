import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'book_model.dart';

class LibraryRepository {
  static const _cacheKey = 'cached_books';
  static const _cacheTimestampKey = 'cached_books_timestamp';
  static const _cacheDuration = Duration(hours: 24);

  List<Book> _books = [];
  List<Book> get books => List.unmodifiable(_books);

  List<String> get categories {
    final cats = _books.map((b) => b.category).toSet().toList();
    cats.sort((a, b) => a.compareTo(b));
    return cats;
  }

  List<Book> get featuredBooks => _books.where((b) => b.featured).toList();

  List<Book> getBooksByCategory(String category) =>
      _books.where((b) => b.category == category).toList();

  List<Book> search(String query) {
    if (query.trim().isEmpty) return _books;
    final q = query.trim().toLowerCase();
    return _books.where((b) {
      return b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q) ||
          b.description.toLowerCase().contains(q) ||
          b.category.toLowerCase().contains(q) ||
          b.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  Book? getBookById(String id) {
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJson = prefs.getString(_cacheKey);
    final cachedTime = prefs.getInt(_cacheTimestampKey) ?? 0;

    if (cachedJson != null &&
        DateTime.now().millisecondsSinceEpoch - cachedTime <
            _cacheDuration.inMilliseconds) {
      final decoded = json.decode(cachedJson) as List<dynamic>;
      _books = decoded.map((e) => Book.fromJson(e as Map<String, dynamic>)).toList();
      return;
    }

    final jsonString =
        await rootBundle.loadString('assets/data/books.json');
    final decoded = json.decode(jsonString) as List<dynamic>;
    _books = decoded.map((e) => Book.fromJson(e as Map<String, dynamic>)).toList();

    await prefs.setString(_cacheKey, jsonString);
    await prefs.setInt(
        _cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }
}
