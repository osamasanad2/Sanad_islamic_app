import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import '../models/quran_models.dart';

class TafsirRepository {
  Map<String, List<TafsirEntry>>? _tafsirCache;

  Future<Map<String, List<TafsirEntry>>> loadAllTafsir() async {
    if (_tafsirCache != null) return _tafsirCache!;

    _tafsirCache = {
      'aljalalayn': await _parseTafsirXml('assets/data/aljalalayn.xml'),
      'almuyassar': await _parseTafsirXml('assets/data/almuyassar.xml'),
    };
    return _tafsirCache!;
  } 

  Future<List<TafsirEntry>> _parseTafsirXml(String path) async {
    final xmlString = await rootBundle.loadString(path);
    final document = XmlDocument.parse(xmlString);
    final entries = <TafsirEntry>[];

    for (final sura in document.findAllElements('sura')) {
      final suraIndex = int.parse(sura.getAttribute('index')!);
      for (final aya in sura.findAllElements('aya')) {
        final ayaIndex = int.parse(aya.getAttribute('index')!);
        final text = aya.getAttribute('text')!;
        entries.add(TafsirEntry(surah: suraIndex, ayah: ayaIndex, text: text));
      }
    }
    return entries;
  }

  Future<String?> getTafsir(int surah, int ayah, String tafsirName) async {
    final all = await loadAllTafsir();
    final list = all[tafsirName];
    if (list == null) return null;
    try {
      return list.firstWhere((e) => e.surah == surah && e.ayah == ayah).text;
    } catch (_) {
      return null;
    }
  }

  void clearCache() {
    _tafsirCache = null;
  }
}
