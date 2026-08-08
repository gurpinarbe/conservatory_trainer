import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_routes.dart';
import '../domain/exercise_category.dart';
import '../domain/exercise_definition.dart';
import '../domain/exercise_difficulty.dart';
import '../domain/exercise_mode.dart';
import '../domain/exercise_requirement.dart';

abstract final class ExerciseCatalogIds {
  static const String singleNoteRepeat = 'single-note-repeat';
  static const String doubleNoteSeparation = 'double-note-separation';
  static const String tripleNoteSeparation = 'triple-note-separation';
  static const String quadNoteSeparation = 'quad-note-separation';
  static const String melodyRepeat = 'melody-repeat';
  static const String intervalSinging = 'interval-singing';

  static const String rhythmRepeat = 'rhythm-repeat';
  static const String completeTheRhythm = 'complete-the-rhythm';
  static const String findBrokenRhythm = 'find-broken-rhythm';
  static const String clapRepeat = 'clap-repeat';

  static const String placeSingleNoteOnStaff = 'place-single-note-on-staff';
  static const String writeRhythmOnStaff = 'write-rhythm-on-staff';
  static const String melodicDictation = 'melodic-dictation';
  static const String placeChordOnStaff = 'place-chord-on-staff';

  static const String staffNoteQuiz = 'staff-note-quiz';
  static const String singStaffNote = 'sing-staff-note';
  static const String playOnPiano = 'play-on-piano';
  static const String sightReading = 'sight-reading';
  static const String solfege = 'solfege';

  static const String beginnerExam = 'beginner-exam';
  static const String intermediateExam = 'intermediate-exam';
  static const String advancedExam = 'advanced-exam';
  static const String customExam = 'custom-exam';

  static const String freePiano = 'free-piano';
  static const String freeStaff = 'free-staff';
  static const String metronome = 'metronome';
  static const String tuner = 'tuner';
  static const String vocalRangeTest = 'vocal-range-test';
}

final exerciseCatalogProvider = Provider<ExerciseCatalog>((Ref ref) {
  return ExerciseCatalog();
});

class ExerciseCatalog {
  ExerciseCatalog({List<ExerciseDefinition>? definitions})
    : definitions = definitions ?? _definitions;

  final List<ExerciseDefinition> definitions;

  List<ExerciseCategory> get categories => ExerciseCategory.values;

  Map<ExerciseCategory, List<ExerciseDefinition>> get groupedByCategory => {
    for (final ExerciseCategory category in categories)
      category: exercisesForCategory(category),
  };

  ExerciseDefinition? findById(String id) {
    for (final ExerciseDefinition definition in definitions) {
      if (definition.id == id) {
        return definition;
      }
    }

    return null;
  }

  List<ExerciseDefinition> exercisesForCategory(ExerciseCategory category) {
    return definitions
        .where(
          (ExerciseDefinition definition) => definition.category == category,
        )
        .toList(growable: false);
  }

  int availableCountForCategory(ExerciseCategory category) {
    return exercisesForCategory(
      category,
    ).where((ExerciseDefinition definition) => definition.isAvailable).length;
  }

  static final List<ExerciseDefinition> _definitions = <ExerciseDefinition>[
    ExerciseDefinition(
      id: ExerciseCatalogIds.singleNoteRepeat,
      category: ExerciseCategory.hearAndSing,
      difficulty: ExerciseDifficulty.beginner,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 4),
      isAvailable: true,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.singleNoteRepeat),
      iconId: 'single-note',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.doubleNoteSeparation,
      category: ExerciseCategory.hearAndSing,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 6),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.doubleNoteSeparation),
      iconId: 'double-note',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.tripleNoteSeparation,
      category: ExerciseCategory.hearAndSing,
      difficulty: ExerciseDifficulty.advanced,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 7),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.tripleNoteSeparation),
      iconId: 'triple-note',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.quadNoteSeparation,
      category: ExerciseCategory.hearAndSing,
      difficulty: ExerciseDifficulty.advanced,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 8),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.quadNoteSeparation),
      iconId: 'chord-stack',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.melodyRepeat,
      category: ExerciseCategory.hearAndSing,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 8),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
        ExerciseRequirement.pitchDetection,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.melodyRepeat),
      iconId: 'melody',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.intervalSinging,
      category: ExerciseCategory.hearAndSing,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 5),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.intervalSinging),
      iconId: 'interval',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.rhythmRepeat,
      category: ExerciseCategory.hearAndTap,
      difficulty: ExerciseDifficulty.beginner,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 5),
      isAvailable: false,
      requirements: <ExerciseRequirement>{ExerciseRequirement.rhythmEngine},
      route: AppRoute.exercisePath(ExerciseCatalogIds.rhythmRepeat),
      iconId: 'rhythm-repeat',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.completeTheRhythm,
      category: ExerciseCategory.hearAndTap,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 6),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.staff,
        ExerciseRequirement.rhythmEngine,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.completeTheRhythm),
      iconId: 'complete-rhythm',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.findBrokenRhythm,
      category: ExerciseCategory.hearAndTap,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 6),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.staff,
        ExerciseRequirement.rhythmEngine,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.findBrokenRhythm),
      iconId: 'find-rhythm',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.clapRepeat,
      category: ExerciseCategory.hearAndTap,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 7),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.rhythmEngine,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.clapRepeat),
      iconId: 'clap',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.placeSingleNoteOnStaff,
      category: ExerciseCategory.hearAndWrite,
      difficulty: ExerciseDifficulty.beginner,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 5),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.placeSingleNoteOnStaff),
      iconId: 'staff-note',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.writeRhythmOnStaff,
      category: ExerciseCategory.hearAndWrite,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 7),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.staff,
        ExerciseRequirement.rhythmEngine,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.writeRhythmOnStaff),
      iconId: 'write-rhythm',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.melodicDictation,
      category: ExerciseCategory.hearAndWrite,
      difficulty: ExerciseDifficulty.advanced,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 10),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
        ExerciseRequirement.rhythmEngine,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.melodicDictation),
      iconId: 'melodic-dictation',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.placeChordOnStaff,
      category: ExerciseCategory.hearAndWrite,
      difficulty: ExerciseDifficulty.advanced,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 9),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.placeChordOnStaff),
      iconId: 'staff-chord',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.staffNoteQuiz,
      category: ExerciseCategory.readAndPerform,
      difficulty: ExerciseDifficulty.beginner,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 5),
      isAvailable: true,
      requirements: <ExerciseRequirement>{ExerciseRequirement.staff},
      route: AppRoute.exercisePath(ExerciseCatalogIds.staffNoteQuiz),
      iconId: 'find-note',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.singStaffNote,
      category: ExerciseCategory.readAndPerform,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 6),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.singStaffNote),
      iconId: 'sing-note',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.playOnPiano,
      category: ExerciseCategory.readAndPerform,
      difficulty: ExerciseDifficulty.beginner,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 5),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.playOnPiano),
      iconId: 'play-piano',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.sightReading,
      category: ExerciseCategory.readAndPerform,
      difficulty: ExerciseDifficulty.advanced,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 10),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
        ExerciseRequirement.rhythmEngine,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.sightReading),
      iconId: 'sight-reading',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.solfege,
      category: ExerciseCategory.readAndPerform,
      difficulty: ExerciseDifficulty.advanced,
      mode: ExerciseMode.training,
      estimatedDuration: Duration(minutes: 10),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
        ExerciseRequirement.rhythmEngine,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.solfege),
      iconId: 'solfege',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.beginnerExam,
      category: ExerciseCategory.examSimulation,
      difficulty: ExerciseDifficulty.beginner,
      mode: ExerciseMode.exam,
      estimatedDuration: Duration(minutes: 12),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.beginnerExam),
      iconId: 'exam-beginner',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.intermediateExam,
      category: ExerciseCategory.examSimulation,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.exam,
      estimatedDuration: Duration(minutes: 15),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
        ExerciseRequirement.rhythmEngine,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.intermediateExam),
      iconId: 'exam-intermediate',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.advancedExam,
      category: ExerciseCategory.examSimulation,
      difficulty: ExerciseDifficulty.advanced,
      mode: ExerciseMode.exam,
      estimatedDuration: Duration(minutes: 20),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
        ExerciseRequirement.rhythmEngine,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.advancedExam),
      iconId: 'exam-advanced',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.customExam,
      category: ExerciseCategory.examSimulation,
      difficulty: ExerciseDifficulty.advanced,
      mode: ExerciseMode.exam,
      estimatedDuration: Duration(minutes: 15),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.piano,
        ExerciseRequirement.staff,
        ExerciseRequirement.rhythmEngine,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.customExam),
      iconId: 'custom-exam',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.freePiano,
      category: ExerciseCategory.freePractice,
      difficulty: ExerciseDifficulty.beginner,
      mode: ExerciseMode.freePractice,
      estimatedDuration: Duration(minutes: 6),
      isAvailable: true,
      requirements: <ExerciseRequirement>{ExerciseRequirement.piano},
      route: AppRoute.practicePiano,
      iconId: 'free-piano',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.freeStaff,
      category: ExerciseCategory.freePractice,
      difficulty: ExerciseDifficulty.beginner,
      mode: ExerciseMode.freePractice,
      estimatedDuration: Duration(minutes: 6),
      isAvailable: false,
      requirements: <ExerciseRequirement>{ExerciseRequirement.staff},
      route: AppRoute.practiceStaff,
      iconId: 'free-staff',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.metronome,
      category: ExerciseCategory.freePractice,
      difficulty: ExerciseDifficulty.beginner,
      mode: ExerciseMode.freePractice,
      estimatedDuration: Duration(minutes: 4),
      isAvailable: false,
      requirements: <ExerciseRequirement>{ExerciseRequirement.rhythmEngine},
      route: AppRoute.exercisePath(ExerciseCatalogIds.metronome),
      iconId: 'metronome',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.tuner,
      category: ExerciseCategory.freePractice,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.freePractice,
      estimatedDuration: Duration(minutes: 4),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.pitchDetection,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.tuner),
      iconId: 'tuner',
    ),
    ExerciseDefinition(
      id: ExerciseCatalogIds.vocalRangeTest,
      category: ExerciseCategory.freePractice,
      difficulty: ExerciseDifficulty.intermediate,
      mode: ExerciseMode.freePractice,
      estimatedDuration: Duration(minutes: 8),
      isAvailable: false,
      requirements: <ExerciseRequirement>{
        ExerciseRequirement.microphone,
        ExerciseRequirement.piano,
        ExerciseRequirement.pitchDetection,
      },
      route: AppRoute.exercisePath(ExerciseCatalogIds.vocalRangeTest),
      iconId: 'range-test',
    ),
  ];
}
