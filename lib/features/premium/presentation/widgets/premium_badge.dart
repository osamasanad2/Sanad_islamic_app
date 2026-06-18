import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PremiumBadge extends StatelessWidget {
  final double size;
  final bool showLabel;

  const PremiumBadge({super.key, this.size = 24, this.showLabel = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gold, Color(0xFFFFD700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 14,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 4),
          Text(
            'برو',
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
        ],
      ],
    );
  }
}
