import 'package:conservatory_trainer/app/note_naming_controller.dart';
import 'package:conservatory_trainer/core/audio/piano_audio_service.dart';
import 'package:conservatory_trainer/core/music/note_naming_system.dart';
import 'package:conservatory_trainer/features/free_practice/presentation/free_piano_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_virtual_piano/flutter_virtual_piano.dart';

import '../../../test_helpers/test_support.dart';

void main() {
  testWidgets('free piano starts with C4 to B5 visible', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    final VirtualPiano piano = tester.widget(find.byType(VirtualPiano));
    expect(piano.noteRange.start, 60);
    expect(piano.noteRange.end, 83);
    expect(find.text('4-5. Oktav'), findsOneWidget);
  });

  testWidgets('next and previous octave buttons stay inside C2 to B6', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey<String>('free-piano-next-octave')),
    );
    await tester.pumpAndSettle();

    VirtualPiano piano = tester.widget(find.byType(VirtualPiano));
    expect(piano.noteRange.start, 72);
    expect(piano.noteRange.end, 95);
    expect(find.text('5-6. Oktav'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('free-piano-next-octave')),
    );
    await tester.pumpAndSettle();

    piano = tester.widget(find.byType(VirtualPiano));
    expect(piano.noteRange.start, 72);
    expect(piano.noteRange.end, 95);

    await tester.tap(
      find.byKey(const ValueKey<String>('free-piano-prev-octave')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('free-piano-prev-octave')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('free-piano-prev-octave')),
    );
    await tester.pumpAndSettle();

    piano = tester.widget(find.byType(VirtualPiano));
    expect(piano.noteRange.start, 36);
    expect(piano.noteRange.end, 59);
    expect(find.text('2-3. Oktav'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('free-piano-prev-octave')),
    );
    await tester.pumpAndSettle();

    piano = tester.widget(find.byType(VirtualPiano));
    expect(piano.noteRange.start, 36);
    expect(piano.noteRange.end, 59);
  });

  testWidgets(
    'pressing and releasing C4 calls note on and note off for MIDI 60',
    (WidgetTester tester) async {
      final FakePianoAudioService pianoAudioService = FakePianoAudioService();
      await tester.pumpWidget(
        _buildTestApp(pianoAudioService: pianoAudioService),
      );
      await tester.pumpAndSettle();

      final TestGesture gesture = await _startGestureOnMidiKey(tester, 60);
      await tester.pump();

      expect(pianoAudioService.playedMidiNotes, contains(60));
      expect(pianoAudioService.activeMidiNotes, contains(60));

      await gesture.up();
      await tester.pump();

      expect(pianoAudioService.stoppedMidiNotes, contains(60));
      expect(pianoAudioService.activeMidiNotes, isNot(contains(60)));
    },
  );

  testWidgets('C4, E4 and G4 can stay active at the same time', (
    WidgetTester tester,
  ) async {
    final FakePianoAudioService pianoAudioService = FakePianoAudioService();
    await tester.pumpWidget(
      _buildTestApp(pianoAudioService: pianoAudioService),
    );
    await tester.pumpAndSettle();

    final TestGesture c4 = await _startGestureOnMidiKey(tester, 60);
    final TestGesture e4 = await _startGestureOnMidiKey(tester, 64);
    final TestGesture g4 = await _startGestureOnMidiKey(tester, 67);
    await tester.pump();

    expect(pianoAudioService.activeMidiNotes, equals(const <int>{60, 64, 67}));
    expect(
      pianoAudioService.playedMidiNotes,
      containsAll(const <int>[60, 64, 67]),
    );

    await c4.up();
    await e4.up();
    await g4.up();
    await tester.pump();
  });

  testWidgets('stop all clears active notes and turns sustain off', (
    WidgetTester tester,
  ) async {
    final FakePianoAudioService pianoAudioService = FakePianoAudioService();
    await tester.pumpWidget(
      _buildTestApp(pianoAudioService: pianoAudioService),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey<String>('free-piano-sustain-switch')),
    );
    await tester.pumpAndSettle();
    expect(pianoAudioService.isSustainEnabled, isTrue);

    final TestGesture c4 = await _startGestureOnMidiKey(tester, 60);
    final TestGesture e4 = await _startGestureOnMidiKey(tester, 64);
    await tester.pump();
    expect(pianoAudioService.activeMidiNotes, equals(const <int>{60, 64}));

    await tester.tap(find.byKey(const ValueKey<String>('free-piano-stop-all')));
    await tester.pumpAndSettle();

    expect(pianoAudioService.stopAllCallCount, greaterThan(0));
    expect(pianoAudioService.activeMidiNotes, isEmpty);
    expect(pianoAudioService.isSustainEnabled, isFalse);

    await c4.up();
    await e4.up();
    await tester.pump();
  });

  testWidgets('changing octave stops open notes first', (
    WidgetTester tester,
  ) async {
    final FakePianoAudioService pianoAudioService = FakePianoAudioService();
    await tester.pumpWidget(
      _buildTestApp(pianoAudioService: pianoAudioService),
    );
    await tester.pumpAndSettle();

    final TestGesture gesture = await _startGestureOnMidiKey(tester, 60);
    await tester.pump();
    expect(pianoAudioService.activeMidiNotes, contains(60));

    await tester.tap(
      find.byKey(const ValueKey<String>('free-piano-next-octave')),
    );
    await tester.pumpAndSettle();

    expect(pianoAudioService.stopAllCallCount, greaterThan(0));
    expect(pianoAudioService.activeMidiNotes, isEmpty);

    final VirtualPiano piano = tester.widget(find.byType(VirtualPiano));
    expect(piano.noteRange.start, 72);
    expect(piano.noteRange.end, 95);

    await gesture.up();
    await tester.pump();
  });

  testWidgets('C major demo highlights and plays the same notes', (
    WidgetTester tester,
  ) async {
    final FakePianoAudioService pianoAudioService = FakePianoAudioService();
    await tester.pumpWidget(
      _buildTestApp(pianoAudioService: pianoAudioService),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey<String>('free-piano-demo-c-major')),
    );
    await tester.pump();

    final VirtualPiano playingPiano = tester.widget(find.byType(VirtualPiano));
    final List<HighlightedNoteSet> highlightedNoteSets =
        playingPiano.highlightedNoteSets ?? const <HighlightedNoteSet>[];

    expect(
      highlightedNoteSets.any(
        (HighlightedNoteSet set) =>
            set.noteValues.containsAll(const <int>{60, 64, 67}),
      ),
      isTrue,
    );
    expect(
      pianoAudioService.playedChords.any(
        (Set<int> chord) => chord.containsAll(const <int>{60, 64, 67}),
      ),
      isTrue,
    );

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    final VirtualPiano idlePiano = tester.widget(find.byType(VirtualPiano));
    final List<HighlightedNoteSet> clearedSets =
        idlePiano.highlightedNoteSets ?? const <HighlightedNoteSet>[];

    expect(
      clearedSets.any((HighlightedNoteSet set) => set.noteValues.contains(60)),
      isFalse,
    );
  });

  testWidgets(
    'note labels follow the selected naming system and can be hidden',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildTestApp(noteNamingSystem: NoteNamingSystem.fixedDo),
      );
      await tester.pumpAndSettle();

      expect(find.text('Do4'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey<String>('free-piano-show-note-names')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Do4'), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        _buildTestApp(noteNamingSystem: NoteNamingSystem.letterNames),
      );
      await tester.pumpAndSettle();

      expect(find.text('C4'), findsOneWidget);
    },
  );

  testWidgets(
    'piano key semantics are localized and use readable accidentals',
    (WidgetTester tester) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          _buildTestApp(
            locale: const Locale('en'),
            noteNamingSystem: NoteNamingSystem.letterNames,
          ),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(
          find.byKey(const ValueKey<String>('piano-key-hitbox-69')),
        );
        await tester.pumpAndSettle();

        expect(
          tester.getSemantics(
            find.byKey(const ValueKey<String>('piano-key-hitbox-69')),
          ),
          matchesSemantics(label: 'A 4 piano key', isButton: true),
        );
        await tester.ensureVisible(
          find.byKey(const ValueKey<String>('piano-key-hitbox-61')),
        );
        await tester.pumpAndSettle();
        expect(
          tester.getSemantics(
            find.byKey(const ValueKey<String>('piano-key-hitbox-61')),
          ),
          matchesSemantics(label: 'C sharp 4 piano key', isButton: true),
        );

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();

        await tester.pumpWidget(
          _buildTestApp(
            locale: const Locale('tr'),
            noteNamingSystem: NoteNamingSystem.fixedDo,
          ),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(
          find.byKey(const ValueKey<String>('piano-key-hitbox-69')),
        );
        await tester.pumpAndSettle();

        expect(
          tester.getSemantics(
            find.byKey(const ValueKey<String>('piano-key-hitbox-69')),
          ),
          matchesSemantics(label: 'La 4 piyano tuşu', isButton: true),
        );
        await tester.ensureVisible(
          find.byKey(const ValueKey<String>('piano-key-hitbox-61')),
        );
        await tester.pumpAndSettle();
        expect(
          tester.getSemantics(
            find.byKey(const ValueKey<String>('piano-key-hitbox-61')),
          ),
          matchesSemantics(label: 'Do diyez 4 piyano tuşu', isButton: true),
        );
      } finally {
        semantics.dispose();
      }
    },
  );
}

Widget _buildTestApp({
  Locale locale = const Locale('tr'),
  NoteNamingSystem noteNamingSystem = NoteNamingSystem.fixedDo,
  PianoAudioService? pianoAudioService,
}) {
  return ProviderScope(
    overrides: <Override>[
      noteNamingControllerProvider.overrideWith(
        () => TestNoteNamingController(noteNamingSystem),
      ),
      ...testAudioOverrides(pianoAudioService: pianoAudioService),
    ],
    child: buildLocalizedMaterialApp(const FreePianoScreen(), locale: locale),
  );
}

Future<TestGesture> _startGestureOnMidiKey(
  WidgetTester tester,
  int midiNote,
) async {
  final Finder keyHitbox = find.byKey(
    ValueKey<String>('piano-key-hitbox-$midiNote'),
  );

  await tester.ensureVisible(keyHitbox);
  final Offset center = tester.getCenter(keyHitbox, warnIfMissed: true);
  return tester.startGesture(center);
}
