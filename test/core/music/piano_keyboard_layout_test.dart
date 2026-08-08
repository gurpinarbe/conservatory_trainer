import 'package:conservatory_trainer/core/music/piano_keyboard_layout.dart';
import 'package:conservatory_trainer/core/music/piano_note_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('C2 to B6 range is computed correctly', () {
    expect(PianoKeyboardLayout.supportedRange, PianoNoteRange.c2ToB6);
    expect(PianoKeyboardLayout.supportedRange.startMidiNoteNumber, 36);
    expect(PianoKeyboardLayout.supportedRange.endMidiNoteNumber, 95);
    expect(PianoKeyboardLayout.supportedRange.minOctave, 2);
    expect(PianoKeyboardLayout.supportedRange.maxOctave, 6);
  });

  test('visible two-octave range stays inside C2 and B6', () {
    final PianoNoteRange minRange =
        PianoKeyboardLayout.visibleRangeForOctaveStart(1);
    final PianoNoteRange maxRange =
        PianoKeyboardLayout.visibleRangeForOctaveStart(6);

    expect(minRange.startMidiNoteNumber, 36);
    expect(minRange.endMidiNoteNumber, 59);
    expect(maxRange.startMidiNoteNumber, 72);
    expect(maxRange.endMidiNoteNumber, 95);
  });
}
