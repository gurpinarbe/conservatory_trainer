import 'package:conservatory_trainer/core/audio/audio_providers.dart';
import 'package:conservatory_trainer/core/audio/piano_audio_service.dart';
import 'package:conservatory_trainer/features/single_note/application/single_note_exercise_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_helpers/test_support.dart';

void main() {
  test(
    'pressing a piano note calls fake piano audio service with same midi',
    () async {
      final FakePianoAudioService pianoAudioService = FakePianoAudioService();
      final ProviderContainer container = _buildContainer(pianoAudioService);
      addTearDown(container.dispose);

      container.read(singleNoteExerciseControllerProvider);
      await Future<void>.delayed(Duration.zero);

      await container
          .read(singleNoteExerciseControllerProvider.notifier)
          .handlePianoNotePressed(60);

      expect(pianoAudioService.playedMidiNotes, contains(60));
      expect(
        container.read(singleNoteExerciseControllerProvider).pressedMidiNotes,
        contains(60),
      );
    },
  );

  test('releasing a piano note calls stopNote', () async {
    final FakePianoAudioService pianoAudioService = FakePianoAudioService();
    final ProviderContainer container = _buildContainer(pianoAudioService);
    addTearDown(container.dispose);

    container.read(singleNoteExerciseControllerProvider);
    await Future<void>.delayed(Duration.zero);

    await container
        .read(singleNoteExerciseControllerProvider.notifier)
        .handlePianoNotePressed(60);
    await container
        .read(singleNoteExerciseControllerProvider.notifier)
        .handlePianoNoteReleased(60);

    expect(pianoAudioService.stoppedMidiNotes, contains(60));
    expect(
      container.read(singleNoteExerciseControllerProvider).pressedMidiNotes,
      isNot(contains(60)),
    );
  });

  test('C major demo chord includes 60 64 and 67', () async {
    final FakePianoAudioService pianoAudioService = FakePianoAudioService();
    final ProviderContainer container = _buildContainer(pianoAudioService);
    addTearDown(container.dispose);

    container.read(singleNoteExerciseControllerProvider);
    await Future<void>.delayed(Duration.zero);

    await container
        .read(singleNoteExerciseControllerProvider.notifier)
        .playCMajorChordDemo();

    expect(pianoAudioService.playedChords, hasLength(1));
    expect(
      pianoAudioService.playedChords.single,
      equals(const <int>{60, 64, 67}),
    );
    expect(pianoAudioService.activeMidiNotes, isEmpty);
    expect(
      container.read(singleNoteExerciseControllerProvider).highlightedMidiNotes,
      isEmpty,
    );
  });

  test('missing soundfont does not crash and exposes message', () async {
    final FakePianoAudioService pianoAudioService = FakePianoAudioService(
      soundFontExists: false,
    );
    final FakeAudioPlaybackService audioPlaybackService =
        FakeAudioPlaybackService();
    final ProviderContainer container = _buildContainer(
      pianoAudioService,
      audioPlaybackService: audioPlaybackService,
    );
    addTearDown(container.dispose);

    container.read(singleNoteExerciseControllerProvider);
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(singleNoteExerciseControllerProvider).pianoStatusType,
      PianoAudioResultType.soundFontMissing,
    );

    await container
        .read(singleNoteExerciseControllerProvider.notifier)
        .handlePianoNotePressed(60);

    expect(pianoAudioService.playedMidiNotes, isEmpty);
    expect(audioPlaybackService.playedMidiNotes, contains(60));
    expect(
      container.read(singleNoteExerciseControllerProvider).pianoStatusType,
      PianoAudioResultType.soundFontMissing,
    );
  });
}

ProviderContainer _buildContainer(
  FakePianoAudioService pianoAudioService, {
  FakeAudioPlaybackService? audioPlaybackService,
}) {
  return ProviderContainer(
    overrides: <Override>[
      pianoAudioServiceProvider.overrideWithValue(pianoAudioService),
      audioPlaybackServiceProvider.overrideWithValue(
        audioPlaybackService ?? FakeAudioPlaybackService(),
      ),
      audioRecordingServiceProvider.overrideWithValue(
        FakeAudioRecordingService(),
      ),
    ],
  );
}
