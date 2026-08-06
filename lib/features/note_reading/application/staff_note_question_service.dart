import 'dart:math';

import '../../../core/music/measure.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/notation_event.dart';
import '../../../core/music/notation_sequence.dart';
import '../../../core/music/note_value.dart';
import '../../../core/music/pitch_calculator.dart';
import '../../../core/music/time_signature.dart';
import '../domain/staff_note_question.dart';

class StaffNoteQuestionService {
  StaffNoteQuestionService({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const List<int> _supportedMidiNotes = <int>[
    60,
    62,
    64,
    65,
    67,
    69,
    71,
    72,
  ];

  StaffNoteQuestion generateQuestion() {
    final List<MusicNote> availableNotes = _supportedMidiNotes
        .map(
          (int midiNoteNumber) => PitchCalculator.midiToNote(midiNoteNumber)!,
        )
        .toList(growable: false);
    final MusicNote targetNote =
        availableNotes[_random.nextInt(availableNotes.length)];
    final List<MusicNote> distractors =
        availableNotes
            .where(
              (MusicNote note) =>
                  note.midiNoteNumber != targetNote.midiNoteNumber,
            )
            .toList()
          ..shuffle(_random);
    final List<MusicNote> options = <MusicNote>[
      targetNote,
      ...distractors.take(3),
    ]..shuffle(_random);

    return StaffNoteQuestion(
      targetNote: targetNote,
      options: options,
      sequence: NotationSequence(
        measures: <Measure>[
          Measure(
            index: 0,
            timeSignature: const TimeSignature.fourFour(),
            events: <NotationEvent>[
              NoteEvent(
                note: targetNote,
                id: 'staff-note-question',
                noteValue: NoteValue.whole,
                startUnits: 0,
                measureIndex: 0,
                accidental: targetNote.accidental,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
