import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_playback_service.dart';
import '../../../core/audio/audio_providers.dart';
import '../../../core/audio/audio_recording_service.dart';
import '../../../core/music/music_clef.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/notation_event.dart';
import '../../../core/music/notation_sequence.dart';
import '../domain/single_note_exercise_state.dart';
import 'single_note_preview_service.dart';

final singleNotePreviewServiceProvider = Provider<SingleNotePreviewService>((
  Ref ref,
) {
  return const SingleNotePreviewService();
});

final singleNoteExerciseControllerProvider =
    NotifierProvider<SingleNoteExerciseController, SingleNoteExerciseState>(
      SingleNoteExerciseController.new,
    );

class SingleNoteExerciseController extends Notifier<SingleNoteExerciseState> {
  late final SingleNotePreviewService _previewService = ref.read(
    singleNotePreviewServiceProvider,
  );
  late final AudioPlaybackService _playbackService = ref.read(
    audioPlaybackServiceProvider,
  );
  late final AudioRecordingService _recordingService = ref.read(
    audioRecordingServiceProvider,
  );

  int _highlightSessionId = 0;

  @override
  SingleNoteExerciseState build() {
    ref.onDispose(() {
      _highlightSessionId++;
    });

    return SingleNoteExerciseState(
      snapshot: _previewService.buildSnapshot(),
      notationSequence: _previewService.buildListenSequence(),
      highlightedMidiNotes: const <int>{},
      showNotesOnPiano: true,
      showNotesOnStaff: true,
      autoFollowOctave: true,
      isStaffPanelExpanded: true,
      staffClefPreference: MusicClefPreference.auto,
    );
  }

  Future<String> handleListenPressed() async {
    final NotationSequence sequence = _previewService.buildListenSequence();
    state = state.copyWith(
      notationSequence: sequence.withVisualStates(const <String>{}),
    );
    unawaited(_playNotationSequence(sequence, bpm: 60));
    return 'Hedef ses örneği çalınıyor.';
  }

  Future<String> handleRecordPressed() async {
    final MicrophonePermissionStatus permissionStatus = await _recordingService
        .requestMicrophonePermission();

    if (permissionStatus != MicrophonePermissionStatus.granted) {
      return 'Mikrofon izni verilmedi. Bu egzersiz için önce izin vermen gerekecek.';
    }

    return _previewService.recordPreviewMessage;
  }

  Future<String> playDevelopmentDemoSequence() async {
    final NotationSequence sequence = _previewService
        .buildDevelopmentDemoSequence();
    state = state.copyWith(
      notationSequence: sequence.withVisualStates(const <String>{}),
    );
    unawaited(_playNotationSequence(sequence, bpm: 60));
    return 'Do-Mi-Sol demosu başlatıldı.';
  }

  void setShowNotesOnPiano(bool value) {
    state = state.copyWith(showNotesOnPiano: value);
  }

  void setAutoFollowOctave(bool value) {
    state = state.copyWith(autoFollowOctave: value);
  }

  void setShowNotesOnStaff(bool value) {
    state = state.copyWith(showNotesOnStaff: value);
  }

  void setStaffPanelExpanded(bool value) {
    state = state.copyWith(isStaffPanelExpanded: value);
  }

  void setStaffClefPreference(MusicClefPreference value) {
    state = state.copyWith(staffClefPreference: value);
  }

  void handleNotePressed(MusicNote note) {
    state = state.copyWith(lastPlayedNote: note);
    unawaited(_playbackService.playNote(note));
  }

  Future<void> _playNotationSequence(
    NotationSequence sequence, {
    required int bpm,
  }) async {
    final int sessionId = ++_highlightSessionId;
    final List<_NotationPlaybackStep> steps = _buildPlaybackSteps(
      sequence,
      bpm: bpm,
    );

    await _playbackService.stop();

    for (final _NotationPlaybackStep step in steps) {
      if (sessionId != _highlightSessionId) {
        return;
      }

      _setHighlightedMidiNotes(step.midiNoteNumbers);
      state = state.copyWith(
        notationSequence: sequence.withVisualStates(step.activeEventIds),
        lastPlayedNote: step.lastPlayedNote,
      );

      for (final MusicNote note in step.notes) {
        unawaited(_playbackService.playNote(note));
      }

      await Future<void>.delayed(step.duration);

      if (sessionId != _highlightSessionId) {
        return;
      }

      _setHighlightedMidiNotes(const <int>{});
      state = state.copyWith(
        notationSequence: sequence.withVisualStates(const <String>{}),
      );
    }
  }

  void _setHighlightedMidiNotes(Set<int> midiNoteNumbers) {
    state = state.copyWith(
      highlightedMidiNotes: Set<int>.unmodifiable(midiNoteNumbers),
    );
  }
}

class _NotationPlaybackStep {
  const _NotationPlaybackStep({
    required this.notes,
    required this.activeEventIds,
    required this.duration,
  });

  final List<MusicNote> notes;
  final Set<String> activeEventIds;
  final Duration duration;

  Set<int> get midiNoteNumbers =>
      notes.map((MusicNote note) => note.midiNoteNumber).toSet();

  MusicNote? get lastPlayedNote => notes.isEmpty ? null : notes.last;
}

class _TimelineEntry {
  const _TimelineEntry({required this.event, required this.absoluteStartUnits});

  final NotationEvent event;
  final int absoluteStartUnits;
}

extension on SingleNoteExerciseController {
  List<_NotationPlaybackStep> _buildPlaybackSteps(
    NotationSequence sequence, {
    required int bpm,
  }) {
    final List<_TimelineEntry> entries = <_TimelineEntry>[];
    int measureOffsetUnits = 0;

    for (final measure in sequence.measures) {
      for (final NotationEvent event in measure.events) {
        entries.add(
          _TimelineEntry(
            event: event,
            absoluteStartUnits: measureOffsetUnits + event.startUnits,
          ),
        );
      }

      measureOffsetUnits += measure.timeSignature.measureUnits;
    }

    entries.sort(
      (_TimelineEntry first, _TimelineEntry second) =>
          first.absoluteStartUnits.compareTo(second.absoluteStartUnits),
    );

    final List<_NotationPlaybackStep> steps = <_NotationPlaybackStep>[];
    int index = 0;

    while (index < entries.length) {
      final int currentStartUnits = entries[index].absoluteStartUnits;
      final List<_TimelineEntry> groupEntries = <_TimelineEntry>[];

      while (index < entries.length &&
          entries[index].absoluteStartUnits == currentStartUnits) {
        groupEntries.add(entries[index]);
        index++;
      }

      final List<NoteEvent> noteEvents = groupEntries
          .map((_TimelineEntry entry) => entry.event)
          .whereType<NoteEvent>()
          .toList(growable: false);
      final int nextStartUnits = index < entries.length
          ? entries[index].absoluteStartUnits
          : currentStartUnits +
                groupEntries
                    .map((_TimelineEntry entry) => entry.event.durationUnits)
                    .reduce(
                      (int first, int second) =>
                          first > second ? first : second,
                    );

      final int elapsedUnits = nextStartUnits - currentStartUnits;
      final int milliseconds = ((60 / bpm) * (elapsedUnits / 4) * 1000)
          .round()
          .clamp(120, 12000);

      steps.add(
        _NotationPlaybackStep(
          notes: noteEvents.map((NoteEvent event) => event.note).toList(),
          activeEventIds: noteEvents.map((NoteEvent event) => event.id).toSet(),
          duration: Duration(milliseconds: milliseconds),
        ),
      );
    }

    return steps;
  }
}
