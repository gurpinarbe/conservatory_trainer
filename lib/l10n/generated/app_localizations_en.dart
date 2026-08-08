// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Conservatory Trainer';

  @override
  String get homePrototypeChip => 'Early prototype';

  @override
  String get homeTitle => 'Conservatory Trainer';

  @override
  String get homeDescription =>
      'Keep ear training, melody, rhythm, and voice practice in one place.';

  @override
  String get exerciseCategoriesTitle => 'Exercise Categories';

  @override
  String get todayPracticeTitle => 'Today\'s Practice';

  @override
  String get todayPracticePlanName => '12-minute demo plan';

  @override
  String get todayPracticePlanDescription =>
      '4 min single note, 4 min find the staff note, 4 min free piano.';

  @override
  String get startPracticeButton => 'Start Practice';

  @override
  String get productDifferenceTitle => 'What this app focuses on';

  @override
  String get productDifferenceItemListen =>
      'Measures pitch accuracy by listening to your voice';

  @override
  String get productDifferenceItemPianoStaff =>
      'Shows the same material on piano and staff together';

  @override
  String get productDifferenceItemExam =>
      'Builds toward conservatory and aptitude exam routines';

  @override
  String get settingsTitle => 'Language and Notation';

  @override
  String get settingsDescription =>
      'Interface language and note naming can be changed independently. Preferences are kept in memory for now.';

  @override
  String get languageSettingTitle => 'App language';

  @override
  String get languageSystemOption => 'Use System Language';

  @override
  String get languageEnglishOption => 'English';

  @override
  String get languageTurkishOption => 'Turkish';

  @override
  String get noteNamingSettingTitle => 'Note naming';

  @override
  String get noteNamingSettingDescription =>
      'This setting changes how note names are shown without changing the interface language.';

  @override
  String get noteNamingFixedDoOption => 'Fixed Do';

  @override
  String get noteNamingLetterNamesOption => 'Letter Names';

  @override
  String get noteNamingFixedDoDescription => 'Do, Re, Mi, Fa, Sol, La, Si';

  @override
  String get noteNamingLetterNamesDescription => 'C, D, E, F, G, A, B';

  @override
  String get activeLabel => 'Active';

  @override
  String get totalLabel => 'Total';

  @override
  String get correctLabel => 'Correct';

  @override
  String get wrongLabel => 'Incorrect';

  @override
  String get incorrectLabel => 'Incorrect';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get statusActive => 'Active';

  @override
  String get openTraining => 'Open Exercise';

  @override
  String get viewDetails => 'View Details';

  @override
  String get categoryExercisesTitle => 'Exercises';

  @override
  String get exerciseUnavailableMessage =>
      'This exercise will be available soon.';

  @override
  String get backToHomeButton => 'Back to Home';

  @override
  String get categoryNotFoundTitle => 'Category Not Found';

  @override
  String get categoryNotFoundMessage =>
      'This category is not defined right now.';

  @override
  String get exerciseNotFoundTitle => 'Exercise Not Found';

  @override
  String get exerciseNotFoundMessage =>
      'The requested exercise is not defined right now.';

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min',
      one: '1 min',
    );
    return '$_temp0';
  }

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String availableProgress(int available, int total) {
    return '$available / $total ready';
  }

  @override
  String get categoryHearAndSingTitle => 'Hear and Sing';

  @override
  String get categoryHearAndSingDescription =>
      'Repeat what you hear with accurate pitch and vocal control.';

  @override
  String get categoryHearAndTapTitle => 'Hear and Tap';

  @override
  String get categoryHearAndTapDescription =>
      'Answer rhythmic material with claps, taps, or timing controls.';

  @override
  String get categoryHearAndWriteTitle => 'Hear and Write';

  @override
  String get categoryHearAndWriteDescription =>
      'Place what you hear onto the staff with correct notes and durations.';

  @override
  String get categoryReadAndPerformTitle => 'Read and Perform';

  @override
  String get categoryReadAndPerformDescription =>
      'Read notation, identify notes, and perform them with voice or piano.';

  @override
  String get categoryExamSimulationTitle => 'Exam Simulation';

  @override
  String get categoryExamSimulationDescription =>
      'Practice mixed exercise flows that feel closer to real assessments.';

  @override
  String get categoryFreePracticeTitle => 'Free Practice';

  @override
  String get categoryFreePracticeDescription =>
      'Use the piano, staff, and helper tools for self-directed repetition.';

  @override
  String get difficultyBeginner => 'Beginner';

  @override
  String get difficultyIntermediate => 'Intermediate';

  @override
  String get difficultyAdvanced => 'Advanced';

  @override
  String get modeTraining => 'Training';

  @override
  String get modeExam => 'Exam';

  @override
  String get modeFreePractice => 'Free Practice';

  @override
  String get requirementMicrophone => 'Microphone';

  @override
  String get requirementPiano => 'Piano';

  @override
  String get requirementStaff => 'Staff';

  @override
  String get requirementRhythmEngine => 'Rhythm Engine';

  @override
  String get requirementPitchDetection => 'Pitch Detection';

  @override
  String get exerciseSingleNoteTitle => 'Single Note Repetition';

  @override
  String get exerciseSingleNoteDescription =>
      'Hear one target pitch and repeat the same note with your voice.';

  @override
  String get exerciseTwoNoteTitle => 'Two-Note Separation';

  @override
  String get exerciseTwoNoteDescription =>
      'Distinguish two notes and focus on hearing each line separately.';

  @override
  String get exerciseThreeNoteTitle => 'Three-Note Separation';

  @override
  String get exerciseThreeNoteDescription =>
      'Recognize three-note textures and separate the inner lines by ear.';

  @override
  String get exerciseFourNoteTitle => 'Four-Note Separation';

  @override
  String get exerciseFourNoteDescription =>
      'Prepare to hear and isolate four-note chord structures.';

  @override
  String get exerciseMelodyRepeatTitle => 'Melody Repetition';

  @override
  String get exerciseMelodyRepeatDescription =>
      'Repeat short melodies in the correct order and pitch.';

  @override
  String get exerciseIntervalSingingTitle => 'Interval Singing';

  @override
  String get exerciseIntervalSingingDescription =>
      'Build the target interval from a given starting note with your voice.';

  @override
  String get exerciseRhythmRepeatTitle => 'Rhythm Repetition';

  @override
  String get exerciseRhythmRepeatDescription =>
      'Answer the rhythm you hear with the same timing flow.';

  @override
  String get exerciseCompleteRhythmTitle => 'Complete the Rhythm';

  @override
  String get exerciseCompleteRhythmDescription =>
      'Fill in the missing beats with the correct note values.';

  @override
  String get exerciseFindBrokenRhythmTitle => 'Find the Broken Rhythm';

  @override
  String get exerciseFindBrokenRhythmDescription =>
      'Spot the difference between the correct pattern and the broken rhythm.';

  @override
  String get exerciseClapRepeatTitle => 'Clap Repetition';

  @override
  String get exerciseClapRepeatDescription =>
      'Repeat the rhythm through claps or taps captured by the microphone.';

  @override
  String get exercisePlaceSingleNoteTitle => 'Place the Note on the Staff';

  @override
  String get exercisePlaceSingleNoteDescription =>
      'Choose the correct staff position for the single note you hear.';

  @override
  String get exerciseWriteRhythmTitle => 'Write the Rhythm on the Staff';

  @override
  String get exerciseWriteRhythmDescription =>
      'Place heard rhythms into a measure using note values.';

  @override
  String get exerciseMelodicDictationTitle => 'Melodic Dictation';

  @override
  String get exerciseMelodicDictationDescription =>
      'Write the melody you hear onto the staff with notes and durations.';

  @override
  String get exercisePlaceChordTitle => 'Place the Chord on the Staff';

  @override
  String get exercisePlaceChordDescription =>
      'Write simultaneous notes onto the staff as a chord.';

  @override
  String get exerciseNoteReadingAndWritingTitle => 'Note Reading and Writing';

  @override
  String get exerciseNoteReadingAndWritingDescription =>
      'Identify the note you see on the staff together with its octave.';

  @override
  String get exerciseSingStaffNoteTitle => 'Sing the Staff Note';

  @override
  String get exerciseSingStaffNoteDescription =>
      'Try to sing the note shown on the staff with the correct pitch.';

  @override
  String get exercisePlayOnPianoTitle => 'Play on Piano';

  @override
  String get exercisePlayOnPianoDescription =>
      'Play the note shown on the staff on the on-screen piano.';

  @override
  String get exerciseSightSingingTitle => 'Sight Singing';

  @override
  String get exerciseSightSingingDescription =>
      'Read short written passages and perform them without prior rehearsal.';

  @override
  String get exerciseSolfegeTitle => 'Solfege';

  @override
  String get exerciseSolfegeDescription =>
      'Sing the written melody with correct rhythm and pitch.';

  @override
  String get exerciseExamSimulationTitle => 'Exam Simulation';

  @override
  String get exerciseExamSimulationDescription =>
      'Solve core listening and notation tasks in a single exam-like flow.';

  @override
  String get exerciseIntermediateExamTitle => 'Intermediate Exam Simulation';

  @override
  String get exerciseIntermediateExamDescription =>
      'Mix longer listening and rhythm tasks into one guided rehearsal.';

  @override
  String get exerciseAdvancedExamTitle => 'Advanced Exam Simulation';

  @override
  String get exerciseAdvancedExamDescription =>
      'Combine polyphonic and melodic tasks in one advanced exam flow.';

  @override
  String get exerciseCustomExamTitle => 'Custom Exam Builder';

  @override
  String get exerciseCustomExamDescription =>
      'Create your own assessment flow or teacher-led practice set.';

  @override
  String get exerciseFreePianoTitle => 'Free Piano';

  @override
  String get exerciseFreePianoDescription =>
      'Explore notes and repeat freely on the interactive keyboard.';

  @override
  String get exerciseFreeStaffTitle => 'Free Staff';

  @override
  String get exerciseFreeStaffDescription =>
      'Review note placement logic on the staff without scoring.';

  @override
  String get exerciseMetronomeTitle => 'Metronome';

  @override
  String get exerciseMetronomeDescription =>
      'Practice steady tempo on your own.';

  @override
  String get exerciseTunerTitle => 'Tuner';

  @override
  String get exerciseTunerDescription =>
      'Monitor pitch height in real time and check intonation.';

  @override
  String get exerciseVocalRangeTestTitle => 'Vocal Range Test';

  @override
  String get exerciseVocalRangeTestDescription =>
      'Prepare to measure your comfortable low and high singing range.';

  @override
  String get singleNoteAppBarTitle => 'Single Note Repetition';

  @override
  String get singleNoteHeroTitle => 'Repeat the note you hear';

  @override
  String get singleNoteHeroDescription =>
      'Listen to the target note first, then try to match it with your voice. The target is shown on the staff instead of writing its name directly.';

  @override
  String get targetNoteLabel => 'Target note';

  @override
  String get targetNoteOnStaff => 'Shown on the staff';

  @override
  String get targetFrequencyLabel => 'Target frequency';

  @override
  String get listenButton => 'Listen';

  @override
  String get singStartButton => 'Start Singing';

  @override
  String get detectedNoteLabel => 'Detected note';

  @override
  String get detectedNoteCaption => 'Sample data is shown for now.';

  @override
  String get detectedFrequencyLabel => 'Detected frequency';

  @override
  String get detectedFrequencyCaption =>
      'A sample frequency close to the target note.';

  @override
  String get centDifferenceLabel => 'Cent difference';

  @override
  String get centDifferenceCaption =>
      'A negative value means your note is a little flat.';

  @override
  String get resultTitle => 'Result';

  @override
  String get resultPanelDescription =>
      'The flat / correct / sharp indicator will update live once real analysis is added.';

  @override
  String get pitchFlat => 'Slightly flat';

  @override
  String get pitchCorrect => 'Correct';

  @override
  String get pitchSharp => 'Slightly sharp';

  @override
  String get previewSoundPlayingMessage =>
      'The target pitch sample is playing.';

  @override
  String previewSoundShowingMessage(Object audioStatus) {
    return 'The target pitch is being shown. $audioStatus';
  }

  @override
  String get microphonePermissionDeniedMessage =>
      'Microphone permission was denied. You need to allow it before using this exercise.';

  @override
  String get recordPreviewMessage =>
      'The microphone flow is ready, but the real pitch analysis engine that converts your voice into notes has not been added yet. Sample results are shown for now.';

  @override
  String get demoSequencePlayingMessage => 'The Do-Mi-Sol demo has started.';

  @override
  String demoSequenceShowingMessage(Object audioStatus) {
    return 'The Do-Mi-Sol demo is being shown. $audioStatus';
  }

  @override
  String get pianoOpenButton => 'Open Piano';

  @override
  String get pianoCloseButton => 'Close Piano';

  @override
  String get showExerciseNotesOnPiano => 'Show exercise notes on the piano';

  @override
  String get followHighlightByOctave => 'Follow highlights by octave';

  @override
  String get showNoteNamesOnKeys => 'Show note names on keys';

  @override
  String playReferenceNoteButton(Object noteName) {
    return 'Show and Play $noteName';
  }

  @override
  String playMajorChordButton(Object chordName) {
    return 'Show and Play $chordName';
  }

  @override
  String majorChordName(Object rootName) {
    return '$rootName major chord';
  }

  @override
  String get developmentDemoButton => 'Show the Do-Mi-Sol demo';

  @override
  String get previousOctave => 'Previous Octave';

  @override
  String get nextOctave => 'Next Octave';

  @override
  String octaveLabel(int octave) {
    return 'Octave $octave';
  }

  @override
  String get lastPlayedNoteTitle => 'Last played note';

  @override
  String get noNotePlayedYet => 'You have not played a note yet';

  @override
  String lastPlayedNoteDetails(
    Object internationalName,
    int midi,
    Object frequency,
  ) {
    return 'International: $internationalName • MIDI $midi • $frequency';
  }

  @override
  String get lastPlayedNoteHint =>
      'When you press a key, its name, octave, MIDI number, and frequency will appear here.';

  @override
  String get pianoSoundReady => 'Piano sound is ready.';

  @override
  String get invalidMidiNoteMessage =>
      'A valid MIDI note number could not be used.';

  @override
  String get pianoSoundFontMissingMessage =>
      'The piano sound file has not been added yet.';

  @override
  String get pianoSoundFontInvalidMessage =>
      'The piano sound file is invalid or corrupted.';

  @override
  String get pianoEngineErrorMessage =>
      'Piano sound could not be prepared right now.';

  @override
  String get staffOpenButton => 'Open Staff';

  @override
  String get staffCloseButton => 'Close Staff';

  @override
  String get staffPanelTitle => 'Staff View';

  @override
  String get staffPanelDescription =>
      'The same MIDI note is shared between the voice exercise, piano, and staff view.';

  @override
  String get resolvedClefLabel => 'Resolved clef';

  @override
  String get measureLabel => 'Meter';

  @override
  String get showPlayingNotesOnStaff => 'Show playing notes on the staff';

  @override
  String get clefSelectionTitle => 'Clef selection';

  @override
  String get clefAuto => 'Automatic';

  @override
  String get clefTreble => 'Treble Clef';

  @override
  String get clefBass => 'Bass Clef';

  @override
  String get clefAlto => 'Alto Clef';

  @override
  String get clefTenor => 'Tenor Clef';

  @override
  String get restLabel => 'Rest';

  @override
  String staffNoteSemantics(Object noteName) {
    return '$noteName note';
  }

  @override
  String noteAccessibilityNatural(Object noteName, Object octave) {
    return '$noteName $octave';
  }

  @override
  String noteAccessibilityAccidental(
    Object noteName,
    Object accidental,
    Object octave,
  ) {
    return '$noteName $accidental $octave';
  }

  @override
  String get accidentalSharpWord => 'sharp';

  @override
  String get accidentalFlatWord => 'flat';

  @override
  String get staffQuizAppBarTitle => 'Find the Note on the Staff';

  @override
  String get staffQuizIntroTitle => 'See the Note and Name It';

  @override
  String get staffQuizIntroDescription =>
      'For now, questions are generated in treble clef within a one-octave range.';

  @override
  String get staffQuizPromptTitle => 'Choose the note on the staff';

  @override
  String get staffQuizPromptDescription =>
      'This exercise also evaluates the octave.';

  @override
  String get newQuestionButton => 'New Question';

  @override
  String get correctAnswerTitle => 'Correct answer';

  @override
  String get wrongAnswerTitle => 'Incorrect answer';

  @override
  String get staffQuizCorrectMessage =>
      'You identified the note with the correct octave.';

  @override
  String staffQuizWrongMessage(Object noteName) {
    return 'The correct answer should have been $noteName.';
  }

  @override
  String get noteValueLessonAppBarTitle => 'Learn Note Values';

  @override
  String get noteValueLessonHeaderTitle => 'Basic Note Durations';

  @override
  String get noteValueLessonHeaderDescription =>
      'Previews run at 60 BPM. For now, duration emphasis and sample sound are used together.';

  @override
  String noteValueBeatsLabel(Object beats) {
    return '$beats beats in 4/4';
  }

  @override
  String examplePattern(Object example) {
    return 'Example: $example';
  }

  @override
  String get listenShortButton => 'Listen';

  @override
  String get noteValueWhole => 'Whole note';

  @override
  String get noteValueHalf => 'Half note';

  @override
  String get noteValueQuarter => 'Quarter note';

  @override
  String get noteValueEighth => 'Eighth note';

  @override
  String get noteValueSixteenth => 'Sixteenth note';

  @override
  String get noteValueDottedHalf => 'Dotted half note';

  @override
  String get noteValueDottedQuarter => 'Dotted quarter note';

  @override
  String get noteValueDottedEighth => 'Dotted eighth note';

  @override
  String get noteValueExampleWhole => 'Ta-a-a-a';

  @override
  String get noteValueExampleHalf => 'Ta-a';

  @override
  String get noteValueExampleQuarter => 'Ta';

  @override
  String get noteValueExampleEighth => 'Ti-ti';

  @override
  String get melodyWritingAppBarTitle => 'Write the Melody on the Staff';

  @override
  String get melodyWritingIntro =>
      'This screen will be used later for drag-and-drop note placement.';

  @override
  String get melodyWritingDescription =>
      'Planned tools: note value selection, rest insertion, deleting the wrong note, moving left and right, and measure validation.';

  @override
  String get freePianoAppBarTitle => 'Free Piano';

  @override
  String get freePianoHeaderTitle => 'Free Practice Area';

  @override
  String get freePianoHeaderDescription =>
      'Use this area to try notes and memorize their keyboard positions. Real exercise scoring does not run here.';

  @override
  String get productVisionShort =>
      'Multilingual, voice-focused personal music training coach designed especially for conservatory and music aptitude exam preparation.';
}
