import 'package:flutter/services.dart';

class QuranNativeService {
  static const _channel = MethodChannel('com.example.sanad_app/quran');

  static Future<void> openQuran() async {
    try {
      await _channel.invokeMethod('openQuran');
    } on MissingPluginException {
      // Fallback for non-Android platforms
    }
  }

  static Future<void> openReading({
    String surahId = '1',
    String? ayahId,
  }) async {
    try {
      await _channel.invokeMethod('openReading', {
        'surah_id': surahId,
        'ayah_id': ayahId,
      });
    } on MissingPluginException {
      // Fallback
    }
  }

  static Future<void> openSearch() async {
    try {
      await _channel.invokeMethod('openSearch');
    } on MissingPluginException {
      // Fallback
    }
  }

  static Future<void> openBookmarks() async {
    try {
      await _channel.invokeMethod('openBookmarks');
    } on MissingPluginException {
      // Fallback
    }
  }

  static Future<void> openStats() async {
    try {
      await _channel.invokeMethod('openStats');
    } on MissingPluginException {
      // Fallback
    }
  }
}
