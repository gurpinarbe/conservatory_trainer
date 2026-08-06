import 'dart:math' as math;

import 'music_accidental.dart';
import 'music_note.dart';
import 'pitch_result_state.dart';

abstract final class PitchCalculator {
  static const double referenceFrequencyHz = 440.0;
  static const int referenceMidiNoteNumber = 69;

  static const List<String> _noteNames = <String>[
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  static const List<String> _turkishNoteNames = <String>[
    'Do',
    'Do diyez',
    'Re',
    'Re diyez',
    'Mi',
    'Fa',
    'Fa diyez',
    'Sol',
    'Sol diyez',
    'La',
    'La diyez',
    'Si',
  ];

  static int? frequencyToNearestMidiNoteNumber(double frequencyHz) {
    if (!_isValidFrequency(frequencyHz)) {
      return null;
    }

    final double semitoneOffset =
        12 * math.log(frequencyHz / referenceFrequencyHz) / math.ln2;
    final int midiNoteNumber = (referenceMidiNoteNumber + semitoneOffset)
        .round();

    if (!_isValidMidiNoteNumber(midiNoteNumber)) {
      return null;
    }

    return midiNoteNumber;
  }

  static MusicNote? frequencyToNote(double frequencyHz) {
    final int? midiNoteNumber = frequencyToNearestMidiNoteNumber(frequencyHz);
    if (midiNoteNumber == null) {
      return null;
    }

    return midiToNote(midiNoteNumber);
  }

  static MusicNote? midiToNote(int midiNoteNumber) {
    if (!_isValidMidiNoteNumber(midiNoteNumber)) {
      return null;
    }

    final int noteIndex = midiNoteNumber % 12;
    final int octave = (midiNoteNumber ~/ 12) - 1;
    final String noteName = _noteNames[noteIndex];

    return MusicNote(
      midiNoteNumber: midiNoteNumber,
      noteName: noteName,
      turkishNoteName: _turkishNoteNames[noteIndex],
      octave: octave,
      frequencyHz: midiToFrequency(midiNoteNumber)!,
      isBlackKey: noteName.contains('#'),
      accidental: noteName.contains('#')
          ? MusicAccidental.sharp
          : MusicAccidental.natural,
    );
  }

  static double? midiToFrequency(int midiNoteNumber) {
    if (!_isValidMidiNoteNumber(midiNoteNumber)) {
      return null;
    }

    final double semitoneOffset =
        (midiNoteNumber - referenceMidiNoteNumber) / 12;
    return referenceFrequencyHz * math.pow(2, semitoneOffset);
  }

  static String? midiToNoteName(int midiNoteNumber) {
    return midiToNote(midiNoteNumber)?.noteName;
  }

  static String? midiToTurkishNoteName(int midiNoteNumber) {
    return midiToNote(midiNoteNumber)?.turkishNoteName;
  }

  static int? frequencyToOctave(double frequencyHz) {
    return frequencyToNote(frequencyHz)?.octave;
  }

  static double? centDifference({
    required double targetFrequencyHz,
    required double detectedFrequencyHz,
  }) {
    if (!_isValidFrequency(targetFrequencyHz) ||
        !_isValidFrequency(detectedFrequencyHz)) {
      return null;
    }

    return 1200 * math.log(detectedFrequencyHz / targetFrequencyHz) / math.ln2;
  }

  static PitchResultState classifyCentDifference(double centDifference) {
    if (centDifference < -15) {
      return PitchResultState.flat;
    }
    if (centDifference > 15) {
      return PitchResultState.sharp;
    }
    return PitchResultState.correct;
  }

  static String describeCentDifference(double centDifference) {
    if (centDifference < 0) {
      return 'Biraz pes';
    }
    if (centDifference > 0) {
      return 'Biraz tiz';
    }
    return 'Doğru';
  }

  static bool _isValidFrequency(double frequencyHz) {
    return frequencyHz.isFinite && frequencyHz > 0;
  }

  static bool _isValidMidiNoteNumber(int midiNoteNumber) {
    return midiNoteNumber >= 0 && midiNoteNumber <= 127;
  }
}
