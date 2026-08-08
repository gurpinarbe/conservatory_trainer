import '../../../core/music/measure.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/notation_event.dart';
import '../../../core/music/notation_sequence.dart';
import '../../../core/music/note_value.dart';
import '../../../core/music/pitch_calculator.dart';
import '../../../core/music/time_signature.dart';
import '../domain/single_note_exercise_snapshot.dart';

class SingleNotePreviewService {
  const SingleNotePreviewService();

  static const double _targetFrequencyHz = 440.0;
  static const double _detectedFrequencyHz = 438.2;

  SingleNoteExerciseSnapshot buildSnapshot() {
    final MusicNote targetNote = _noteFromFrequency(_targetFrequencyHz);
    final MusicNote detectedNote = _noteFromFrequency(_detectedFrequencyHz);
    final double centDifference =
        PitchCalculator.centDifference(
          targetFrequencyHz: _targetFrequencyHz,
          detectedFrequencyHz: _detectedFrequencyHz,
        ) ??
        0;

    return SingleNoteExerciseSnapshot(
      targetNote: targetNote,
      detectedNote: detectedNote,
      centDifference: centDifference,
      resultState: PitchCalculator.classifyCentDifference(centDifference),
    );
  }

  List<MusicNote> buildDevelopmentDemoNotes() {
    return <MusicNote>[_noteFromMidi(60), _noteFromMidi(64), _noteFromMidi(67)];
  }

  NotationSequence buildListenSequence() {
    final MusicNote note = _noteFromMidi(69);

    return NotationSequence(
      measures: <Measure>[
        Measure(
          index: 0,
          timeSignature: const TimeSignature.fourFour(),
          events: <NotationEvent>[
            NoteEvent(
              note: note,
              id: 'listen-la4',
              noteValue: NoteValue.quarter,
              startUnits: 0,
              measureIndex: 0,
              accidental: note.accidental,
            ),
          ],
        ),
      ],
    );
  }

  NotationSequence buildDevelopmentDemoSequence() {
    final MusicNote c4 = _noteFromMidi(60);
    final MusicNote e4 = _noteFromMidi(64);
    final MusicNote g4 = _noteFromMidi(67);

    return NotationSequence(
      measures: <Measure>[
        Measure(
          index: 0,
          timeSignature: const TimeSignature.fourFour(),
          events: <NotationEvent>[
            NoteEvent(
              note: c4,
              id: 'demo-c4',
              noteValue: NoteValue.quarter,
              startUnits: 0,
              measureIndex: 0,
              accidental: c4.accidental,
            ),
            NoteEvent(
              note: e4,
              id: 'demo-e4',
              noteValue: NoteValue.quarter,
              startUnits: 4,
              measureIndex: 0,
              accidental: e4.accidental,
            ),
            NoteEvent(
              note: g4,
              id: 'demo-g4',
              noteValue: NoteValue.half,
              startUnits: 8,
              measureIndex: 0,
              accidental: g4.accidental,
            ),
          ],
        ),
      ],
    );
  }

  MusicNote _noteFromFrequency(double frequencyHz) {
    return PitchCalculator.frequencyToNote(frequencyHz)!;
  }

  MusicNote _noteFromMidi(int midiNoteNumber) {
    return PitchCalculator.midiToNote(midiNoteNumber)!;
  }
}
