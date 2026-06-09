import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _qiblaDirection;
  String _status = 'جاري تحديد الموقع...';

  @override
  void initState() {
    super.initState();
    _calculateQibla();
  }

  Future<void> _calculateQibla() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _status = 'خدمات الموقع غير مفعلة');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _status = 'تم رفض صلاحية الموقع');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      double bearing = _calculateBearing(
        position.latitude,
        position.longitude,
        21.4225,
        39.8262,
      );

      setState(() {
        _qiblaDirection = bearing;
        _status = 'تم تحديد اتجاه القبلة';
      });
    } catch (e) {
      setState(() => _status = 'خطأ في تحديد الاتجاه');
    }
  }

  double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    final lat1Rad = lat1 * math.pi / 180;
    final lat2Rad = lat2 * math.pi / 180;
    final lonDiffRad = (lon2 - lon1) * math.pi / 180;

    final y = math.sin(lonDiffRad) * math.cos(lat2Rad);
    final x = math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(lonDiffRad);

    final bearingRad = math.atan2(y, x);
    return (bearingRad * 180 / math.pi + 360) % 360;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('اتجاه القبلة'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: _qiblaDirection != null
                  ? Transform.rotate(
                      angle: (_qiblaDirection! * math.pi / 180),
                      child: const Icon(
                        Icons.near_me_rounded,
                        color: AppColors.primary,
                        size: 120,
                      ),
                    )
                  : const Icon(
                      Icons.explore_rounded,
                      color: AppColors.textSecondary,
                      size: 100,
                    ),
            ),
            const SizedBox(height: 30),
            Text(
              _status,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            if (_qiblaDirection != null)
              Text(
                'الاتجاه: ${_qiblaDirection!.toStringAsFixed(1)}°',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: const Text(
                'قم بتوجيه الهاتف باتجاه القبلة الموضح.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
