import 'package:flutter/material.dart';

import '../../home/domain/exercise_category.dart';
import '../../home/presentation/category_screen.dart';

class NoteReadingHomeScreen extends StatelessWidget {
  const NoteReadingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryScreen(category: ExerciseCategory.readAndPerform);
  }
}
