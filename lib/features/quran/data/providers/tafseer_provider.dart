import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';
import 'package:flutter/foundation.dart';

// Parses the XML in a background isolate
Map<int, Map<int, String>> _parseTafseer(String xmlString) {
  final document = XmlDocument.parse(xmlString);
  final suras = document.findAllElements('sura');
  final Map<int, Map<int, String>> tafseerMap = {};

  for (var sura in suras) {
    final suraIndex = int.parse(sura.getAttribute('index') ?? '0');
    final ayas = sura.findElements('aya');
    
    tafseerMap[suraIndex] = {};
    for (var aya in ayas) {
      final ayaIndex = int.parse(aya.getAttribute('index') ?? '0');
      final text = aya.getAttribute('text') ?? '';
      tafseerMap[suraIndex]![ayaIndex] = text;
    }
  }
  return tafseerMap;
}

// Provider that loads and parses the Tafseer Al-Muyassar
final tafseerProvider = FutureProvider<Map<int, Map<int, String>>>((ref) async {
  final xmlString = await rootBundle.loadString('assets/data/almuyassar.xml');
  return compute(_parseTafseer, xmlString);
});
