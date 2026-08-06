enum NoteValue {
  whole(
    sixteenthUnits: 16,
    turkishName: 'Birlik nota',
    description: '4 vuruş sürer.',
  ),
  half(
    sixteenthUnits: 8,
    turkishName: 'İkilik nota',
    description: '2 vuruş sürer.',
  ),
  quarter(
    sixteenthUnits: 4,
    turkishName: 'Dörtlük nota',
    description: '1 vuruş sürer.',
  ),
  eighth(
    sixteenthUnits: 2,
    turkishName: 'Sekizlik nota',
    description: 'Yarım vuruş sürer.',
  ),
  sixteenth(
    sixteenthUnits: 1,
    turkishName: 'On altılık nota',
    description: 'Çeyrek vuruş sürer.',
  ),
  dottedHalf(
    sixteenthUnits: 12,
    turkishName: 'Noktalı ikilik',
    description: '3 vuruş sürer.',
  ),
  dottedQuarter(
    sixteenthUnits: 6,
    turkishName: 'Noktalı dörtlük',
    description: '1.5 vuruş sürer.',
  ),
  dottedEighth(
    sixteenthUnits: 3,
    turkishName: 'Noktalı sekizlik',
    description: '0.75 vuruş sürer.',
  );

  const NoteValue({
    required this.sixteenthUnits,
    required this.turkishName,
    required this.description,
  });

  final int sixteenthUnits;
  final String turkishName;
  final String description;

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
