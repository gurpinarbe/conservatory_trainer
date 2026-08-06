import 'package:conservatory_trainer/core/music/measure.dart';
import 'package:conservatory_trainer/core/music/measure_validator.dart';
import 'package:conservatory_trainer/core/music/music_clef.dart';
import 'package:conservatory_trainer/core/music/notation_event.dart';
import 'package:conservatory_trainer/core/music/note_value.dart';
import 'package:conservatory_trainer/core/music/pitch_calculator.dart';
import 'package:conservatory_trainer/core/music/staff_position_calculator.dart';
import 'package:conservatory_trainer/core/music/time_signature.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StaffPositionCalculator', () {
    test('La4 is placed correctly in treble clef', () {
      final position = StaffPositionCalculator.positionForNote(
        note: PitchCalculator.midiToNote(69)!,
        clef: MusicClef.treble,
      );

      expect(position.stepsFromBottomLine, 3);
    });

    test('Do4 and Do5 are shown in different octave positions', () {
      final c4Position = StaffPositionCalculator.positionForNote(
        note: PitchCalculator.midiToNote(60)!,
        clef: MusicClef.treble,
      );
      final c5Position = StaffPositionCalculator.positionForNote(
        note: PitchCalculator.midiToNote(72)!,
        clef: MusicClef.treble,
      );

      expect(c4Position.stepsFromBottomLine, -2);
      expect(c5Position.stepsFromBottomLine, 5);
      expect(
        c5Position.stepsFromBottomLine,
        greaterThan(c4Position.stepsFromBottomLine),
      );
    });

    test('low notes are positioned correctly in bass clef', () {
      final g2Position = StaffPositionCalculator.positionForNote(
        note: PitchCalculator.midiToNote(43)!,
        clef: MusicClef.bass,
      );
      final e2Position = StaffPositionCalculator.positionForNote(
        note: PitchCalculator.midiToNote(40)!,
        clef: MusicClef.bass,
      );

      expect(g2Position.stepsFromBottomLine, 0);
      expect(e2Position.stepsFromBottomLine, -2);
    });

    test('changing clef does not change the midi note number', () {
      final note = PitchCalculator.midiToNote(60)!;
      final treblePosition = StaffPositionCalculator.positionForNote(
        note: note,
        clef: MusicClef.treble,
      );
      final bassPosition = StaffPositionCalculator.positionForNote(
        note: note,
        clef: MusicClef.bass,
      );

      expect(note.midiNoteNumber, 60);
      expect(
        treblePosition.stepsFromBottomLine,
        isNot(bassPosition.stepsFromBottomLine),
      );
    });
  });

  group('MeasureValidator', () {
    test('4/4 measure accepts one whole note', () {
      final measure = Measure(
        index: 0,
        timeSignature: const TimeSignature.fourFour(),
        events: <NotationEvent>[
          _noteEvent(id: 'whole', startUnits: 0, noteValue: NoteValue.whole),
        ],
      );

      expect(MeasureValidator.isMeasureDurationValid(measure), isTrue);
    });

    test('4/4 measure rejects five quarter notes', () {
      final measure = Measure(
        index: 0,
        timeSignature: const TimeSignature.fourFour(),
        events: <NotationEvent>[
          _noteEvent(id: 'q1', startUnits: 0, noteValue: NoteValue.quarter),
          _noteEvent(id: 'q2', startUnits: 4, noteValue: NoteValue.quarter),
          _noteEvent(id: 'q3', startUnits: 8, noteValue: NoteValue.quarter),
          _noteEvent(id: 'q4', startUnits: 12, noteValue: NoteValue.quarter),
          _noteEvent(id: 'q5', startUnits: 16, noteValue: NoteValue.quarter),
        ],
      );

      expect(MeasureValidator.isMeasureDurationValid(measure), isFalse);
    });

    test('3/4 measure accepts three quarter notes', () {
      final measure = Measure(
        index: 0,
        timeSignature: const TimeSignature.threeFour(),
        events: <NotationEvent>[
          _noteEvent(id: 'q1', startUnits: 0, noteValue: NoteValue.quarter),
          _noteEvent(id: 'q2', startUnits: 4, noteValue: NoteValue.quarter),
          _noteEvent(id: 'q3', startUnits: 8, noteValue: NoteValue.quarter),
        ],
      );

      expect(MeasureValidator.isMeasureDurationValid(measure), isTrue);
    });

    test('6/8 measure accepts six eighth notes', () {
      final measure = Measure(
        index: 0,
        timeSignature: const TimeSignature.sixEight(),
        events: List<NotationEvent>.generate(6, (int index) {
          return _noteEvent(
            id: 'e$index',
            startUnits: index * 2,
            noteValue: NoteValue.eighth,
          );
        }),
      );

      expect(MeasureValidator.isMeasureDurationValid(measure), isTrue);
    });
  });
}

NoteEvent _noteEvent({
  required String id,
  required int startUnits,
  required NoteValue noteValue,
}) {
  final note = PitchCalculator.midiToNote(60)!;

  return NoteEvent(
    note: note,
    id: id,
    noteValue: noteValue,
    startUnits: startUnits,
    measureIndex: 0,
    accidental: note.accidental,
  );
}
