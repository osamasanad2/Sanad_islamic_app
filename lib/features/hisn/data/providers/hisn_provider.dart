import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/hisn_model.dart';

final hisnProvider = FutureProvider<List<HisnCategory>>((ref) async {
  final jsonString = await rootBundle.loadString(
    'assets/data/hisn_almuslim_utf8.json',
  );
  final Map<String, dynamic> jsonMap = json.decode(jsonString);

  final List<HisnCategory> categories = [];
  jsonMap.forEach((key, value) {
    categories.add(HisnCategory.fromJson(key, value as Map<String, dynamic>));
  });

  return categories;
});
