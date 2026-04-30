import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PrayerTimeItem extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final bool isActive;

  const PrayerTimeItem({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isActive ? Colors.white : AppColors.textPrimary;
    final iconColor = isActive ? Colors.white : AppColors.textPrimary;
    final timeColor = isActive ? Colors.white70 : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28.0,
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            time,
            style: TextStyle(
              color: timeColor,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
