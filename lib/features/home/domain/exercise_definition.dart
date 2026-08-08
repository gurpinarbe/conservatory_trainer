import 'exercise_category.dart';
import 'exercise_difficulty.dart';
import 'exercise_mode.dart';
import 'exercise_requirement.dart';

class ExerciseDefinition {
  const ExerciseDefinition({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.mode,
    required this.estimatedDuration,
    required this.isAvailable,
    required this.requirements,
    required this.route,
    required this.iconId,
  });

  final String id;
  final ExerciseCategory category;
  final ExerciseDifficulty difficulty;
  final ExerciseMode mode;
  final Duration estimatedDuration;
  final bool isAvailable;
  final Set<ExerciseRequirement> requirements;
  final String route;
  final String iconId;

  bool get requiresMicrophone =>
      requirements.contains(ExerciseRequirement.microphone);

  bool get requiresPiano => requirements.contains(ExerciseRequirement.piano);

  bool get requiresStaff => requirements.contains(ExerciseRequirement.staff);

  bool get requiresRhythmEngine =>
      requirements.contains(ExerciseRequirement.rhythmEngine);
}
