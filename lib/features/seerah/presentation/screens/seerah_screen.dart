import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SeerahScreen extends StatelessWidget {
  const SeerahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('السيرة النبوية', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: const Center(
        child: Text('جاري بناء المكتبة...'),
      ),
    );
  }
}
