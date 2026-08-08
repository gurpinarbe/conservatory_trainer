import 'package:conservatory_trainer/core/music/music_note.dart';
import 'package:conservatory_trainer/core/music/piano_keyboard_layout.dart';
import 'package:conservatory_trainer/core/music/piano_note_range.dart';
import 'package:conservatory_trainer/core/music/pitch_calculator.dart';
import 'package:conservatory_trainer/core/music/pitch_result_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PitchCalculator', () {
    test('MIDI 60 is C4', () {
      final MusicNote? note = PitchCalculator.midiToNote(60);

      expect(note, isNotNull);
      expect(note?.pitchClass, PitchClass.c);
      expect(note?.octave, 4);
      expect(note?.midiNoteNumber, 60);
    });

    test('MIDI 69 is A4 at 440 Hz', () {
      final MusicNote? note = PitchCalculator.midiToNote(69);

      expect(note, isNotNull);
      expect(note?.pitchClass, PitchClass.a);
      expect(note?.octave, 4);
      expect(note?.midiNoteNumber, 69);
      expect(note?.frequencyHz, closeTo(440.0, 0.001));
    });

    test('440 Hz is A4', () {
      final MusicNote? note = PitchCalculator.frequencyToNote(440);

      expect(PitchCalculator.frequencyToNearestMidiNoteNumber(440), 69);
      expect(PitchCalculator.midiToFrequency(69), closeTo(440.0, 0.001));
      expect(PitchCalculator.midiToNoteName(69), 'A');
      expect(PitchCalculator.frequencyToOctave(440), 4);
      expect(note?.pitchClass, PitchClass.a);
      expect(note?.octave, 4);
      expect(note?.frequencyHz, closeTo(440.0, 0.001));
    });

    test('261.63 Hz is approximately C4', () {
      final MusicNote? note = PitchCalculator.frequencyToNote(261.63);

      expect(note?.midiNoteNumber, 60);
      expect(note?.pitchClass, PitchClass.c);
      expect(note?.octave, 4);
    });

    test('329.63 Hz is approximately E4', () {
      final MusicNote? note = PitchCalculator.frequencyToNote(329.63);

      expect(note?.midiNoteNumber, 64);
      expect(note?.pitchClass, PitchClass.e);
      expect(note?.octave, 4);
    });

    test('392 Hz is approximately G4', () {
      final MusicNote? note = PitchCalculator.frequencyToNote(392);

      expect(note?.midiNoteNumber, 67);
      expect(note?.pitchClass, PitchClass.g);
      expect(note?.octave, 4);
    });

    test('440 Hz and 440 Hz have 0 cent difference', () {
      final double? centDifference = PitchCalculator.centDifference(
        targetFrequencyHz: 440,
        detectedFrequencyHz: 440,
      );

      expect(centDifference, closeTo(0, 0.0001));
      expect(
        PitchCalculator.classifyCentDifference(centDifference!),
        PitchResultState.correct,
      );
    });

    test('438 Hz is a little flat relative to 440 Hz', () {
      final double? centDifference = PitchCalculator.centDifference(
        targetFrequencyHz: 440,
        detectedFrequencyHz: 438,
      );

      expect(centDifference, isNotNull);
      expect(centDifference!, lessThan(0));
      expect(
        PitchCalculator.classifyCentDifference(centDifference),
        PitchResultState.flat,
      );
    });

    test('445 Hz is sharp relative to 440 Hz', () {
      final double? centDifference = PitchCalculator.centDifference(
        targetFrequencyHz: 440,
        detectedFrequencyHz: 445,
      );

      expect(centDifference, greaterThan(15));
      expect(
        PitchCalculator.classifyCentDifference(centDifference!),
        PitchResultState.sharp,
      );
    });

    test('invalid frequencies are handled safely', () {
      expect(PitchCalculator.frequencyToNearestMidiNoteNumber(0), isNull);
      expect(PitchCalculator.frequencyToNearestMidiNoteNumber(-20), isNull);
      expect(PitchCalculator.frequencyToNote(0), isNull);
      expect(PitchCalculator.frequencyToOctave(-1), isNull);
      expect(
        PitchCalculator.centDifference(
          targetFrequencyHz: 440,
          detectedFrequencyHz: 0,
        ),
        isNull,
      );
      expect(
        PitchCalculator.centDifference(
          targetFrequencyHz: -440,
          detectedFrequencyHz: 438,
        ),
        isNull,
      );
    });

    test('one octave contains 7 white keys and 5 black keys', () {
      expect(PianoKeyboardLayout.whiteKeysForOctave(4), hasLength(7));
      expect(PianoKeyboardLayout.blackKeysForOctave(4), hasLength(5));
    });

    test('octave is clamped inside C2 to B6 range', () {
      expect(PianoNoteRange.c2ToB6.clampOctave(1), 2);
      expect(PianoNoteRange.c2ToB6.clampOctave(4), 4);
      expect(PianoNoteRange.c2ToB6.clampOctave(7), 6);
    });
  });
}
