import 'package:conservatory_trainer/features/home/application/exercise_catalog.dart';
import 'package:conservatory_trainer/features/home/domain/exercise_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ExerciseCatalog catalog = ExerciseCatalog();

  test('egzersiz kataloğu bütün kategorileri içeriyor', () {
    expect(catalog.categories, ExerciseCategory.values);
    expect(
      catalog.groupedByCategory.keys.toList(growable: false),
      ExerciseCategory.values,
    );
  });

  test('tek ses tekrarı aktif olarak tanımlı', () {
    expect(
      catalog.findById(ExerciseCatalogIds.singleNoteRepeat)?.isAvailable,
      isTrue,
    );
  });

  test('geliştirilmemiş egzersiz yakında olarak tanımlı', () {
    expect(
      catalog.findById(ExerciseCatalogIds.doubleNoteSeparation)?.isAvailable,
      isFalse,
    );
  });
}
