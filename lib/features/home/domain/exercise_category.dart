enum ExerciseCategory {
  hearAndSing,
  hearAndTap,
  hearAndWrite,
  readAndPerform,
  examSimulation,
  freePractice,
}

extension ExerciseCategoryX on ExerciseCategory {
  String get id => switch (this) {
    ExerciseCategory.hearAndSing => 'hear-and-sing',
    ExerciseCategory.hearAndTap => 'hear-and-tap',
    ExerciseCategory.hearAndWrite => 'hear-and-write',
    ExerciseCategory.readAndPerform => 'read-and-perform',
    ExerciseCategory.examSimulation => 'exam-simulation',
    ExerciseCategory.freePractice => 'free-practice',
  };

  static ExerciseCategory? fromId(String id) {
    for (final ExerciseCategory category in ExerciseCategory.values) {
      if (category.id == id) {
        return category;
      }
    }

    return null;
  }
}
