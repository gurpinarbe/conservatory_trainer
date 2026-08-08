abstract final class AppRoute {
  static const String home = '/';

  static const String category = '/category/:categoryId';
  static const String exercise = '/exercise/:exerciseId';
  static const String practicePiano = '/practice/piano';
  static const String practiceStaff = '/practice/staff';

  static const String legacySingleNote = '/single-note';
  static const String legacyNoteReading = '/note-reading';
  static const String legacyStaffNoteQuiz = '/note-reading/staff-note-quiz';
  static const String noteValueLesson = '/note-reading/note-values';
  static const String melodyWritingSandbox =
      '/note-reading/melody-writing-sandbox';

  static String categoryPath(String categoryId) => '/category/$categoryId';

  static String exercisePath(String exerciseId) => '/exercise/$exerciseId';
}
