import 'package:conservatory_trainer/app/note_naming_controller.dart';
import 'package:conservatory_trainer/core/audio/piano_audio_service.dart';
import 'package:conservatory_trainer/core/music/note_naming_system.dart';
import 'package:conservatory_trainer/features/single_note/presentation/single_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_virtual_piano/flutter_virtual_piano.dart';

import '../../../test_helpers/test_support.dart';

void main() {
  testWidgets('turning off piano note display hides automatic highlight', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    await _openPianoPanel(tester);
    await tester.ensureVisible(
      find.text('Egzersiz notalarını piyanoda göster'),
    );
    await tester.tap(find.text('Egzersiz notalarını piyanoda göster'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Sesi Dinle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sesi Dinle'));
    await tester.pump();

    expect(_isMidiNoteHighlighted(tester, 69), isFalse);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('notation panel opens and closes', (WidgetTester tester) async {
    await tester.pumpWidget(_buildTestApp());

    expect(find.text('Porteyi Aç'), findsNothing);
    expect(find.text('Porteyi Kapat'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('notation-panel-toggle')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Porteyi Aç'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('notation-panel-toggle')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Porteyi Kapat'), findsOneWidget);
    expect(find.text('Çalan notaları portede göster'), findsOneWidget);
  });

  testWidgets(
    'listen action highlights the same midi note on piano and staff',
    (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestApp());

      await _openPianoPanel(tester);
      await tester.ensureVisible(find.text('Sesi Dinle'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sesi Dinle'));
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('staff-highlight-listen-la4')),
        findsOneWidget,
      );
      expect(_isMidiNoteHighlighted(tester, 69), isTrue);

      await tester.pump(const Duration(seconds: 2));
    },
  );

  testWidgets('turning off staff note display hides notation highlight', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildTestApp());

    await tester.ensureVisible(find.text('Çalan notaları portede göster'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Çalan notaları portede göster'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Sesi Dinle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sesi Dinle'));
    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('staff-highlight-listen-la4')),
      findsNothing,
    );

    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets(
    'development demo moves the notation highlight to the next note',
    (WidgetTester tester) async {
      await tester.pumpWidget(_buildTestApp());

      await _openPianoPanel(tester);
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('single-note-demo-sequence-button')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey<String>('single-note-demo-sequence-button')),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('staff-highlight-demo-c4')),
        findsOneWidget,
      );

      await tester.pump(const Duration(milliseconds: 1100));

      expect(
        find.byKey(const ValueKey<String>('staff-highlight-demo-c4')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('staff-highlight-demo-e4')),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets('missing soundfont shows message without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        overrides: testAudioOverrides(
          pianoAudioService: FakePianoAudioService(soundFontExists: false),
        ),
      ),
    );

    await tester.pump();
    await _openPianoPanel(tester);

    expect(find.text('Piyano ses dosyası henüz eklenmedi.'), findsOneWidget);
  });

  testWidgets('invalid soundfont shows message without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        overrides: testAudioOverrides(
          pianoAudioService: FakePianoAudioService(soundFontIsValid: false),
        ),
      ),
    );

    await tester.pump();
    await _openPianoPanel(tester);

    expect(
      find.text('Piyano ses dosyası bozuk veya geçersiz.'),
      findsOneWidget,
    );
  });

  testWidgets('fixedDo note naming shows La4', (WidgetTester tester) async {
    await tester.pumpWidget(
      _buildTestApp(noteNamingSystem: NoteNamingSystem.fixedDo),
    );
    await tester.pumpAndSettle();

    expect(find.text('La4'), findsOneWidget);
  });

  testWidgets('letterNames note naming shows A4', (WidgetTester tester) async {
    await tester.pumpWidget(
      _buildTestApp(noteNamingSystem: NoteNamingSystem.letterNames),
    );
    await tester.pumpAndSettle();

    expect(find.text('A4'), findsOneWidget);
  });

  testWidgets('English UI can still use fixedDo', (WidgetTester tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        locale: const Locale('en'),
        noteNamingSystem: NoteNamingSystem.fixedDo,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Repeat the note you hear'), findsOneWidget);
    expect(find.text('La4'), findsOneWidget);
  });

  testWidgets('Turkish UI can still use letterNames', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        locale: const Locale('tr'),
        noteNamingSystem: NoteNamingSystem.letterNames,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Duyduğun sesi tekrar et'), findsOneWidget);
    expect(find.text('A4'), findsOneWidget);
  });
}

Widget _buildTestApp({
  Locale locale = const Locale('tr'),
  NoteNamingSystem noteNamingSystem = NoteNamingSystem.fixedDo,
  List<Override> overrides = const <Override>[],
}) {
  return ProviderScope(
    overrides: <Override>[
      noteNamingControllerProvider.overrideWith(
        () => TestNoteNamingController(noteNamingSystem),
      ),
      ...testAudioOverrides(),
      ...overrides,
    ],
    child: buildLocalizedMaterialApp(const SingleNoteScreen(), locale: locale),
  );
}

Future<void> _openPianoPanel(WidgetTester tester) async {
  await tester.ensureVisible(
    find.byKey(const ValueKey<String>('piano-panel-toggle')),
  );
  await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
  await tester.pumpAndSettle();
}

bool _isMidiNoteHighlighted(WidgetTester tester, int midiNote) {
  final VirtualPiano piano = tester.widget(find.byType(VirtualPiano));
  final List<HighlightedNoteSet> highlightedNoteSets =
      piano.highlightedNoteSets ?? const <HighlightedNoteSet>[];

  return highlightedNoteSets.any(
    (HighlightedNoteSet set) => set.noteValues.contains(midiNote),
  );
}
