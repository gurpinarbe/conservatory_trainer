enum AppRoute {
  home('/'),
  singleNote('/single-note'),
  noteReading('/note-reading'),
  staffNoteQuiz('/note-reading/staff-note-quiz'),
  noteValueLesson('/note-reading/note-values'),
  melodyWritingSandbox('/note-reading/melody-writing-sandbox');

  const AppRoute(this.path);

  final String path;
}
