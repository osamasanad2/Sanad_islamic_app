import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class IslamicEvent {
  final String title;
  final String description;
  final String details;
  final String hijriDate;
  final String gregorianDate;
  final String source;
  final String category;
  final int month;
  final int day;

  const IslamicEvent({
    required this.title,
    required this.description,
    required this.details,
    required this.hijriDate,
    required this.gregorianDate,
    required this.source,
    required this.category,
    required this.month,
    required this.day,
  });

  factory IslamicEvent.fromJson(Map<String, dynamic> json) {
    return IslamicEvent(
      title: json['title'] as String,
      description: json['description'] as String,
      details: json['details'] as String,
      hijriDate: json['hijriDate'] as String,
      gregorianDate: json['gregorianDate'] as String? ?? '',
      source: json['source'] as String,
      category: json['category'] as String,
      month: json['month'] as int,
      day: json['day'] as int,
    );
  }
}

List<IslamicEvent> _allEvents = [];

Future<void> loadIslamicEvents() async {
  if (_allEvents.isNotEmpty) return;
  final jsonString =
      await rootBundle.loadString('assets/data/islamic_events.json');
  final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
  _allEvents = jsonList
      .map((e) => IslamicEvent.fromJson(e as Map<String, dynamic>))
      .toList();
}

List<IslamicEvent> getEventsForDate(int month, int day) {
  return _allEvents
      .where((e) => e.month == month && e.day == day)
      .toList();
}

IslamicEvent? pickEventForDate(int month, int day) {
  final events = getEventsForDate(month, day);
  if (events.isEmpty) return null;
  final rng = Random(month * 100 + day);
  return events[rng.nextInt(events.length)];
}

final todayIslamicEventProvider = FutureProvider<IslamicEvent?>((ref) async {
  await loadIslamicEvents();

  final now = DateTime.now();
  final hijri = _toHijri(now);
  return pickEventForDate(hijri.$1, hijri.$2);
});

(int, int) _toHijri(DateTime date) {
  final jd = _gregorianToJulian(date.year, date.month, date.day);
  return _julianToHijri(jd);
}

int _gregorianToJulian(int year, int month, int day) {
  int y = year;
  int m = month;
  if (m <= 2) {
    y -= 1;
    m += 12;
  }
  final a = (y / 100).floor();
  final b = 2 - a + (a / 4).floor();
  return (365.25 * (y + 4716)).floor() +
      (30.6001 * (m + 1)).floor() +
      day +
      b -
      1524;
}

(int, int) _julianToHijri(int jd) {
  final y = (30 * (jd - 1948439) + 15) ~/ 354;
  final temp1 = 29 * (y - 1) ~/ 30;
  final dayOfYear = jd - (1948439 + temp1 * 354 + (3 * y - 1) ~/ 30);
  final m = (11 * dayOfYear + 3) ~/ 325;
  final d = dayOfYear - (30 * m + (m - 1) ~/ 2) + 1;
  return (m, d);
}
