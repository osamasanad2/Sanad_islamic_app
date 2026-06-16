import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SeerahScreen extends StatelessWidget {
  const SeerahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: Text(
          'السيرة النبوية',
          style: TextStyle(color: context.appColors.textPrimary),
        ),
        backgroundColor: context.appColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.appColors.textPrimary),
      ),
      body: const Center(child: Text('جاري بناء المكتبة...')),
    );
  }
}
