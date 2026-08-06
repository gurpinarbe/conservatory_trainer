import 'dart:typed_data';

import 'package:conservatory_trainer/core/audio/audio_playback_service.dart';
import 'package:conservatory_trainer/core/audio/audio_providers.dart';
import 'package:conservatory_trainer/core/audio/audio_recording_service.dart';
import 'package:conservatory_trainer/core/music/music_note.dart';
import 'package:conservatory_trainer/features/single_note/presentation/single_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('turning off piano note display hides automatic highlight', (
    WidgetTester tester,
  ) async {
    final FakeAudioPlaybackService playbackService = FakeAudioPlaybackService();

    await tester.pumpWidget(
      _buildTestApp(
        overrides: <Override>[
          audioPlaybackServiceProvider.overrideWithValue(playbackService),
          audioRecordingServiceProvider.overrideWithValue(
            FakeAudioRecordingService(),
          ),
        ],
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-panel-toggle')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Çalan notaları piyanoda göster'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Çalan notaları piyanoda göster'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Sesi Dinle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sesi Dinle'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(
      find.byKey(const ValueKey<String>('piano-highlight-69')),
      findsNothing,
    );
  });

  testWidgets('pressing a piano key calls the audio playback service', (
    WidgetTester tester,
  ) async {
    final FakeAudioPlaybackService playbackService = FakeAudioPlaybackService();

    await tester.pumpWidget(
      _buildTestApp(
        overrides: <Override>[
          audioPlaybackServiceProvider.overrideWithValue(playbackService),
          audioRecordingServiceProvider.overrideWithValue(
            FakeAudioRecordingService(),
          ),
        ],
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-panel-toggle')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-panel-toggle')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('piano-key-69')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('piano-key-69')));
    await tester.pump();

    expect(playbackService.playedNotes, hasLength(1));
    expect(playbackService.playedNotes.single.turkishScientificName, 'La4');
    expect(find.text('Çaldığın Nota: La4'), findsOneWidget);
  });

  testWidgets('notation panel opens and closes', (WidgetTester tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        overrides: <Override>[
          audioPlaybackServiceProvider.overrideWithValue(
            FakeAudioPlaybackService(),
          ),
          audioRecordingServiceProvider.overrideWithValue(
            FakeAudioRecordingService(),
          ),
        ],
      ),
    );

    expect(find.text('Porteyi Aç'), findsNothing);
    expect(find.text('Porteyi Kapat'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('notation-panel-toggle')),
    );
    await tester.pumpAndSettle();
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
      await tester.pumpWidget(
        _buildTestApp(
          overrides: <Override>[
            audioPlaybackServiceProvider.overrideWithValue(
              FakeAudioPlaybackService(),
            ),
            audioRecordingServiceProvider.overrideWithValue(
              FakeAudioRecordingService(),
            ),
          ],
        ),
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('piano-panel-toggle')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey<String>('piano-panel-toggle')),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Sesi Dinle'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sesi Dinle'));
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('staff-highlight-listen-la4')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('piano-highlight-69')),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 2));
    },
  );

  testWidgets('turning off staff note display hides notation highlight', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(
        overrides: <Override>[
          audioPlaybackServiceProvider.overrideWithValue(
            FakeAudioPlaybackService(),
          ),
          audioRecordingServiceProvider.overrideWithValue(
            FakeAudioRecordingService(),
          ),
        ],
      ),
    );

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
      await tester.pumpWidget(
        _buildTestApp(
          overrides: <Override>[
            audioPlaybackServiceProvider.overrideWithValue(
              FakeAudioPlaybackService(),
            ),
            audioRecordingServiceProvider.overrideWithValue(
              FakeAudioRecordingService(),
            ),
          ],
        ),
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('piano-panel-toggle')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey<String>('piano-panel-toggle')),
      );
      await tester.pumpAndSettle();

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
}

Widget _buildTestApp({List<Override> overrides = const <Override>[]}) {
  return ProviderScope(
    overrides: overrides,
    child: const MaterialApp(home: SingleNoteScreen()),
  );
}

class FakeAudioPlaybackService implements AudioPlaybackService {
  final List<MusicNote> playedNotes = <MusicNote>[];

  @override
  Future<void> dispose() async {}

  @override
  Future<bool> playAsset(String assetPath) async {
    return false;
  }

  @override
  Future<bool> playMidiNoteNumber(int midiNoteNumber) async {
    return false;
  }

  @override
  Future<bool> playNote(MusicNote note) async {
    playedNotes.add(note);
    return true;
  }

  @override
  Future<void> stop() async {}
}

class FakeAudioRecordingService implements AudioRecordingService {
  @override
  Future<void> dispose() async {}

  @override
  Future<MicrophonePermissionStatus> requestMicrophonePermission() async {
    return MicrophonePermissionStatus.granted;
  }

  @override
  Future<Stream<Uint8List>?> startPcmStream() async {
    return const Stream<Uint8List>.empty();
  }

  @override
  Future<void> stop() async {}
}
