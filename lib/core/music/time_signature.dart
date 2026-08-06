class TimeSignature {
  const TimeSignature({required this.numerator, required this.denominator});

  const TimeSignature.twoFour() : this(numerator: 2, denominator: 4);
  const TimeSignature.threeFour() : this(numerator: 3, denominator: 4);
  const TimeSignature.fourFour() : this(numerator: 4, denominator: 4);
  const TimeSignature.sixEight() : this(numerator: 6, denominator: 8);

  final int numerator;
  final int denominator;

  int get measureUnits =>
      numerator * _sixteenthUnitsForDenominator(denominator);

  String get label => '$numerator/$denominator';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TimeSignature &&
        other.numerator == numerator &&
        other.denominator == denominator;
  }

  @override
  int get hashCode => Object.hash(numerator, denominator);

  static int _sixteenthUnitsForDenominator(int denominator) {
    return switch (denominator) {
      1 => 16,
      2 => 8,
      4 => 4,
      8 => 2,
      16 => 1,
      _ => throw ArgumentError.value(
        denominator,
        'denominator',
        'Unsupported time signature denominator',
      ),
    };
  }
}
