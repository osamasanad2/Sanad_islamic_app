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
      width: 78.0, // Slightly wider for better text fit
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(20.0), // softer corners
        border: Border.all(
          color: isActive
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: [
          if (isActive) // Glow effect for active item
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              offset: const Offset(0, 6),
              blurRadius: 16.0,
              spreadRadius: 2.0,
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 4),
              blurRadius: 8.0,
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
              fontWeight: FontWeight.w800, // bolder
              fontSize: 15.0, // slightly larger
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            time,
            style: TextStyle(
              color: timeColor,
              fontWeight: FontWeight.w600,
              fontSize: 13.0, // slightly larger
            ),
          ),
        ],
      ),
    );
  }
}
