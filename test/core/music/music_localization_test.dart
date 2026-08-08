import 'package:conservatory_trainer/core/music/music_localizations.dart';
import 'package:conservatory_trainer/core/music/note_label_formatter.dart';
import 'package:conservatory_trainer/core/music/note_naming_system.dart';
import 'package:conservatory_trainer/core/music/pitch_calculator.dart';
import 'package:conservatory_trainer/core/music/pitch_result_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers/test_support.dart';

void main() {
  const NoteLabelFormatter formatter = NoteLabelFormatter();

  test('correct feedback appears as Correct in English', () async {
    final l10n = await loadAppLocalizations(const Locale('en'));

    expect(PitchResultState.correct.localizedLabel(l10n), 'Correct');
  });

  test('correct feedback appears as Doğru in Turkish', () async {
    final l10n = await loadAppLocalizations(const Locale('tr'));

    expect(PitchResultState.correct.localizedLabel(l10n), 'Doğru');
  });

  test('flat and sharp feedback appear in English', () async {
    final l10n = await loadAppLocalizations(const Locale('en'));

    expect(PitchResultState.flat.localizedLabel(l10n), 'Slightly flat');
    expect(PitchResultState.sharp.localizedLabel(l10n), 'Slightly sharp');
  });

  test('question count plural is localized for English and Turkish', () async {
    final english = await loadAppLocalizations(const Locale('en'));
    final turkish = await loadAppLocalizations(const Locale('tr'));

    expect(english.questionCount(1), '1 question');
    expect(english.questionCount(5), '5 questions');
    expect(turkish.questionCount(1), '1 soru');
    expect(turkish.questionCount(5), '5 soru');
  });

  test('fixedDo shows La4', () {
    final note = PitchCalculator.midiToNote(69)!;

    expect(
      formatter.formatScientificName(
        note,
        namingSystem: NoteNamingSystem.fixedDo,
      ),
      'La4',
    );
  });

  test('letterNames shows A4', () {
    final note = PitchCalculator.midiToNote(69)!;

    expect(
      formatter.formatScientificName(
        note,
        namingSystem: NoteNamingSystem.letterNames,
      ),
      'A4',
    );
  });

  test('English interface can still use fixedDo', () async {
    final l10n = await loadAppLocalizations(const Locale('en'));
    final note = PitchCalculator.midiToNote(69)!;

    expect(
      formatter.formatScientificName(
        note,
        namingSystem: NoteNamingSystem.fixedDo,
      ),
      'La4',
    );
    expect(
      formatter.formatAccessibleScientificName(
        note,
        l10n: l10n,
        namingSystem: NoteNamingSystem.fixedDo,
      ),
      'La 4',
    );
  });

  test('Turkish interface can still use letterNames', () async {
    final l10n = await loadAppLocalizations(const Locale('tr'));
    final note = PitchCalculator.midiToNote(69)!;

    expect(
      formatter.formatScientificName(
        note,
        namingSystem: NoteNamingSystem.letterNames,
      ),
      'A4',
    );
    expect(
      formatter.formatAccessibleScientificName(
        note,
        l10n: l10n,
        namingSystem: NoteNamingSystem.letterNames,
      ),
      'A 4',
    );
  });

  test('accessibility labels change with locale', () async {
    final english = await loadAppLocalizations(const Locale('en'));
    final turkish = await loadAppLocalizations(const Locale('tr'));
    final note = PitchCalculator.midiToNote(70)!;

    final englishLabel = english.staffNoteSemantics(
      formatter.formatAccessibleScientificName(
        note,
        l10n: english,
        namingSystem: NoteNamingSystem.letterNames,
      ),
    );
    final turkishLabel = turkish.staffNoteSemantics(
      formatter.formatAccessibleScientificName(
        note,
        l10n: turkish,
        namingSystem: NoteNamingSystem.fixedDo,
      ),
    );

    expect(englishLabel, 'A sharp 4 note');
    expect(turkishLabel, 'La diyez 4 notası');
  });
}
