class PianoNoteRange {
  const PianoNoteRange({
    required this.startMidiNoteNumber,
    required this.endMidiNoteNumber,
  }) : assert(startMidiNoteNumber <= endMidiNoteNumber);

  static const PianoNoteRange c2ToB6 = PianoNoteRange(
    startMidiNoteNumber: 36,
    endMidiNoteNumber: 95,
  );

  final int startMidiNoteNumber;
  final int endMidiNoteNumber;

  int get minOctave => (startMidiNoteNumber ~/ 12) - 1;

  int get maxOctave => (endMidiNoteNumber ~/ 12) - 1;

  bool containsMidiNoteNumber(int midiNoteNumber) {
    return midiNoteNumber >= startMidiNoteNumber &&
        midiNoteNumber <= endMidiNoteNumber;
  }

  int clampOctave(int octave) {
    if (octave < minOctave) {
      return minOctave;
    }
    if (octave > maxOctave) {
      return maxOctave;
    }
    return octave;
  }

  int maxStartOctave({int visibleOctaveCount = 2}) {
    final int safeVisibleOctaveCount = visibleOctaveCount < 1
        ? 1
        : visibleOctaveCount;
    final int computedMax = maxOctave - safeVisibleOctaveCount + 1;
    return computedMax < minOctave ? minOctave : computedMax;
  }

  int clampVisibleStartOctave(int octave, {int visibleOctaveCount = 2}) {
    final int safeMaxStartOctave = maxStartOctave(
      visibleOctaveCount: visibleOctaveCount,
    );

    if (octave < minOctave) {
      return minOctave;
    }
    if (octave > safeMaxStartOctave) {
      return safeMaxStartOctave;
    }
    return octave;
  }
}
