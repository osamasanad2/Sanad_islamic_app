import os

f1 = r'c:\Users\MC\StudioProjects\sanad_app\lib\core\services\audio_service.dart'
with open(f1, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace('print(', 'debugPrint(')
if 'package:flutter/foundation.dart' not in content:
    content = content.replace('import \'package:flutter_riverpod/flutter_riverpod.dart\';', 'import \'package:flutter_riverpod/flutter_riverpod.dart\';\nimport \'package:flutter/foundation.dart\';')
with open(f1, 'w', encoding='utf-8') as f:
    f.write(content)

f2 = r'c:\Users\MC\StudioProjects\sanad_app\lib\features\explore\presentation\screens\explore_screen.dart'
with open(f2, 'r', encoding='utf-8') as f:
    content2 = f.read()
content2 = content2.replace('\\${', '${')
content2 = content2.replace('\\$ayahId', '$ayahId')
with open(f2, 'w', encoding='utf-8') as f:
    f.write(content2)
