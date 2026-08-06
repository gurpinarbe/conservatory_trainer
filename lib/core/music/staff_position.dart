class StaffPosition {
  const StaffPosition({required this.stepsFromBottomLine});

  final int stepsFromBottomLine;

  int get ledgerLinesBelow {
    if (stepsFromBottomLine >= 0) {
      return 0;
    }
    return ((-stepsFromBottomLine) + 1) ~/ 2;
  }

  int get ledgerLinesAbove {
    if (stepsFromBottomLine <= 8) {
      return 0;
    }
    return (stepsFromBottomLine - 7) ~/ 2;
  }
}
