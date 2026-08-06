import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_playback_service.dart';
import '../../../core/audio/audio_providers.dart';
import '../../../core/music/note_value.dart';

final noteValueLessonControllerProvider =
    NotifierProvider<NoteValueLessonController, NoteValueLessonState>(
      NoteValueLessonController.new,
    );

class NoteValueLessonController extends Notifier<NoteValueLessonState> {
  late final AudioPlaybackService _playbackService = ref.read(
    audioPlaybackServiceProvider,
  );

  int _sessionId = 0;

  @override
  NoteValueLessonState build() {
    return const NoteValueLessonState();
  }

  Future<void> preview(NoteValue noteValue) async {
    final int sessionId = ++_sessionId;
    final Duration duration = noteValue.durationAtBpm(60);

    state = NoteValueLessonState(
      activeNoteValue: noteValue,
      activeDuration: duration,
    );

    unawaited(_playbackService.playMidiNoteNumber(69));
    await Future<void>.delayed(duration);

    if (sessionId != _sessionId) {
      return;
    }

    state = const NoteValueLessonState();
  }
}

class NoteValueLessonState {
  const NoteValueLessonState({this.activeNoteValue, this.activeDuration});

  final NoteValue? activeNoteValue;
  final Duration? activeDuration;

  bool isPreviewing(NoteValue noteValue) => activeNoteValue == noteValue;
}
