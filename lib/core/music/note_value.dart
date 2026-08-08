enum NoteValue {
  whole(sixteenthUnits: 16),
  half(sixteenthUnits: 8),
  quarter(sixteenthUnits: 4),
  eighth(sixteenthUnits: 2),
  sixteenth(sixteenthUnits: 1),
  dottedHalf(sixteenthUnits: 12),
  dottedQuarter(sixteenthUnits: 6),
  dottedEighth(sixteenthUnits: 3);

  const NoteValue({required this.sixteenthUnits});

  final int sixteenthUnits;

  bool get isDotted => switch (this) {
    NoteValue.dottedHalf ||
    NoteValue.dottedQuarter ||
    NoteValue.dottedEighth => true,
    _ => false,
  };

  double get beatsInFourFour => sixteenthUnits / 4;

  Duration durationAtBpm(int bpm) {
    final double quarterSeconds = 60 / bpm;
    final int milliseconds = (quarterSeconds * beatsInFourFour * 1000).round();
    return Duration(milliseconds: milliseconds);
  }
}
