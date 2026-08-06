import 'package:conservatory_trainer/core/music/music_note.dart';
import 'package:conservatory_trainer/shared/widgets/piano/piano_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('piano panel opens and closes', (WidgetTester tester) async {
    await tester.pumpWidget(
      _wrapWithMaterial(
        const PianoPanel(
          highlightedMidiNotes: <int>{},
          showHighlightedMidiNotes: true,
          autoFollowHighlightedNotes: true,
          onShowHighlightedMidiNotesChanged: _noopBool,
          onAutoFollowHighlightedNotesChanged: _noopBool,
          onNotePressed: _noopNote,
        ),
      ),
    );

    expect(find.text('Piyanoyu Aç'), findsOneWidget);
    expect(find.text('Piyanoyu Kapat'), findsNothing);

    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    expect(find.text('Piyanoyu Kapat'), findsOneWidget);
    expect(find.text('4. Oktav'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    expect(find.text('Piyanoyu Aç'), findsOneWidget);
    expect(find.text('4. Oktav'), findsNothing);
  });

  testWidgets('highlighted midi note highlights the correct key', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithMaterial(
        const PianoPanel(
          highlightedMidiNotes: <int>{69},
          showHighlightedMidiNotes: true,
          autoFollowHighlightedNotes: true,
          onShowHighlightedMidiNotesChanged: _noopBool,
          onAutoFollowHighlightedNotesChanged: _noopBool,
          onNotePressed: _noopNote,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('piano-highlight-69')),
      findsOneWidget,
    );
  });

  testWidgets('highlight is hidden when show-notes option is off', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithMaterial(
        const PianoPanel(
          highlightedMidiNotes: <int>{69},
          showHighlightedMidiNotes: false,
          autoFollowHighlightedNotes: true,
          onShowHighlightedMidiNotesChanged: _noopBool,
          onAutoFollowHighlightedNotesChanged: _noopBool,
          onNotePressed: _noopNote,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('piano-highlight-69')),
      findsNothing,
    );
  });
}

Widget _wrapWithMaterial(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(child: SizedBox(width: 420, child: child)),
      ),
    ),
  );
}

void _noopBool(bool _) {}

void _noopNote(MusicNote _) {}
