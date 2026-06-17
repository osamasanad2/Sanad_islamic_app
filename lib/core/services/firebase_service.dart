import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  bool _initialized = false;
  FirebaseAnalytics? _analytics;
  FirebaseCrashlytics? _crashlytics;

  bool get isInitialized => _initialized;
  FirebaseAnalytics? get analytics => _analytics;
  FirebaseCrashlytics? get crashlytics => _crashlytics;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp(
        options: kIsWeb
            ? null
            : null,
      );
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;

      await _crashlytics!.setCrashlyticsCollectionEnabled(true);

      FlutterError.onError = (errorDetails) {
        _crashlytics?.recordFlutterFatalError(errorDetails);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics?.recordError(error, stack, fatal: true);
        return true;
      };

      _initialized = true;
    } catch (e) {
      _initialized = false;
    }
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (!_initialized || _analytics == null) return;
    if (parameters != null) {
      await _analytics!.logEvent(name: name, parameters: parameters);
    } else {
      await _analytics!.logEvent(name: name);
    }
  }
}

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});
