import 'package:conservatory_trainer/shared/widgets/piano/piano_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_virtual_piano/flutter_virtual_piano.dart';

import '../../test_helpers/test_support.dart';

void main() {
  testWidgets('piano panel opens and closes', (WidgetTester tester) async {
    await tester.pumpWidget(_wrapWithMaterial(_buildPanel()));

    expect(find.text('Piyanoyu Aç'), findsOneWidget);
    expect(find.text('Piyanoyu Kapat'), findsNothing);

    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    expect(find.text('Piyanoyu Kapat'), findsOneWidget);
    expect(find.text('4. Oktav'), findsOneWidget);
    expect(find.text('La4 Göster ve Çal'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    expect(find.text('Piyanoyu Aç'), findsOneWidget);
    expect(find.byType(VirtualPiano), findsNothing);
  });

  testWidgets('highlighted midi notes are forwarded to virtual piano', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithMaterial(_buildPanel(highlightedMidiNotes: const <int>{69, 72})),
    );

    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    final VirtualPiano piano = tester.widget(find.byType(VirtualPiano));
    final List<HighlightedNoteSet> highlightedNoteSets =
        piano.highlightedNoteSets ?? const <HighlightedNoteSet>[];

    expect(
      highlightedNoteSets.any(
        (HighlightedNoteSet set) => set.noteValues.contains(69),
      ),
      isTrue,
    );
    expect(
      highlightedNoteSets.any(
        (HighlightedNoteSet set) => set.noteValues.contains(72),
      ),
      isTrue,
    );
  });

  testWidgets('highlight is hidden when show-notes option is off', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithMaterial(
        _buildPanel(
          highlightedMidiNotes: const <int>{69},
          showHighlightedMidiNotes: false,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    final VirtualPiano piano = tester.widget(find.byType(VirtualPiano));
    final List<HighlightedNoteSet> highlightedNoteSets =
        piano.highlightedNoteSets ?? const <HighlightedNoteSet>[];

    expect(
      highlightedNoteSets.any(
        (HighlightedNoteSet set) => set.noteValues.contains(69),
      ),
      isFalse,
    );
  });

  testWidgets('octave controls stay inside C2 and B6 range', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrapWithMaterial(_buildPanel()));

    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    final VirtualPiano initialPiano = tester.widget(find.byType(VirtualPiano));
    expect(initialPiano.noteRange.start, 60);
    expect(initialPiano.noteRange.end, 83);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-prev-octave')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-prev-octave')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-prev-octave')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-prev-octave')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-prev-octave')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-prev-octave')));
    await tester.pumpAndSettle();

    expect(find.text('2. Oktav'), findsOneWidget);
    final VirtualPiano minPiano = tester.widget(find.byType(VirtualPiano));
    expect(minPiano.noteRange.start, 36);
    expect(minPiano.noteRange.end, 59);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-next-octave')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-next-octave')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-next-octave')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-next-octave')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-next-octave')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-next-octave')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-next-octave')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-next-octave')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-next-octave')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-next-octave')));
    await tester.pumpAndSettle();

    expect(find.text('5. Oktav'), findsOneWidget);
    final VirtualPiano maxPiano = tester.widget(find.byType(VirtualPiano));
    expect(maxPiano.noteRange.start, 72);
    expect(maxPiano.noteRange.end, 95);
  });
}

Widget _wrapWithMaterial(Widget child) {
  return ProviderScope(
    child: buildLocalizedMaterialApp(
      Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(child: SizedBox(width: 420, child: child)),
        ),
      ),
    ),
  );
}

Widget _buildPanel({
  Set<int> highlightedMidiNotes = const <int>{},
  bool showHighlightedMidiNotes = true,
}) {
  return PianoPanel(
    highlightedMidiNotes: highlightedMidiNotes,
    pressedMidiNotes: const <int>{},
    showHighlightedMidiNotes: showHighlightedMidiNotes,
    autoFollowHighlightedNotes: true,
    onShowHighlightedMidiNotesChanged: _noopBool,
    onAutoFollowHighlightedNotesChanged: _noopBool,
    onNotePressed: _noopInt,
    onNoteReleased: _noopInt,
    onPlayLa4DemoPressed: _noopVoid,
    onPlayCMajorChordDemoPressed: _noopVoid,
  );
}

void _noopBool(bool _) {}

void _noopInt(int _) {}

void _noopVoid() {}
