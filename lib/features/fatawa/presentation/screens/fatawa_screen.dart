import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FatawaScreen extends StatelessWidget {
  const FatawaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'الفتاوى',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: const Center(child: Text('جاري بناء المكتبة...')),
    );
  }
}
