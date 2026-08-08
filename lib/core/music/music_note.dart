import 'music_accidental.dart';

enum PitchClass { c, cSharp, d, dSharp, e, f, fSharp, g, gSharp, a, aSharp, b }

extension PitchClassX on PitchClass {
  bool get isBlackKey {
    return switch (this) {
      PitchClass.cSharp ||
      PitchClass.dSharp ||
      PitchClass.fSharp ||
      PitchClass.gSharp ||
      PitchClass.aSharp => true,
      _ => false,
    };
  }

  MusicAccidental get accidental {
    return switch (this) {
      PitchClass.cSharp ||
      PitchClass.dSharp ||
      PitchClass.fSharp ||
      PitchClass.gSharp ||
      PitchClass.aSharp => MusicAccidental.sharp,
      _ => MusicAccidental.natural,
    };
  }

  String get naturalNoteName {
    return switch (this) {
      PitchClass.c || PitchClass.cSharp => 'C',
      PitchClass.d || PitchClass.dSharp => 'D',
      PitchClass.e => 'E',
      PitchClass.f || PitchClass.fSharp => 'F',
      PitchClass.g || PitchClass.gSharp => 'G',
      PitchClass.a || PitchClass.aSharp => 'A',
      PitchClass.b => 'B',
    };
  }
}

class MusicNote {
  const MusicNote({
    required this.midiNoteNumber,
    required this.pitchClass,
    required this.octave,
    required this.frequencyHz,
    required this.accidental,
  });

  final int midiNoteNumber;
  final PitchClass pitchClass;
  final int octave;
  final double frequencyHz;
  final MusicAccidental accidental;

  bool get isBlackKey => pitchClass.isBlackKey;

  String get naturalNoteName => pitchClass.naturalNoteName;

  int get diatonicIndex =>
      (octave * 7) + _stepIndexForNaturalName(naturalNoteName);

  static int _stepIndexForNaturalName(String naturalNoteName) {
    return switch (naturalNoteName) {
      'C' => 0,
      'D' => 1,
      'E' => 2,
      'F' => 3,
      'G' => 4,
      'A' => 5,
      'B' => 6,
      _ => throw ArgumentError.value(
        naturalNoteName,
        'naturalNoteName',
        'Unsupported note name',
      ),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is MusicNote &&
        other.midiNoteNumber == midiNoteNumber &&
        other.pitchClass == pitchClass &&
        other.octave == octave &&
        other.frequencyHz == frequencyHz &&
        other.accidental == accidental;
  }

  @override
  int get hashCode =>
      Object.hash(midiNoteNumber, pitchClass, octave, frequencyHz, accidental);
}
