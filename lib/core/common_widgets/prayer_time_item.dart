import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PrayerTimeItem extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final bool isActive;
  final String? date;

  const PrayerTimeItem({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    this.isActive = false,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isActive ? Colors.white : AppColors.textPrimary;
    final iconColor = isActive ? Colors.white : AppColors.textPrimary;
    final timeColor = isActive ? Colors.white70 : AppColors.textSecondary;

    return Container(
      width: 75.0, // Fixed width for horizontal scrolling
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive ? AppColors.primary.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (date != null) ...[
            Text(
              date!,
              style: TextStyle(
                color: timeColor,
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
          ],
          Icon(
            icon,
            color: iconColor,
            size: 24.0, // Smaller icon
          ),
          const SizedBox(height: 6.0),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.0, // Smaller title
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            time,
            style: TextStyle(
              color: timeColor,
              fontSize: 12.0, // Smaller time
            ),
          ),
        ],
      ),
    );
  }
}
