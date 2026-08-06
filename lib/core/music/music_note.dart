import 'music_accidental.dart';

class MusicNote {
  const MusicNote({
    required this.midiNoteNumber,
    required this.noteName,
    required this.turkishNoteName,
    required this.octave,
    required this.frequencyHz,
    required this.isBlackKey,
    required this.accidental,
  });

  final int midiNoteNumber;
  final String noteName;
  final String turkishNoteName;
  final int octave;
  final double frequencyHz;
  final bool isBlackKey;
  final MusicAccidental accidental;

  String get scientificName => '$noteName$octave';

  String get turkishScientificName => '$turkishNoteName$octave';

  String get accessibilityLabel => '$turkishScientificName tuşu';

  String get naturalNoteName =>
      noteName.replaceAll('#', '').replaceAll('b', '');

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
        other.noteName == noteName &&
        other.turkishNoteName == turkishNoteName &&
        other.octave == octave &&
        other.frequencyHz == frequencyHz &&
        other.isBlackKey == isBlackKey &&
        other.accidental == accidental;
  }

  @override
  int get hashCode => Object.hash(
    midiNoteNumber,
    noteName,
    turkishNoteName,
    octave,
    frequencyHz,
    isBlackKey,
    accidental,
  );
}
