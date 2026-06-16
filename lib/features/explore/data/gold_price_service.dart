import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'zakat_models.dart';

class GoldPriceService {
  static const _cacheKey = 'gold_price_per_gram_usd';
  static const _cacheTimestampKey = 'gold_price_timestamp';
  static const _fallbackPricePerOunce = 2600.0;
  static const _troyOunceInGrams = 31.1035;

  Future<GoldPriceInfo> fetchGoldPrice() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedPrice = prefs.getDouble(_cacheKey);
    final cachedTime = prefs.getInt(_cacheTimestampKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    final cacheDuration = Duration(minutes: 30);

    try {
      final response = await http
          .get(Uri.parse('https://api.metals.live/v1/spot/gold'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        double pricePerOunce;
        if (data is List && data.isNotEmpty) {
          pricePerOunce =
              (data[0]['price'] as num?)?.toDouble() ?? _fallbackPricePerOunce;
        } else if (data is Map && data.containsKey('price')) {
          pricePerOunce = (data['price'] as num).toDouble();
        } else {
          throw Exception('Unexpected API format');
        }

        final pricePerGram = pricePerOunce / _troyOunceInGrams;

        await prefs.setDouble(_cacheKey, pricePerGram);
        await prefs.setInt(_cacheTimestampKey, now);

        return GoldPriceInfo(
          pricePerGram: pricePerGram,
          pricePerOunce: pricePerOunce,
          lastUpdated: DateTime.now(),
          isFallback: false,
        );
      }
      throw Exception('API returned ${response.statusCode}');
    } catch (_) {
      if (cachedPrice != null &&
          now - cachedTime < cacheDuration.inMilliseconds) {
        return GoldPriceInfo(
          pricePerGram: cachedPrice,
          pricePerOunce: cachedPrice * _troyOunceInGrams,
          lastUpdated: DateTime.fromMillisecondsSinceEpoch(cachedTime),
          isFallback: false,
        );
      }

      final fallbackPerGram = _fallbackPricePerOunce / _troyOunceInGrams;
      return GoldPriceInfo(
        pricePerGram: fallbackPerGram,
        pricePerOunce: _fallbackPricePerOunce,
        lastUpdated: DateTime.now(),
        isFallback: true,
      );
    }
  }

  static double convertToCurrency(
      double pricePerGramUSD, Currency currency) {
    const rates = <Currency, double>{
      Currency.usd: 1.0,
      Currency.sar: 3.75,
      Currency.aed: 3.67,
      Currency.kwd: 0.31,
      Currency.egp: 48.5,
      Currency.yer: 250.0,
      Currency.eur: 0.92,
    };

    return pricePerGramUSD * (rates[currency] ?? 1.0);
  }
}
