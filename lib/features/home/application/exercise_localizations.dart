import '../../../l10n/l10n.dart';
import '../domain/exercise_category.dart';
import '../domain/exercise_definition.dart';
import '../domain/exercise_difficulty.dart';
import '../domain/exercise_mode.dart';
import '../domain/exercise_requirement.dart';
import 'exercise_catalog.dart';

extension ExerciseCategoryLocalizationX on ExerciseCategory {
  String localizedTitle(AppLocalizations l10n) {
    return switch (this) {
      ExerciseCategory.hearAndSing => l10n.categoryHearAndSingTitle,
      ExerciseCategory.hearAndTap => l10n.categoryHearAndTapTitle,
      ExerciseCategory.hearAndWrite => l10n.categoryHearAndWriteTitle,
      ExerciseCategory.readAndPerform => l10n.categoryReadAndPerformTitle,
      ExerciseCategory.examSimulation => l10n.categoryExamSimulationTitle,
      ExerciseCategory.freePractice => l10n.categoryFreePracticeTitle,
    };
  }

  String localizedDescription(AppLocalizations l10n) {
    return switch (this) {
      ExerciseCategory.hearAndSing => l10n.categoryHearAndSingDescription,
      ExerciseCategory.hearAndTap => l10n.categoryHearAndTapDescription,
      ExerciseCategory.hearAndWrite => l10n.categoryHearAndWriteDescription,
      ExerciseCategory.readAndPerform => l10n.categoryReadAndPerformDescription,
      ExerciseCategory.examSimulation => l10n.categoryExamSimulationDescription,
      ExerciseCategory.freePractice => l10n.categoryFreePracticeDescription,
    };
  }
}

extension ExerciseDifficultyLocalizationX on ExerciseDifficulty {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      ExerciseDifficulty.beginner => l10n.difficultyBeginner,
      ExerciseDifficulty.intermediate => l10n.difficultyIntermediate,
      ExerciseDifficulty.advanced => l10n.difficultyAdvanced,
    };
  }
}

extension ExerciseModeLocalizationX on ExerciseMode {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      ExerciseMode.training => l10n.modeTraining,
      ExerciseMode.exam => l10n.modeExam,
      ExerciseMode.freePractice => l10n.modeFreePractice,
    };
  }
}

extension ExerciseRequirementLocalizationX on ExerciseRequirement {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      ExerciseRequirement.microphone => l10n.requirementMicrophone,
      ExerciseRequirement.piano => l10n.requirementPiano,
      ExerciseRequirement.staff => l10n.requirementStaff,
      ExerciseRequirement.rhythmEngine => l10n.requirementRhythmEngine,
      ExerciseRequirement.pitchDetection => l10n.requirementPitchDetection,
    };
  }
}

extension ExerciseDefinitionLocalizationX on ExerciseDefinition {
  String localizedTitle(AppLocalizations l10n) {
    return switch (id) {
      ExerciseCatalogIds.singleNoteRepeat => l10n.exerciseSingleNoteTitle,
      ExerciseCatalogIds.doubleNoteSeparation => l10n.exerciseTwoNoteTitle,
      ExerciseCatalogIds.tripleNoteSeparation => l10n.exerciseThreeNoteTitle,
      ExerciseCatalogIds.quadNoteSeparation => l10n.exerciseFourNoteTitle,
      ExerciseCatalogIds.melodyRepeat => l10n.exerciseMelodyRepeatTitle,
      ExerciseCatalogIds.intervalSinging => l10n.exerciseIntervalSingingTitle,
      ExerciseCatalogIds.rhythmRepeat => l10n.exerciseRhythmRepeatTitle,
      ExerciseCatalogIds.completeTheRhythm => l10n.exerciseCompleteRhythmTitle,
      ExerciseCatalogIds.findBrokenRhythm => l10n.exerciseFindBrokenRhythmTitle,
      ExerciseCatalogIds.clapRepeat => l10n.exerciseClapRepeatTitle,
      ExerciseCatalogIds.placeSingleNoteOnStaff =>
        l10n.exercisePlaceSingleNoteTitle,
      ExerciseCatalogIds.writeRhythmOnStaff => l10n.exerciseWriteRhythmTitle,
      ExerciseCatalogIds.melodicDictation => l10n.exerciseMelodicDictationTitle,
      ExerciseCatalogIds.placeChordOnStaff => l10n.exercisePlaceChordTitle,
      ExerciseCatalogIds.staffNoteQuiz =>
        l10n.exerciseNoteReadingAndWritingTitle,
      ExerciseCatalogIds.singStaffNote => l10n.exerciseSingStaffNoteTitle,
      ExerciseCatalogIds.playOnPiano => l10n.exercisePlayOnPianoTitle,
      ExerciseCatalogIds.sightReading => l10n.exerciseSightSingingTitle,
      ExerciseCatalogIds.solfege => l10n.exerciseSolfegeTitle,
      ExerciseCatalogIds.beginnerExam => l10n.exerciseExamSimulationTitle,
      ExerciseCatalogIds.intermediateExam => l10n.exerciseIntermediateExamTitle,
      ExerciseCatalogIds.advancedExam => l10n.exerciseAdvancedExamTitle,
      ExerciseCatalogIds.customExam => l10n.exerciseCustomExamTitle,
      ExerciseCatalogIds.freePiano => l10n.exerciseFreePianoTitle,
      ExerciseCatalogIds.freeStaff => l10n.exerciseFreeStaffTitle,
      ExerciseCatalogIds.metronome => l10n.exerciseMetronomeTitle,
      ExerciseCatalogIds.tuner => l10n.exerciseTunerTitle,
      ExerciseCatalogIds.vocalRangeTest => l10n.exerciseVocalRangeTestTitle,
      _ => id,
    };
  }

  String localizedDescription(AppLocalizations l10n) {
    return switch (id) {
      ExerciseCatalogIds.singleNoteRepeat => l10n.exerciseSingleNoteDescription,
      ExerciseCatalogIds.doubleNoteSeparation =>
        l10n.exerciseTwoNoteDescription,
      ExerciseCatalogIds.tripleNoteSeparation =>
        l10n.exerciseThreeNoteDescription,
      ExerciseCatalogIds.quadNoteSeparation => l10n.exerciseFourNoteDescription,
      ExerciseCatalogIds.melodyRepeat => l10n.exerciseMelodyRepeatDescription,
      ExerciseCatalogIds.intervalSinging =>
        l10n.exerciseIntervalSingingDescription,
      ExerciseCatalogIds.rhythmRepeat => l10n.exerciseRhythmRepeatDescription,
      ExerciseCatalogIds.completeTheRhythm =>
        l10n.exerciseCompleteRhythmDescription,
      ExerciseCatalogIds.findBrokenRhythm =>
        l10n.exerciseFindBrokenRhythmDescription,
      ExerciseCatalogIds.clapRepeat => l10n.exerciseClapRepeatDescription,
      ExerciseCatalogIds.placeSingleNoteOnStaff =>
        l10n.exercisePlaceSingleNoteDescription,
      ExerciseCatalogIds.writeRhythmOnStaff =>
        l10n.exerciseWriteRhythmDescription,
      ExerciseCatalogIds.melodicDictation =>
        l10n.exerciseMelodicDictationDescription,
      ExerciseCatalogIds.placeChordOnStaff =>
        l10n.exercisePlaceChordDescription,
      ExerciseCatalogIds.staffNoteQuiz =>
        l10n.exerciseNoteReadingAndWritingDescription,
      ExerciseCatalogIds.singStaffNote => l10n.exerciseSingStaffNoteDescription,
      ExerciseCatalogIds.playOnPiano => l10n.exercisePlayOnPianoDescription,
      ExerciseCatalogIds.sightReading => l10n.exerciseSightSingingDescription,
      ExerciseCatalogIds.solfege => l10n.exerciseSolfegeDescription,
      ExerciseCatalogIds.beginnerExam => l10n.exerciseExamSimulationDescription,
      ExerciseCatalogIds.intermediateExam =>
        l10n.exerciseIntermediateExamDescription,
      ExerciseCatalogIds.advancedExam => l10n.exerciseAdvancedExamDescription,
      ExerciseCatalogIds.customExam => l10n.exerciseCustomExamDescription,
      ExerciseCatalogIds.freePiano => l10n.exerciseFreePianoDescription,
      ExerciseCatalogIds.freeStaff => l10n.exerciseFreeStaffDescription,
      ExerciseCatalogIds.metronome => l10n.exerciseMetronomeDescription,
      ExerciseCatalogIds.tuner => l10n.exerciseTunerDescription,
      ExerciseCatalogIds.vocalRangeTest =>
        l10n.exerciseVocalRangeTestDescription,
      _ => id,
    };
  }
}
