import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Conservatory Trainer'**
  String get appTitle;

  /// No description provided for @homePrototypeChip.
  ///
  /// In en, this message translates to:
  /// **'Early prototype'**
  String get homePrototypeChip;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Conservatory Trainer'**
  String get homeTitle;

  /// No description provided for @homeDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep ear training, melody, rhythm, and voice practice in one place.'**
  String get homeDescription;

  /// No description provided for @exerciseCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise Categories'**
  String get exerciseCategoriesTitle;

  /// No description provided for @todayPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Practice'**
  String get todayPracticeTitle;

  /// No description provided for @todayPracticePlanName.
  ///
  /// In en, this message translates to:
  /// **'12-minute demo plan'**
  String get todayPracticePlanName;

  /// No description provided for @todayPracticePlanDescription.
  ///
  /// In en, this message translates to:
  /// **'4 min single note, 4 min find the staff note, 4 min free piano.'**
  String get todayPracticePlanDescription;

  /// No description provided for @startPracticeButton.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get startPracticeButton;

  /// No description provided for @productDifferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'What this app focuses on'**
  String get productDifferenceTitle;

  /// No description provided for @productDifferenceItemListen.
  ///
  /// In en, this message translates to:
  /// **'Measures pitch accuracy by listening to your voice'**
  String get productDifferenceItemListen;

  /// No description provided for @productDifferenceItemPianoStaff.
  ///
  /// In en, this message translates to:
  /// **'Shows the same material on piano and staff together'**
  String get productDifferenceItemPianoStaff;

  /// No description provided for @productDifferenceItemExam.
  ///
  /// In en, this message translates to:
  /// **'Builds toward conservatory and aptitude exam routines'**
  String get productDifferenceItemExam;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Language and Notation'**
  String get settingsTitle;

  /// No description provided for @settingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Interface language and note naming can be changed independently. Preferences are kept in memory for now.'**
  String get settingsDescription;

  /// No description provided for @languageSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languageSettingTitle;

  /// No description provided for @languageSystemOption.
  ///
  /// In en, this message translates to:
  /// **'Use System Language'**
  String get languageSystemOption;

  /// No description provided for @languageEnglishOption.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglishOption;

  /// No description provided for @languageTurkishOption.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTurkishOption;

  /// No description provided for @noteNamingSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Note naming'**
  String get noteNamingSettingTitle;

  /// No description provided for @noteNamingSettingDescription.
  ///
  /// In en, this message translates to:
  /// **'This setting changes how note names are shown without changing the interface language.'**
  String get noteNamingSettingDescription;

  /// No description provided for @noteNamingFixedDoOption.
  ///
  /// In en, this message translates to:
  /// **'Fixed Do'**
  String get noteNamingFixedDoOption;

  /// No description provided for @noteNamingLetterNamesOption.
  ///
  /// In en, this message translates to:
  /// **'Letter Names'**
  String get noteNamingLetterNamesOption;

  /// No description provided for @noteNamingFixedDoDescription.
  ///
  /// In en, this message translates to:
  /// **'Do, Re, Mi, Fa, Sol, La, Si'**
  String get noteNamingFixedDoDescription;

  /// No description provided for @noteNamingLetterNamesDescription.
  ///
  /// In en, this message translates to:
  /// **'C, D, E, F, G, A, B'**
  String get noteNamingLetterNamesDescription;

  /// No description provided for @activeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @correctLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correctLabel;

  /// No description provided for @wrongLabel.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get wrongLabel;

  /// No description provided for @incorrectLabel.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get incorrectLabel;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @openTraining.
  ///
  /// In en, this message translates to:
  /// **'Open Exercise'**
  String get openTraining;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @categoryExercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get categoryExercisesTitle;

  /// No description provided for @exerciseUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'This exercise will be available soon.'**
  String get exerciseUnavailableMessage;

  /// No description provided for @backToHomeButton.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHomeButton;

  /// No description provided for @categoryNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Category Not Found'**
  String get categoryNotFoundTitle;

  /// No description provided for @categoryNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This category is not defined right now.'**
  String get categoryNotFoundMessage;

  /// No description provided for @exerciseNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise Not Found'**
  String get exerciseNotFoundTitle;

  /// No description provided for @exerciseNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The requested exercise is not defined right now.'**
  String get exerciseNotFoundMessage;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 min} other{{count} min}}'**
  String durationMinutes(int count);

  /// No description provided for @questionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question} other{{count} questions}}'**
  String questionCount(int count);

  /// No description provided for @availableProgress.
  ///
  /// In en, this message translates to:
  /// **'{available} / {total} ready'**
  String availableProgress(int available, int total);

  /// No description provided for @categoryHearAndSingTitle.
  ///
  /// In en, this message translates to:
  /// **'Hear and Sing'**
  String get categoryHearAndSingTitle;

  /// No description provided for @categoryHearAndSingDescription.
  ///
  /// In en, this message translates to:
  /// **'Repeat what you hear with accurate pitch and vocal control.'**
  String get categoryHearAndSingDescription;

  /// No description provided for @categoryHearAndTapTitle.
  ///
  /// In en, this message translates to:
  /// **'Hear and Tap'**
  String get categoryHearAndTapTitle;

  /// No description provided for @categoryHearAndTapDescription.
  ///
  /// In en, this message translates to:
  /// **'Answer rhythmic material with claps, taps, or timing controls.'**
  String get categoryHearAndTapDescription;

  /// No description provided for @categoryHearAndWriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Hear and Write'**
  String get categoryHearAndWriteTitle;

  /// No description provided for @categoryHearAndWriteDescription.
  ///
  /// In en, this message translates to:
  /// **'Place what you hear onto the staff with correct notes and durations.'**
  String get categoryHearAndWriteDescription;

  /// No description provided for @categoryReadAndPerformTitle.
  ///
  /// In en, this message translates to:
  /// **'Read and Perform'**
  String get categoryReadAndPerformTitle;

  /// No description provided for @categoryReadAndPerformDescription.
  ///
  /// In en, this message translates to:
  /// **'Read notation, identify notes, and perform them with voice or piano.'**
  String get categoryReadAndPerformDescription;

  /// No description provided for @categoryExamSimulationTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam Simulation'**
  String get categoryExamSimulationTitle;

  /// No description provided for @categoryExamSimulationDescription.
  ///
  /// In en, this message translates to:
  /// **'Practice mixed exercise flows that feel closer to real assessments.'**
  String get categoryExamSimulationDescription;

  /// No description provided for @categoryFreePracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Practice'**
  String get categoryFreePracticeTitle;

  /// No description provided for @categoryFreePracticeDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the piano, staff, and helper tools for self-directed repetition.'**
  String get categoryFreePracticeDescription;

  /// No description provided for @difficultyBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get difficultyBeginner;

  /// No description provided for @difficultyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get difficultyIntermediate;

  /// No description provided for @difficultyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get difficultyAdvanced;

  /// No description provided for @modeTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get modeTraining;

  /// No description provided for @modeExam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get modeExam;

  /// No description provided for @modeFreePractice.
  ///
  /// In en, this message translates to:
  /// **'Free Practice'**
  String get modeFreePractice;

  /// No description provided for @requirementMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get requirementMicrophone;

  /// No description provided for @requirementPiano.
  ///
  /// In en, this message translates to:
  /// **'Piano'**
  String get requirementPiano;

  /// No description provided for @requirementStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get requirementStaff;

  /// No description provided for @requirementRhythmEngine.
  ///
  /// In en, this message translates to:
  /// **'Rhythm Engine'**
  String get requirementRhythmEngine;

  /// No description provided for @requirementPitchDetection.
  ///
  /// In en, this message translates to:
  /// **'Pitch Detection'**
  String get requirementPitchDetection;

  /// No description provided for @exerciseSingleNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Single Note Repetition'**
  String get exerciseSingleNoteTitle;

  /// No description provided for @exerciseSingleNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Hear one target pitch and repeat the same note with your voice.'**
  String get exerciseSingleNoteDescription;

  /// No description provided for @exerciseTwoNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Note Separation'**
  String get exerciseTwoNoteTitle;

  /// No description provided for @exerciseTwoNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Distinguish two notes and focus on hearing each line separately.'**
  String get exerciseTwoNoteDescription;

  /// No description provided for @exerciseThreeNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Three-Note Separation'**
  String get exerciseThreeNoteTitle;

  /// No description provided for @exerciseThreeNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Recognize three-note textures and separate the inner lines by ear.'**
  String get exerciseThreeNoteDescription;

  /// No description provided for @exerciseFourNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Four-Note Separation'**
  String get exerciseFourNoteTitle;

  /// No description provided for @exerciseFourNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Prepare to hear and isolate four-note chord structures.'**
  String get exerciseFourNoteDescription;

  /// No description provided for @exerciseMelodyRepeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Melody Repetition'**
  String get exerciseMelodyRepeatTitle;

  /// No description provided for @exerciseMelodyRepeatDescription.
  ///
  /// In en, this message translates to:
  /// **'Repeat short melodies in the correct order and pitch.'**
  String get exerciseMelodyRepeatDescription;

  /// No description provided for @exerciseIntervalSingingTitle.
  ///
  /// In en, this message translates to:
  /// **'Interval Singing'**
  String get exerciseIntervalSingingTitle;

  /// No description provided for @exerciseIntervalSingingDescription.
  ///
  /// In en, this message translates to:
  /// **'Build the target interval from a given starting note with your voice.'**
  String get exerciseIntervalSingingDescription;

  /// No description provided for @exerciseRhythmRepeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Rhythm Repetition'**
  String get exerciseRhythmRepeatTitle;

  /// No description provided for @exerciseRhythmRepeatDescription.
  ///
  /// In en, this message translates to:
  /// **'Answer the rhythm you hear with the same timing flow.'**
  String get exerciseRhythmRepeatDescription;

  /// No description provided for @exerciseCompleteRhythmTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the Rhythm'**
  String get exerciseCompleteRhythmTitle;

  /// No description provided for @exerciseCompleteRhythmDescription.
  ///
  /// In en, this message translates to:
  /// **'Fill in the missing beats with the correct note values.'**
  String get exerciseCompleteRhythmDescription;

  /// No description provided for @exerciseFindBrokenRhythmTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the Broken Rhythm'**
  String get exerciseFindBrokenRhythmTitle;

  /// No description provided for @exerciseFindBrokenRhythmDescription.
  ///
  /// In en, this message translates to:
  /// **'Spot the difference between the correct pattern and the broken rhythm.'**
  String get exerciseFindBrokenRhythmDescription;

  /// No description provided for @exerciseClapRepeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Clap Repetition'**
  String get exerciseClapRepeatTitle;

  /// No description provided for @exerciseClapRepeatDescription.
  ///
  /// In en, this message translates to:
  /// **'Repeat the rhythm through claps or taps captured by the microphone.'**
  String get exerciseClapRepeatDescription;

  /// No description provided for @exercisePlaceSingleNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Place the Note on the Staff'**
  String get exercisePlaceSingleNoteTitle;

  /// No description provided for @exercisePlaceSingleNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the correct staff position for the single note you hear.'**
  String get exercisePlaceSingleNoteDescription;

  /// No description provided for @exerciseWriteRhythmTitle.
  ///
  /// In en, this message translates to:
  /// **'Write the Rhythm on the Staff'**
  String get exerciseWriteRhythmTitle;

  /// No description provided for @exerciseWriteRhythmDescription.
  ///
  /// In en, this message translates to:
  /// **'Place heard rhythms into a measure using note values.'**
  String get exerciseWriteRhythmDescription;

  /// No description provided for @exerciseMelodicDictationTitle.
  ///
  /// In en, this message translates to:
  /// **'Melodic Dictation'**
  String get exerciseMelodicDictationTitle;

  /// No description provided for @exerciseMelodicDictationDescription.
  ///
  /// In en, this message translates to:
  /// **'Write the melody you hear onto the staff with notes and durations.'**
  String get exerciseMelodicDictationDescription;

  /// No description provided for @exercisePlaceChordTitle.
  ///
  /// In en, this message translates to:
  /// **'Place the Chord on the Staff'**
  String get exercisePlaceChordTitle;

  /// No description provided for @exercisePlaceChordDescription.
  ///
  /// In en, this message translates to:
  /// **'Write simultaneous notes onto the staff as a chord.'**
  String get exercisePlaceChordDescription;

  /// No description provided for @exerciseNoteReadingAndWritingTitle.
  ///
  /// In en, this message translates to:
  /// **'Note Reading and Writing'**
  String get exerciseNoteReadingAndWritingTitle;

  /// No description provided for @exerciseNoteReadingAndWritingDescription.
  ///
  /// In en, this message translates to:
  /// **'Identify the note you see on the staff together with its octave.'**
  String get exerciseNoteReadingAndWritingDescription;

  /// No description provided for @exerciseSingStaffNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Sing the Staff Note'**
  String get exerciseSingStaffNoteTitle;

  /// No description provided for @exerciseSingStaffNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Try to sing the note shown on the staff with the correct pitch.'**
  String get exerciseSingStaffNoteDescription;

  /// No description provided for @exercisePlayOnPianoTitle.
  ///
  /// In en, this message translates to:
  /// **'Play on Piano'**
  String get exercisePlayOnPianoTitle;

  /// No description provided for @exercisePlayOnPianoDescription.
  ///
  /// In en, this message translates to:
  /// **'Play the note shown on the staff on the on-screen piano.'**
  String get exercisePlayOnPianoDescription;

  /// No description provided for @exerciseSightSingingTitle.
  ///
  /// In en, this message translates to:
  /// **'Sight Singing'**
  String get exerciseSightSingingTitle;

  /// No description provided for @exerciseSightSingingDescription.
  ///
  /// In en, this message translates to:
  /// **'Read short written passages and perform them without prior rehearsal.'**
  String get exerciseSightSingingDescription;

  /// No description provided for @exerciseSolfegeTitle.
  ///
  /// In en, this message translates to:
  /// **'Solfege'**
  String get exerciseSolfegeTitle;

  /// No description provided for @exerciseSolfegeDescription.
  ///
  /// In en, this message translates to:
  /// **'Sing the written melody with correct rhythm and pitch.'**
  String get exerciseSolfegeDescription;

  /// No description provided for @exerciseExamSimulationTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam Simulation'**
  String get exerciseExamSimulationTitle;

  /// No description provided for @exerciseExamSimulationDescription.
  ///
  /// In en, this message translates to:
  /// **'Solve core listening and notation tasks in a single exam-like flow.'**
  String get exerciseExamSimulationDescription;

  /// No description provided for @exerciseIntermediateExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Intermediate Exam Simulation'**
  String get exerciseIntermediateExamTitle;

  /// No description provided for @exerciseIntermediateExamDescription.
  ///
  /// In en, this message translates to:
  /// **'Mix longer listening and rhythm tasks into one guided rehearsal.'**
  String get exerciseIntermediateExamDescription;

  /// No description provided for @exerciseAdvancedExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Exam Simulation'**
  String get exerciseAdvancedExamTitle;

  /// No description provided for @exerciseAdvancedExamDescription.
  ///
  /// In en, this message translates to:
  /// **'Combine polyphonic and melodic tasks in one advanced exam flow.'**
  String get exerciseAdvancedExamDescription;

  /// No description provided for @exerciseCustomExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Exam Builder'**
  String get exerciseCustomExamTitle;

  /// No description provided for @exerciseCustomExamDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your own assessment flow or teacher-led practice set.'**
  String get exerciseCustomExamDescription;

  /// No description provided for @exerciseFreePianoTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Piano'**
  String get exerciseFreePianoTitle;

  /// No description provided for @exerciseFreePianoDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore notes and repeat freely on the interactive keyboard.'**
  String get exerciseFreePianoDescription;

  /// No description provided for @exerciseFreeStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Staff'**
  String get exerciseFreeStaffTitle;

  /// No description provided for @exerciseFreeStaffDescription.
  ///
  /// In en, this message translates to:
  /// **'Review note placement logic on the staff without scoring.'**
  String get exerciseFreeStaffDescription;

  /// No description provided for @exerciseMetronomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Metronome'**
  String get exerciseMetronomeTitle;

  /// No description provided for @exerciseMetronomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Practice steady tempo on your own.'**
  String get exerciseMetronomeDescription;

  /// No description provided for @exerciseTunerTitle.
  ///
  /// In en, this message translates to:
  /// **'Tuner'**
  String get exerciseTunerTitle;

  /// No description provided for @exerciseTunerDescription.
  ///
  /// In en, this message translates to:
  /// **'Monitor pitch height in real time and check intonation.'**
  String get exerciseTunerDescription;

  /// No description provided for @exerciseVocalRangeTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Vocal Range Test'**
  String get exerciseVocalRangeTestTitle;

  /// No description provided for @exerciseVocalRangeTestDescription.
  ///
  /// In en, this message translates to:
  /// **'Prepare to measure your comfortable low and high singing range.'**
  String get exerciseVocalRangeTestDescription;

  /// No description provided for @singleNoteAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Single Note Repetition'**
  String get singleNoteAppBarTitle;

  /// No description provided for @singleNoteHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Repeat the note you hear'**
  String get singleNoteHeroTitle;

  /// No description provided for @singleNoteHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Listen to the target note first, then try to match it with your voice. The target is shown on the staff instead of writing its name directly.'**
  String get singleNoteHeroDescription;

  /// No description provided for @targetNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Target note'**
  String get targetNoteLabel;

  /// No description provided for @targetNoteOnStaff.
  ///
  /// In en, this message translates to:
  /// **'Shown on the staff'**
  String get targetNoteOnStaff;

  /// No description provided for @targetFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Target frequency'**
  String get targetFrequencyLabel;

  /// No description provided for @listenButton.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listenButton;

  /// No description provided for @singStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start Singing'**
  String get singStartButton;

  /// No description provided for @detectedNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Detected note'**
  String get detectedNoteLabel;

  /// No description provided for @detectedNoteCaption.
  ///
  /// In en, this message translates to:
  /// **'Sample data is shown for now.'**
  String get detectedNoteCaption;

  /// No description provided for @detectedFrequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Detected frequency'**
  String get detectedFrequencyLabel;

  /// No description provided for @detectedFrequencyCaption.
  ///
  /// In en, this message translates to:
  /// **'A sample frequency close to the target note.'**
  String get detectedFrequencyCaption;

  /// No description provided for @centDifferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Cent difference'**
  String get centDifferenceLabel;

  /// No description provided for @centDifferenceCaption.
  ///
  /// In en, this message translates to:
  /// **'A negative value means your note is a little flat.'**
  String get centDifferenceCaption;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @resultPanelDescription.
  ///
  /// In en, this message translates to:
  /// **'The flat / correct / sharp indicator will update live once real analysis is added.'**
  String get resultPanelDescription;

  /// No description provided for @pitchFlat.
  ///
  /// In en, this message translates to:
  /// **'Slightly flat'**
  String get pitchFlat;

  /// No description provided for @pitchCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get pitchCorrect;

  /// No description provided for @pitchSharp.
  ///
  /// In en, this message translates to:
  /// **'Slightly sharp'**
  String get pitchSharp;

  /// No description provided for @previewSoundPlayingMessage.
  ///
  /// In en, this message translates to:
  /// **'The target pitch sample is playing.'**
  String get previewSoundPlayingMessage;

  /// No description provided for @previewSoundShowingMessage.
  ///
  /// In en, this message translates to:
  /// **'The target pitch is being shown. {audioStatus}'**
  String previewSoundShowingMessage(Object audioStatus);

  /// No description provided for @microphonePermissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission was denied. You need to allow it before using this exercise.'**
  String get microphonePermissionDeniedMessage;

  /// No description provided for @recordPreviewMessage.
  ///
  /// In en, this message translates to:
  /// **'The microphone flow is ready, but the real pitch analysis engine that converts your voice into notes has not been added yet. Sample results are shown for now.'**
  String get recordPreviewMessage;

  /// No description provided for @demoSequencePlayingMessage.
  ///
  /// In en, this message translates to:
  /// **'The Do-Mi-Sol demo has started.'**
  String get demoSequencePlayingMessage;

  /// No description provided for @demoSequenceShowingMessage.
  ///
  /// In en, this message translates to:
  /// **'The Do-Mi-Sol demo is being shown. {audioStatus}'**
  String demoSequenceShowingMessage(Object audioStatus);

  /// No description provided for @pianoOpenButton.
  ///
  /// In en, this message translates to:
  /// **'Open Piano'**
  String get pianoOpenButton;

  /// No description provided for @pianoCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Close Piano'**
  String get pianoCloseButton;

  /// No description provided for @showExerciseNotesOnPiano.
  ///
  /// In en, this message translates to:
  /// **'Show exercise notes on the piano'**
  String get showExerciseNotesOnPiano;

  /// No description provided for @followHighlightByOctave.
  ///
  /// In en, this message translates to:
  /// **'Follow highlights by octave'**
  String get followHighlightByOctave;

  /// No description provided for @showNoteNamesOnKeys.
  ///
  /// In en, this message translates to:
  /// **'Show note names'**
  String get showNoteNamesOnKeys;

  /// No description provided for @sustainLabel.
  ///
  /// In en, this message translates to:
  /// **'Sustain'**
  String get sustainLabel;

  /// No description provided for @stopAllPianoButton.
  ///
  /// In en, this message translates to:
  /// **'Stop All'**
  String get stopAllPianoButton;

  /// No description provided for @playA4DemoButton.
  ///
  /// In en, this message translates to:
  /// **'Play A4'**
  String get playA4DemoButton;

  /// No description provided for @playCMajorDemoButton.
  ///
  /// In en, this message translates to:
  /// **'Play C Major'**
  String get playCMajorDemoButton;

  /// No description provided for @playReferenceNoteButton.
  ///
  /// In en, this message translates to:
  /// **'Show and Play {noteName}'**
  String playReferenceNoteButton(Object noteName);

  /// No description provided for @playMajorChordButton.
  ///
  /// In en, this message translates to:
  /// **'Show and Play {chordName}'**
  String playMajorChordButton(Object chordName);

  /// No description provided for @majorChordName.
  ///
  /// In en, this message translates to:
  /// **'{rootName} major chord'**
  String majorChordName(Object rootName);

  /// No description provided for @developmentDemoButton.
  ///
  /// In en, this message translates to:
  /// **'Show the Do-Mi-Sol demo'**
  String get developmentDemoButton;

  /// No description provided for @previousOctave.
  ///
  /// In en, this message translates to:
  /// **'Previous Octave'**
  String get previousOctave;

  /// No description provided for @nextOctave.
  ///
  /// In en, this message translates to:
  /// **'Next Octave'**
  String get nextOctave;

  /// No description provided for @octaveLabel.
  ///
  /// In en, this message translates to:
  /// **'Octave {octave}'**
  String octaveLabel(int octave);

  /// No description provided for @octaveRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Octave {startOctave}-{endOctave}'**
  String octaveRangeLabel(int startOctave, int endOctave);

  /// No description provided for @lastPlayedNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Last played note'**
  String get lastPlayedNoteTitle;

  /// No description provided for @noNotePlayedYet.
  ///
  /// In en, this message translates to:
  /// **'You have not played a note yet'**
  String get noNotePlayedYet;

  /// No description provided for @lastPlayedNoteDetails.
  ///
  /// In en, this message translates to:
  /// **'International: {internationalName} • MIDI {midi} • {frequency}'**
  String lastPlayedNoteDetails(
    Object internationalName,
    int midi,
    Object frequency,
  );

  /// No description provided for @lastPlayedNoteHint.
  ///
  /// In en, this message translates to:
  /// **'When you press a key, its name, octave, MIDI number, and frequency will appear here.'**
  String get lastPlayedNoteHint;

  /// No description provided for @pianoSoundReady.
  ///
  /// In en, this message translates to:
  /// **'Piano sound is ready.'**
  String get pianoSoundReady;

  /// No description provided for @invalidMidiNoteMessage.
  ///
  /// In en, this message translates to:
  /// **'A valid MIDI note number could not be used.'**
  String get invalidMidiNoteMessage;

  /// No description provided for @pianoSoundFontMissingMessage.
  ///
  /// In en, this message translates to:
  /// **'The piano sound file has not been added yet.'**
  String get pianoSoundFontMissingMessage;

  /// No description provided for @pianoSoundFontInvalidMessage.
  ///
  /// In en, this message translates to:
  /// **'The piano sound file is invalid or corrupted.'**
  String get pianoSoundFontInvalidMessage;

  /// No description provided for @pianoEngineErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Piano sound could not be prepared right now.'**
  String get pianoEngineErrorMessage;

  /// No description provided for @staffOpenButton.
  ///
  /// In en, this message translates to:
  /// **'Open Staff'**
  String get staffOpenButton;

  /// No description provided for @staffCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Close Staff'**
  String get staffCloseButton;

  /// No description provided for @staffPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff View'**
  String get staffPanelTitle;

  /// No description provided for @staffPanelDescription.
  ///
  /// In en, this message translates to:
  /// **'The same MIDI note is shared between the voice exercise, piano, and staff view.'**
  String get staffPanelDescription;

  /// No description provided for @resolvedClefLabel.
  ///
  /// In en, this message translates to:
  /// **'Resolved clef'**
  String get resolvedClefLabel;

  /// No description provided for @measureLabel.
  ///
  /// In en, this message translates to:
  /// **'Meter'**
  String get measureLabel;

  /// No description provided for @showPlayingNotesOnStaff.
  ///
  /// In en, this message translates to:
  /// **'Show playing notes on the staff'**
  String get showPlayingNotesOnStaff;

  /// No description provided for @clefSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Clef selection'**
  String get clefSelectionTitle;

  /// No description provided for @clefAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get clefAuto;

  /// No description provided for @clefTreble.
  ///
  /// In en, this message translates to:
  /// **'Treble Clef'**
  String get clefTreble;

  /// No description provided for @clefBass.
  ///
  /// In en, this message translates to:
  /// **'Bass Clef'**
  String get clefBass;

  /// No description provided for @clefAlto.
  ///
  /// In en, this message translates to:
  /// **'Alto Clef'**
  String get clefAlto;

  /// No description provided for @clefTenor.
  ///
  /// In en, this message translates to:
  /// **'Tenor Clef'**
  String get clefTenor;

  /// No description provided for @restLabel.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get restLabel;

  /// No description provided for @staffNoteSemantics.
  ///
  /// In en, this message translates to:
  /// **'{noteName} note'**
  String staffNoteSemantics(Object noteName);

  /// No description provided for @noteAccessibilityNatural.
  ///
  /// In en, this message translates to:
  /// **'{noteName} {octave}'**
  String noteAccessibilityNatural(Object noteName, Object octave);

  /// No description provided for @noteAccessibilityAccidental.
  ///
  /// In en, this message translates to:
  /// **'{noteName} {accidental} {octave}'**
  String noteAccessibilityAccidental(
    Object noteName,
    Object accidental,
    Object octave,
  );

  /// No description provided for @pianoKeySemantics.
  ///
  /// In en, this message translates to:
  /// **'{noteName} piano key'**
  String pianoKeySemantics(Object noteName);

  /// No description provided for @accidentalSharpWord.
  ///
  /// In en, this message translates to:
  /// **'sharp'**
  String get accidentalSharpWord;

  /// No description provided for @accidentalFlatWord.
  ///
  /// In en, this message translates to:
  /// **'flat'**
  String get accidentalFlatWord;

  /// No description provided for @staffQuizAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the Note on the Staff'**
  String get staffQuizAppBarTitle;

  /// No description provided for @staffQuizIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'See the Note and Name It'**
  String get staffQuizIntroTitle;

  /// No description provided for @staffQuizIntroDescription.
  ///
  /// In en, this message translates to:
  /// **'For now, questions are generated in treble clef within a one-octave range.'**
  String get staffQuizIntroDescription;

  /// No description provided for @staffQuizPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the note on the staff'**
  String get staffQuizPromptTitle;

  /// No description provided for @staffQuizPromptDescription.
  ///
  /// In en, this message translates to:
  /// **'This exercise also evaluates the octave.'**
  String get staffQuizPromptDescription;

  /// No description provided for @newQuestionButton.
  ///
  /// In en, this message translates to:
  /// **'New Question'**
  String get newQuestionButton;

  /// No description provided for @correctAnswerTitle.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get correctAnswerTitle;

  /// No description provided for @wrongAnswerTitle.
  ///
  /// In en, this message translates to:
  /// **'Incorrect answer'**
  String get wrongAnswerTitle;

  /// No description provided for @staffQuizCorrectMessage.
  ///
  /// In en, this message translates to:
  /// **'You identified the note with the correct octave.'**
  String get staffQuizCorrectMessage;

  /// No description provided for @staffQuizWrongMessage.
  ///
  /// In en, this message translates to:
  /// **'The correct answer should have been {noteName}.'**
  String staffQuizWrongMessage(Object noteName);

  /// No description provided for @noteValueLessonAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Note Values'**
  String get noteValueLessonAppBarTitle;

  /// No description provided for @noteValueLessonHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Note Durations'**
  String get noteValueLessonHeaderTitle;

  /// No description provided for @noteValueLessonHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Previews run at 60 BPM. For now, duration emphasis and sample sound are used together.'**
  String get noteValueLessonHeaderDescription;

  /// No description provided for @noteValueBeatsLabel.
  ///
  /// In en, this message translates to:
  /// **'{beats} beats in 4/4'**
  String noteValueBeatsLabel(Object beats);

  /// No description provided for @examplePattern.
  ///
  /// In en, this message translates to:
  /// **'Example: {example}'**
  String examplePattern(Object example);

  /// No description provided for @listenShortButton.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listenShortButton;

  /// No description provided for @noteValueWhole.
  ///
  /// In en, this message translates to:
  /// **'Whole note'**
  String get noteValueWhole;

  /// No description provided for @noteValueHalf.
  ///
  /// In en, this message translates to:
  /// **'Half note'**
  String get noteValueHalf;

  /// No description provided for @noteValueQuarter.
  ///
  /// In en, this message translates to:
  /// **'Quarter note'**
  String get noteValueQuarter;

  /// No description provided for @noteValueEighth.
  ///
  /// In en, this message translates to:
  /// **'Eighth note'**
  String get noteValueEighth;

  /// No description provided for @noteValueSixteenth.
  ///
  /// In en, this message translates to:
  /// **'Sixteenth note'**
  String get noteValueSixteenth;

  /// No description provided for @noteValueDottedHalf.
  ///
  /// In en, this message translates to:
  /// **'Dotted half note'**
  String get noteValueDottedHalf;

  /// No description provided for @noteValueDottedQuarter.
  ///
  /// In en, this message translates to:
  /// **'Dotted quarter note'**
  String get noteValueDottedQuarter;

  /// No description provided for @noteValueDottedEighth.
  ///
  /// In en, this message translates to:
  /// **'Dotted eighth note'**
  String get noteValueDottedEighth;

  /// No description provided for @noteValueExampleWhole.
  ///
  /// In en, this message translates to:
  /// **'Ta-a-a-a'**
  String get noteValueExampleWhole;

  /// No description provided for @noteValueExampleHalf.
  ///
  /// In en, this message translates to:
  /// **'Ta-a'**
  String get noteValueExampleHalf;

  /// No description provided for @noteValueExampleQuarter.
  ///
  /// In en, this message translates to:
  /// **'Ta'**
  String get noteValueExampleQuarter;

  /// No description provided for @noteValueExampleEighth.
  ///
  /// In en, this message translates to:
  /// **'Ti-ti'**
  String get noteValueExampleEighth;

  /// No description provided for @melodyWritingAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Write the Melody on the Staff'**
  String get melodyWritingAppBarTitle;

  /// No description provided for @melodyWritingIntro.
  ///
  /// In en, this message translates to:
  /// **'This screen will be used later for drag-and-drop note placement.'**
  String get melodyWritingIntro;

  /// No description provided for @melodyWritingDescription.
  ///
  /// In en, this message translates to:
  /// **'Planned tools: note value selection, rest insertion, deleting the wrong note, moving left and right, and measure validation.'**
  String get melodyWritingDescription;

  /// No description provided for @freePianoAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Piano'**
  String get freePianoAppBarTitle;

  /// No description provided for @freePianoHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Practice Area'**
  String get freePianoHeaderTitle;

  /// No description provided for @freePianoHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Use this area to try notes and memorize their keyboard positions. Real exercise scoring does not run here.'**
  String get freePianoHeaderDescription;

  /// No description provided for @productVisionShort.
  ///
  /// In en, this message translates to:
  /// **'Multilingual, voice-focused personal music training coach designed especially for conservatory and music aptitude exam preparation.'**
  String get productVisionShort;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
