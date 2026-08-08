import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n.dart';
import '../features/free_practice/presentation/free_piano_screen.dart';
import '../features/home/application/exercise_catalog.dart';
import '../features/home/application/exercise_localizations.dart';
import '../features/home/domain/exercise_category.dart';
import '../features/home/domain/exercise_definition.dart';
import '../features/home/presentation/category_screen.dart';
import '../features/home/presentation/exercise_unavailable_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/note_reading/presentation/melody_writing_sandbox_screen.dart';
import '../features/note_reading/presentation/note_reading_home_screen.dart';
import '../features/note_reading/presentation/note_value_lesson_screen.dart';
import '../features/note_reading/presentation/staff_note_quiz_screen.dart';
import '../features/single_note/presentation/single_note_screen.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final ExerciseCatalog catalog = ref.watch(exerciseCatalogProvider);
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: AppRoute.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.category,
        builder: (context, state) {
          final String categoryId = state.pathParameters['categoryId'] ?? '';
          final ExerciseCategory? category = ExerciseCategoryX.fromId(
            categoryId,
          );

          if (category == null) {
            final AppLocalizations l10n = context.l10n;

            return ExerciseUnavailableScreen(
              title: l10n.categoryNotFoundTitle,
              message: l10n.categoryNotFoundMessage,
            );
          }

          return CategoryScreen(category: category);
        },
      ),
      GoRoute(
        path: AppRoute.exercise,
        builder: (context, state) {
          final String exerciseId = state.pathParameters['exerciseId'] ?? '';
          return _buildExerciseScreen(context, catalog, exerciseId);
        },
      ),
      GoRoute(
        path: AppRoute.practicePiano,
        builder: (context, state) => const FreePianoScreen(),
      ),
      GoRoute(
        path: AppRoute.practiceStaff,
        builder: (context, state) {
          final ExerciseDefinition? exercise = catalog.findById(
            ExerciseCatalogIds.freeStaff,
          );

          return ExerciseUnavailableScreen(
            title:
                exercise?.localizedTitle(context.l10n) ??
                context.l10n.exerciseFreeStaffTitle,
            description: exercise?.localizedDescription(context.l10n),
          );
        },
      ),
      GoRoute(
        path: AppRoute.legacySingleNote,
        redirect: (context, state) =>
            AppRoute.exercisePath(ExerciseCatalogIds.singleNoteRepeat),
      ),
      GoRoute(
        path: AppRoute.legacyNoteReading,
        builder: (context, state) => const NoteReadingHomeScreen(),
      ),
      GoRoute(
        path: AppRoute.legacyStaffNoteQuiz,
        redirect: (context, state) =>
            AppRoute.exercisePath(ExerciseCatalogIds.staffNoteQuiz),
      ),
      GoRoute(
        path: AppRoute.noteValueLesson,
        builder: (context, state) => const NoteValueLessonScreen(),
      ),
      GoRoute(
        path: AppRoute.melodyWritingSandbox,
        builder: (context, state) => const MelodyWritingSandboxScreen(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});

Widget _buildExerciseScreen(
  BuildContext context,
  ExerciseCatalog catalog,
  String exerciseId,
) {
  final ExerciseDefinition? exercise = catalog.findById(exerciseId);
  final AppLocalizations l10n = context.l10n;

  if (exercise == null) {
    return ExerciseUnavailableScreen(
      title: l10n.exerciseNotFoundTitle,
      message: l10n.exerciseNotFoundMessage,
    );
  }

  if (!exercise.isAvailable) {
    return ExerciseUnavailableScreen(
      title: exercise.localizedTitle(l10n),
      description: exercise.localizedDescription(l10n),
    );
  }

  switch (exercise.id) {
    case ExerciseCatalogIds.singleNoteRepeat:
      return const SingleNoteScreen();
    case ExerciseCatalogIds.staffNoteQuiz:
      return const StaffNoteQuizScreen();
    default:
      return ExerciseUnavailableScreen(
        title: exercise.localizedTitle(l10n),
        description: exercise.localizedDescription(l10n),
      );
  }
}
