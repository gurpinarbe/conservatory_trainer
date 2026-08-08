import 'music_note.dart';
import 'piano_note_range.dart';
import 'pitch_calculator.dart';

abstract final class PianoKeyboardLayout {
  static const PianoNoteRange supportedRange = PianoNoteRange.c2ToB6;

  static List<MusicNote> notesForRange({
    PianoNoteRange range = supportedRange,
  }) {
    final List<MusicNote> notes = <MusicNote>[];

    for (
      int midiNoteNumber = range.startMidiNoteNumber;
      midiNoteNumber <= range.endMidiNoteNumber;
      midiNoteNumber++
    ) {
      final MusicNote? note = PitchCalculator.midiToNote(midiNoteNumber);
      if (note != null) {
        notes.add(note);
      }
    }

    return notes;
  }

  static List<MusicNote> notesForOctave(
    int octave, {
    PianoNoteRange range = supportedRange,
  }) {
    return notesForRange(
      range: range,
    ).where((MusicNote note) => note.octave == octave).toList();
  }

  static List<MusicNote> whiteKeysForOctave(
    int octave, {
    PianoNoteRange range = supportedRange,
  }) {
    return notesForOctave(
      octave,
      range: range,
    ).where((MusicNote note) => !note.isBlackKey).toList();
  }

  static List<MusicNote> blackKeysForOctave(
    int octave, {
    PianoNoteRange range = supportedRange,
  }) {
    return notesForOctave(
      octave,
      range: range,
    ).where((MusicNote note) => note.isBlackKey).toList();
  }

  static List<MusicNote> whiteKeysForRange({
    PianoNoteRange range = supportedRange,
  }) {
    return notesForRange(
      range: range,
    ).where((MusicNote note) => !note.isBlackKey).toList();
  }

  static int octaveForHighlightedNotes(
    Iterable<int> midiNoteNumbers, {
    PianoNoteRange range = supportedRange,
    int fallbackOctave = 4,
  }) {
    final List<int> visibleNotes =
        midiNoteNumbers.where(range.containsMidiNoteNumber).toList()..sort();

    if (visibleNotes.isEmpty) {
      return range.clampOctave(fallbackOctave);
    }

    final MusicNote? note = PitchCalculator.midiToNote(visibleNotes.first);
    return range.clampOctave(note?.octave ?? fallbackOctave);
  }

  static PianoNoteRange visibleRangeForOctaveStart(
    int startOctave, {
    PianoNoteRange range = supportedRange,
    int visibleOctaveCount = 2,
  }) {
    final int clampedStartOctave = range.clampVisibleStartOctave(
      startOctave,
      visibleOctaveCount: visibleOctaveCount,
    );
    final int startMidiNoteNumber = ((clampedStartOctave + 1) * 12)
        .clamp(range.startMidiNoteNumber, range.endMidiNoteNumber)
        .toInt();
    final int endOctave =
        clampedStartOctave +
        (visibleOctaveCount < 1 ? 1 : visibleOctaveCount) -
        1;
    final int endMidiNoteNumber = (((endOctave + 1) * 12) + 11)
        .clamp(range.startMidiNoteNumber, range.endMidiNoteNumber)
        .toInt();

    return PianoNoteRange(
      startMidiNoteNumber: startMidiNoteNumber,
      endMidiNoteNumber: endMidiNoteNumber,
    );
  }

  static int startOctaveForHighlightedNotes(
    Iterable<int> midiNoteNumbers, {
    PianoNoteRange range = supportedRange,
    int fallbackOctave = 4,
    int visibleOctaveCount = 2,
  }) {
    final List<int> visibleNotes =
        midiNoteNumbers.where(range.containsMidiNoteNumber).toList()..sort();

    if (visibleNotes.isEmpty) {
      return range.clampVisibleStartOctave(
        fallbackOctave,
        visibleOctaveCount: visibleOctaveCount,
      );
    }

    final MusicNote? note = PitchCalculator.midiToNote(visibleNotes.first);
    return range.clampVisibleStartOctave(
      note?.octave ?? fallbackOctave,
      visibleOctaveCount: visibleOctaveCount,
    );
  }
}
