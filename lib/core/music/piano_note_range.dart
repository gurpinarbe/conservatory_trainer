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
}
