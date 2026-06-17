class HisnZikr {
  final String text;

  HisnZikr({required this.text});
}

class HisnCategory {
  final String name;
  final List<HisnZikr> azkar;
  final List<String> footnotes;

  HisnCategory({
    required this.name,
    required this.azkar,
    required this.footnotes,
  });

  factory HisnCategory.fromJson(String name, Map<String, dynamic> json) {
    final List<dynamic> textList = json['text'] ?? [];
    final List<dynamic> footnoteList = json['footnote'] ?? [];

    return HisnCategory(
      name: name,
      azkar: textList.map((text) => HisnZikr(text: text.toString())).toList(),
      footnotes: footnoteList.map((f) => f.toString()).toList(),
    );
  }
}
