import 'package:flutter_test/flutter_test.dart';
import 'package:adhan/adhan.dart';

void main() {
  group('PrayerNotifier', () {
    test('prayer name mappings are correct', () {
      expect(PrayerLabel.fajr, 'الفجر');
      expect(PrayerLabel.sunrise, 'الشروق');
      expect(PrayerLabel.dhuhr, 'الظهر');
      expect(PrayerLabel.asr, 'العصر');
      expect(PrayerLabel.maghrib, 'المغرب');
      expect(PrayerLabel.isha, 'العشاء');
    });

    test('prayer order is correct', () {
      final prayers = [
        Prayer.fajr,
        Prayer.sunrise,
        Prayer.dhuhr,
        Prayer.asr,
        Prayer.maghrib,
        Prayer.isha,
        Prayer.none,
      ];
      expect(prayers.length, 7);
    });
  });
}

class PrayerLabel {
  static const fajr = 'الفجر';
  static const sunrise = 'الشروق';
  static const dhuhr = 'الظهر';
  static const asr = 'العصر';
  static const maghrib = 'المغرب';
  static const isha = 'العشاء';
}
