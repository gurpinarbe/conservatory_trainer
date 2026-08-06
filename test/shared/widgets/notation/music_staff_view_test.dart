import 'package:conservatory_trainer/core/music/measure.dart';
import 'package:conservatory_trainer/core/music/music_clef.dart';
import 'package:conservatory_trainer/core/music/notation_event.dart';
import 'package:conservatory_trainer/core/music/notation_sequence.dart';
import 'package:conservatory_trainer/core/music/note_value.dart';
import 'package:conservatory_trainer/core/music/pitch_calculator.dart';
import 'package:conservatory_trainer/core/music/time_signature.dart';
import 'package:conservatory_trainer/shared/widgets/notation/music_staff_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('active notation highlight changes with the active note', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        MusicStaffView(
          sequence: _sequenceFor(
            id: 'first',
            midiNoteNumber: 69,
            visualState: NotationEventVisualState.active,
          ),
          clef: MusicClef.treble,
          showActiveHighlights: true,
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('staff-highlight-first')),
      findsOneWidget,
    );

    await tester.pumpWidget(
      _wrap(
        MusicStaffView(
          sequence: _sequenceFor(
            id: 'second',
            midiNoteNumber: 72,
            visualState: NotationEventVisualState.active,
          ),
          clef: MusicClef.treble,
          showActiveHighlights: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('staff-highlight-first')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('staff-highlight-second')),
      findsOneWidget,
    );
  });

  testWidgets('high ledger notes render without overflow exceptions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        MusicStaffView(
          sequence: NotationSequence(
            measures: <Measure>[
              Measure(
                index: 0,
                timeSignature: const TimeSignature.fourFour(),
                events: <NotationEvent>[
                  _noteEvent(
                    id: 'low-c4',
                    midiNoteNumber: 60,
                    startUnits: 0,
                    noteValue: NoteValue.quarter,
                  ),
                  _noteEvent(
                    id: 'high-c6',
                    midiNoteNumber: 84,
                    startUnits: 4,
                    noteValue: NoteValue.quarter,
                  ),
                ],
              ),
            ],
          ),
          clef: MusicClef.treble,
          showActiveHighlights: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('staff-event-high-c6')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(width: 360, child: child),
      ),
    ),
  );
}

NotationSequence _sequenceFor({
  required String id,
  required int midiNoteNumber,
  required NotationEventVisualState visualState,
}) {
  return NotationSequence(
    measures: <Measure>[
      Measure(
        index: 0,
        timeSignature: const TimeSignature.fourFour(),
        events: <NotationEvent>[
          _noteEvent(
            id: id,
            midiNoteNumber: midiNoteNumber,
            startUnits: 0,
            noteValue: NoteValue.whole,
            visualState: visualState,
          ),
        ],
      ),
    ],
  );
}

NoteEvent _noteEvent({
  required String id,
  required int midiNoteNumber,
  required int startUnits,
  required NoteValue noteValue,
  NotationEventVisualState visualState = NotationEventVisualState.normal,
}) {
  final note = PitchCalculator.midiToNote(midiNoteNumber)!;

  return NoteEvent(
    note: note,
    id: id,
    noteValue: noteValue,
    startUnits: startUnits,
    measureIndex: 0,
    accidental: note.accidental,
    visualState: visualState,
  );
}
