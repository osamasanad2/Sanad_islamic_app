enum Currency {
  sar('SAR', 'ريال سعودي', '﷼'),
  usd('USD', 'دولار أمريكي', '\$'),
  eur('EUR', 'يورو', '€'),
  yer('YER', 'ريال يمني', '﷼'),
  egp('EGP', 'جنيه مصري', 'ج.م'),
  kwd('KWD', 'دينار كويتي', 'د.ك'),
  aed('AED', 'درهم إماراتي', 'د.إ');

  final String code;
  final String name;
  final String symbol;
  const Currency(this.code, this.name, this.symbol);
}

class ZakatInput {
  final String cashSavings;
  final String goldGrams;
  final String silverGrams;
  final String investments;
  final String businessAssets;
  final String receivables;
  final String debts;

  const ZakatInput({
    this.cashSavings = '',
    this.goldGrams = '',
    this.silverGrams = '',
    this.investments = '',
    this.businessAssets = '',
    this.receivables = '',
    this.debts = '',
  });

  ZakatInput copyWith({
    String? cashSavings,
    String? goldGrams,
    String? silverGrams,
    String? investments,
    String? businessAssets,
    String? receivables,
    String? debts,
  }) {
    return ZakatInput(
      cashSavings: cashSavings ?? this.cashSavings,
      goldGrams: goldGrams ?? this.goldGrams,
      silverGrams: silverGrams ?? this.silverGrams,
      investments: investments ?? this.investments,
      businessAssets: businessAssets ?? this.businessAssets,
      receivables: receivables ?? this.receivables,
      debts: debts ?? this.debts,
    );
  }

  Map<String, dynamic> toJson() => {
        'cashSavings': cashSavings,
        'goldGrams': goldGrams,
        'silverGrams': silverGrams,
        'investments': investments,
        'businessAssets': businessAssets,
        'receivables': receivables,
        'debts': debts,
      };

  factory ZakatInput.fromJson(Map<String, dynamic> json) => ZakatInput(
        cashSavings: json['cashSavings'] as String? ?? '',
        goldGrams: json['goldGrams'] as String? ?? '',
        silverGrams: json['silverGrams'] as String? ?? '',
        investments: json['investments'] as String? ?? '',
        businessAssets: json['businessAssets'] as String? ?? '',
        receivables: json['receivables'] as String? ?? '',
        debts: json['debts'] as String? ?? '',
      );
}

class ZakatResult {
  final double totalWealth;
  final double nisaab;
  final double goldPricePerGram;
  final double silverPricePerGram;
  final double zakatAmount;
  final bool meetsNisaab;
  final double cashSavingsValue;
  final double goldValue;
  final double silverValue;
  final double investmentsValue;
  final double businessAssetsValue;
  final double receivablesValue;
  final double debtsValue;
  final Currency currency;

  const ZakatResult({
    required this.totalWealth,
    required this.nisaab,
    required this.goldPricePerGram,
    required this.silverPricePerGram,
    required this.zakatAmount,
    required this.meetsNisaab,
    required this.cashSavingsValue,
    required this.goldValue,
    required this.silverValue,
    required this.investmentsValue,
    required this.businessAssetsValue,
    required this.receivablesValue,
    required this.debtsValue,
    required this.currency,
  });
}

class GoldPriceInfo {
  final double pricePerGram;
  final double pricePerOunce;
  final DateTime lastUpdated;
  final bool isFallback;

  const GoldPriceInfo({
    required this.pricePerGram,
    required this.pricePerOunce,
    required this.lastUpdated,
    this.isFallback = false,
  });
}
