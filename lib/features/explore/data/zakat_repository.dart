import 'zakat_models.dart';

class ZakatRepository {
  static const double nisaabGoldGrams = 85.0;
  static const double zakatRate = 0.025;

  ZakatResult calculate({
    required String cashSavings,
    required String goldGrams,
    required String silverGrams,
    required String investments,
    required String businessAssets,
    required String receivables,
    required String debts,
    required double goldPricePerGram,
    required Currency currency,
  }) {
    final cashSavingsVal = _parseAmount(cashSavings);
    final goldGramsVal = _parseAmount(goldGrams);
    final silverGramsVal = _parseAmount(silverGrams);
    final investmentsVal = _parseAmount(investments);
    final businessAssetsVal = _parseAmount(businessAssets);
    final receivablesVal = _parseAmount(receivables);
    final debtsVal = _parseAmount(debts);

    final goldValuePerGram = goldPricePerGram;

    final cashSavingsValue = cashSavingsVal;
    final goldValue = goldGramsVal * goldValuePerGram;
    final silverValue = silverGramsVal * 0.50;
    final investmentsValue = investmentsVal;
    final businessAssetsValue = businessAssetsVal;
    final receivablesValue = receivablesVal;
    final debtsValue = debtsVal;

    final grossWealth = cashSavingsValue +
        goldValue +
        silverValue +
        investmentsValue +
        businessAssetsValue +
        receivablesValue;

    final totalWealth = grossWealth - debtsValue;

    final nisaab = nisaabGoldGrams * goldValuePerGram;

    final meetsNisaab = totalWealth >= nisaab;

    final zakatAmount = meetsNisaab ? totalWealth * zakatRate : 0.0;

    return ZakatResult(
      totalWealth: totalWealth,
      nisaab: nisaab,
      goldPricePerGram: goldValuePerGram,
      silverPricePerGram: 0.50,
      zakatAmount: zakatAmount,
      meetsNisaab: meetsNisaab,
      cashSavingsValue: cashSavingsValue,
      goldValue: goldValue,
      silverValue: silverValue,
      investmentsValue: investmentsValue,
      businessAssetsValue: businessAssetsValue,
      receivablesValue: receivablesValue,
      debtsValue: debtsValue,
      currency: currency,
    );
  }

  double _parseAmount(String value) {
    if (value.trim().isEmpty) return 0.0;
    final cleaned = value.replaceAll(',', '').trim();
    final parsed = double.tryParse(cleaned);
    return parsed ?? 0.0;
  }
}
