import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'zakat_models.dart';
import 'gold_price_service.dart';
import 'zakat_repository.dart';

final goldPriceServiceProvider = Provider<GoldPriceService>((ref) => GoldPriceService());

final zakatRepositoryProvider = Provider<ZakatRepository>((ref) => ZakatRepository());

final zakatProvider = NotifierProvider<ZakatNotifier, ZakatState>(ZakatNotifier.new);

class ZakatState {
  final String cashSavings;
  final String goldGrams;
  final String silverGrams;
  final String investments;
  final String businessAssets;
  final String receivables;
  final String debts;
  final Currency currency;
  final GoldPriceInfo? goldPrice;
  final ZakatResult? result;
  final bool isLoadingPrice;
  final String? priceError;
  final bool showBreakdown;

  const ZakatState({
    this.cashSavings = '',
    this.goldGrams = '',
    this.silverGrams = '',
    this.investments = '',
    this.businessAssets = '',
    this.receivables = '',
    this.debts = '',
    this.currency = Currency.sar,
    this.goldPrice,
    this.result,
    this.isLoadingPrice = false,
    this.priceError,
    this.showBreakdown = false,
  });

  ZakatState copyWith({
    String? cashSavings,
    String? goldGrams,
    String? silverGrams,
    String? investments,
    String? businessAssets,
    String? receivables,
    String? debts,
    Currency? currency,
    GoldPriceInfo? goldPrice,
    ZakatResult? result,
    bool? isLoadingPrice,
    String? priceError,
    bool? showBreakdown,
  }) {
    return ZakatState(
      cashSavings: cashSavings ?? this.cashSavings,
      goldGrams: goldGrams ?? this.goldGrams,
      silverGrams: silverGrams ?? this.silverGrams,
      investments: investments ?? this.investments,
      businessAssets: businessAssets ?? this.businessAssets,
      receivables: receivables ?? this.receivables,
      debts: debts ?? this.debts,
      currency: currency ?? this.currency,
      goldPrice: goldPrice ?? this.goldPrice,
      result: result ?? this.result,
      isLoadingPrice: isLoadingPrice ?? this.isLoadingPrice,
      priceError: priceError ?? this.priceError,
      showBreakdown: showBreakdown ?? this.showBreakdown,
    );
  }
}

class ZakatNotifier extends Notifier<ZakatState> {
  @override
  ZakatState build() {
    Future.microtask(() {
      _loadSavedInput();
      _fetchGoldPrice();
    });
    return ZakatState();
  }

  Future<void> _loadSavedInput() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('zakat_last_input');
      final savedCurrency = prefs.getString('zakat_currency') ?? 'SAR';
      if (saved != null) {
        final json = jsonDecode(saved);
        state = state.copyWith(
          cashSavings: (json['cashSavings'] as String?) ?? '',
          goldGrams: (json['goldGrams'] as String?) ?? '',
          silverGrams: (json['silverGrams'] as String?) ?? '',
          investments: (json['investments'] as String?) ?? '',
          businessAssets: (json['businessAssets'] as String?) ?? '',
          receivables: (json['receivables'] as String?) ?? '',
          debts: (json['debts'] as String?) ?? '',
          currency: _parseCurrency(savedCurrency),
        );
      }
    } catch (_) {}
  }

  Future<void> _fetchGoldPrice() async {
    try {
      state = state.copyWith(isLoadingPrice: true, priceError: null);
      final service = ref.read(goldPriceServiceProvider);
      final price = await service.fetchGoldPrice();
      state = state.copyWith(goldPrice: price, isLoadingPrice: false);
    } catch (e) {
      state = state.copyWith(
        isLoadingPrice: false,
        priceError: 'فشل جلب سعر الذهب',
      );
    }
  }

  void updateField(String field, String value) {
    Map<String, String> updates = {};
    updates[field] = value;
    state = state.copyWith(
      cashSavings: field == 'cashSavings' ? value : null,
      goldGrams: field == 'goldGrams' ? value : null,
      silverGrams: field == 'silverGrams' ? value : null,
      investments: field == 'investments' ? value : null,
      businessAssets: field == 'businessAssets' ? value : null,
      receivables: field == 'receivables' ? value : null,
      debts: field == 'debts' ? value : null,
      result: null,
    );
    _saveInput();
  }

  void setCurrency(Currency currency) {
    state = state.copyWith(currency: currency, result: null);
    _saveInput();
  }

  void calculate() {
    final goldPrice = state.goldPrice;
    if (goldPrice == null) return;

    final goldPerGramInCurrency =
        GoldPriceService.convertToCurrency(goldPrice.pricePerGram, state.currency);

    final repo = ref.read(zakatRepositoryProvider);
    final result = repo.calculate(
      cashSavings: state.cashSavings,
      goldGrams: state.goldGrams,
      silverGrams: state.silverGrams,
      investments: state.investments,
      businessAssets: state.businessAssets,
      receivables: state.receivables,
      debts: state.debts,
      goldPricePerGram: goldPerGramInCurrency,
      currency: state.currency,
    );
    state = state.copyWith(result: result, showBreakdown: false);
  }

  void toggleBreakdown() {
    state = state.copyWith(showBreakdown: !state.showBreakdown);
  }

  void resetAll() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('zakat_last_input');
      prefs.remove('zakat_currency');
    });
    state = ZakatState();
    _fetchGoldPrice().ignore();
  }

  void refreshPrice() {
    _fetchGoldPrice().ignore();
  }

  Currency _parseCurrency(String code) {
    for (final c in Currency.values) {
      if (c.code == code) return c;
    }
    return Currency.sar;
  }

  void _saveInput() {
    SharedPreferences.getInstance().then((prefs) {
      final data = {
        'cashSavings': state.cashSavings,
        'goldGrams': state.goldGrams,
        'silverGrams': state.silverGrams,
        'investments': state.investments,
        'businessAssets': state.businessAssets,
        'receivables': state.receivables,
        'debts': state.debts,
      };
      prefs.setString('zakat_last_input', jsonEncode(data));
      prefs.setString('zakat_currency', state.currency.code);
    });
  }
}
