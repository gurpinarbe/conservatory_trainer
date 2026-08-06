import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/note_reading/presentation/melody_writing_sandbox_screen.dart';
import '../features/note_reading/presentation/note_reading_home_screen.dart';
import '../features/note_reading/presentation/note_value_lesson_screen.dart';
import '../features/note_reading/presentation/staff_note_quiz_screen.dart';
import '../features/single_note/presentation/single_note_screen.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.home.path,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.singleNote.path,
        builder: (context, state) => const SingleNoteScreen(),
      ),
      GoRoute(
        path: AppRoute.noteReading.path,
        builder: (context, state) => const NoteReadingHomeScreen(),
      ),
      GoRoute(
        path: AppRoute.staffNoteQuiz.path,
        builder: (context, state) => const StaffNoteQuizScreen(),
      ),
      GoRoute(
        path: AppRoute.noteValueLesson.path,
        builder: (context, state) => const NoteValueLessonScreen(),
      ),
      GoRoute(
        path: AppRoute.melodyWritingSandbox.path,
        builder: (context, state) => const MelodyWritingSandboxScreen(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
