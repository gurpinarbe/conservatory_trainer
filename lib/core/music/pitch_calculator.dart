import 'dart:math' as math;

import 'music_note.dart';
import 'pitch_result_state.dart';

abstract final class PitchCalculator {
  static const double referenceFrequencyHz = 440.0;
  static const int referenceMidiNoteNumber = 69;

  static const List<PitchClass> _pitchClasses = <PitchClass>[
    PitchClass.c,
    PitchClass.cSharp,
    PitchClass.d,
    PitchClass.dSharp,
    PitchClass.e,
    PitchClass.f,
    PitchClass.fSharp,
    PitchClass.g,
    PitchClass.gSharp,
    PitchClass.a,
    PitchClass.aSharp,
    PitchClass.b,
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

    final PitchClass pitchClass = _pitchClasses[midiNoteNumber % 12];
    final int octave = (midiNoteNumber ~/ 12) - 1;

    return MusicNote(
      midiNoteNumber: midiNoteNumber,
      pitchClass: pitchClass,
      octave: octave,
      frequencyHz: midiToFrequency(midiNoteNumber)!,
      accidental: pitchClass.accidental,
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
    final MusicNote? note = midiToNote(midiNoteNumber);
    if (note == null) {
      return null;
    }

    return switch (note.pitchClass) {
      PitchClass.c => 'C',
      PitchClass.cSharp => 'C♯',
      PitchClass.d => 'D',
      PitchClass.dSharp => 'D♯',
      PitchClass.e => 'E',
      PitchClass.f => 'F',
      PitchClass.fSharp => 'F♯',
      PitchClass.g => 'G',
      PitchClass.gSharp => 'G♯',
      PitchClass.a => 'A',
      PitchClass.aSharp => 'A♯',
      PitchClass.b => 'B',
    };
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
    if (centDifference < 0) {
      return PitchResultState.flat;
    }
    if (centDifference > 0) {
      return PitchResultState.sharp;
    }
    return PitchResultState.correct;
  }

  static bool _isValidFrequency(double frequencyHz) {
    return frequencyHz.isFinite && frequencyHz > 0;
  }

  static bool _isValidMidiNoteNumber(int midiNoteNumber) {
    return midiNoteNumber >= 0 && midiNoteNumber <= 127;
  }
}
