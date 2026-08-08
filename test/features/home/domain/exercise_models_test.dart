import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domain modelleri Flutter widgetlarına bağımlı değil', () {
    const List<String> domainFiles = <String>[
      'lib/features/home/domain/exercise_category.dart',
      'lib/features/home/domain/exercise_definition.dart',
      'lib/features/home/domain/exercise_difficulty.dart',
      'lib/features/home/domain/exercise_mode.dart',
      'lib/features/home/domain/exercise_requirement.dart',
    ];

    for (final String path in domainFiles) {
      final String content = File(path).readAsStringSync();

      expect(content.contains('package:flutter'), isFalse, reason: path);
      expect(content.contains('dart:ui'), isFalse, reason: path);
    }
  });

  test(
    'exercise definition does not store localized titles or descriptions',
    () {
      final String content = File(
        'lib/features/home/domain/exercise_definition.dart',
      ).readAsStringSync();

      expect(content.contains('final String title;'), isFalse);
      expect(content.contains('final String description;'), isFalse);
    },
  );
}
