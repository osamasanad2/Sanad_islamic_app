import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/shared_prefs_provider.dart';

enum PremiumFeature {
  noAds,
  advancedQuran,
  multipleReciters,
  themes,
  offlineMode,
  aiAccess,
}

class PremiumProductIds {
  static const monthlyAndroid = 'com.sanad.premium.monthly';
  static const annualAndroid = 'com.sanad.premium.annual';
  static const monthlyIOS = 'com.sanad.premium.monthly';
  static const annualIOS = 'com.sanad.premium.annual';

  static List<String> get all => [monthlyAndroid, annualAndroid];
}

class PremiumService {
  static const String _premiumKey = 'premium_active';

  final InAppPurchase _inAppPurchase;
  final SharedPreferences _prefs;
  bool _isPremium = false;
  List<ProductDetails> _products = [];
  bool _isInitialized = false;

  PremiumService(this._prefs) : _inAppPurchase = InAppPurchase.instance;

  bool get isPremium => _isPremium;
  List<ProductDetails> get products => _products;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    _isPremium = _prefs.getBool(_premiumKey) ?? false;
    final available = await _inAppPurchase.isAvailable();
    if (available) {
      final response = await _inAppPurchase.queryProductDetails(PremiumProductIds.all.toSet());
      if (response.error == null) {
        _products = response.productDetails;
      }
    }
    _isInitialized = true;
  }

  Future<bool> purchaseSubscription(String productId) async {
    try {
      final details = _products.firstWhere((p) => p.id == productId);
      final purchaseParam = PurchaseParam(productDetails: details);
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      return true;
    } catch (_) {
      return false;
    }
  }

  bool hasFeature(PremiumFeature feature) {
    return _isPremium;
  }

  Future<List<ProductDetails>> getProducts() async {
    if (_products.isNotEmpty) return _products;
    final available = await _inAppPurchase.isAvailable();
    if (available) {
      final response = await _inAppPurchase.queryProductDetails(PremiumProductIds.all.toSet());
      if (response.error == null) {
        _products = response.productDetails;
      }
    }
    return _products;
  }

  void setPremium(bool value) {
    _isPremium = value;
    _prefs.setBool(_premiumKey, value);
  }

  Stream<List<PurchaseDetails>> get purchaseUpdates => _inAppPurchase.purchaseStream;

  void completePurchase(PurchaseDetails purchase) {
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      setPremium(true);
    }
    if (purchase.pendingCompletePurchase) {
      _inAppPurchase.completePurchase(purchase);
    }
  }
}

class PremiumServiceNotifier extends Notifier<PremiumService> {
  @override
  PremiumService build() {
    final prefs = ref.read(sharedPrefsProvider);
    final service = PremiumService(prefs);
    service.initialize();
    return service;
  }
}

final premiumServiceProvider =
    NotifierProvider<PremiumServiceNotifier, PremiumService>(
  PremiumServiceNotifier.new,
);
