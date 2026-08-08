import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_providers.dart';
import '../../../core/audio/audio_playback_service.dart';
import '../../../core/audio/audio_recording_service.dart';
import '../../../core/audio/piano_audio_service.dart';
import '../../../core/music/music_clef.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/notation_event.dart';
import '../../../core/music/notation_sequence.dart';
import '../../../core/music/pitch_calculator.dart';
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

enum SingleNoteUserFeedback {
  previewSoundPlaying,
  previewSoundShowing,
  microphonePermissionDenied,
  recordPreview,
  demoSequencePlaying,
  demoSequenceShowing,
}

class SingleNoteExerciseController extends Notifier<SingleNoteExerciseState> {
  late final SingleNotePreviewService _previewService = ref.read(
    singleNotePreviewServiceProvider,
  );
  late final PianoAudioService _pianoAudioService = ref.read(
    pianoAudioServiceProvider,
  );
  late final AudioPlaybackService _audioPlaybackService = ref.read(
    audioPlaybackServiceProvider,
  );
  late final AudioRecordingService _recordingService = ref.read(
    audioRecordingServiceProvider,
  );

  int _automatedPlaybackSessionId = 0;

  @override
  SingleNoteExerciseState build() {
    ref.onDispose(() {
      _automatedPlaybackSessionId++;
    });

    final SingleNoteExerciseState initialState = SingleNoteExerciseState(
      snapshot: _previewService.buildSnapshot(),
      notationSequence: _previewService.buildListenSequence(),
      highlightedMidiNotes: const <int>{},
      pressedMidiNotes: const <int>{},
      showNotesOnPiano: true,
      showNotesOnStaff: true,
      autoFollowOctave: true,
      isStaffPanelExpanded: true,
      staffClefPreference: MusicClefPreference.auto,
      isPianoSoundFontLoaded: false,
      pianoStatusType: null,
    );

    unawaited(_initializePianoAudio());
    return initialState;
  }

  Future<SingleNoteUserFeedback> handleListenPressed() async {
    final NotationSequence sequence = _previewService.buildListenSequence();
    state = state.copyWith(
      notationSequence: sequence.withVisualStates(const <String>{}),
    );
    unawaited(_playNotationSequence(sequence, bpm: 60));
    return SingleNoteUserFeedback.previewSoundPlaying;
  }

  Future<SingleNoteUserFeedback> handleRecordPressed() async {
    final MicrophonePermissionStatus permissionStatus = await _recordingService
        .requestMicrophonePermission();

    if (permissionStatus != MicrophonePermissionStatus.granted) {
      return SingleNoteUserFeedback.microphonePermissionDenied;
    }

    return SingleNoteUserFeedback.recordPreview;
  }

  Future<SingleNoteUserFeedback> playDevelopmentDemoSequence() async {
    final NotationSequence sequence = _previewService
        .buildDevelopmentDemoSequence();
    state = state.copyWith(
      notationSequence: sequence.withVisualStates(const <String>{}),
    );
    unawaited(_playNotationSequence(sequence, bpm: 60));
    return SingleNoteUserFeedback.demoSequencePlaying;
  }

  Future<void> playLa4Demo() async {
    await _playHighlightedPianoNotes(const <int>{
      69,
    }, lastPlayedNote: PitchCalculator.midiToNote(69));
  }

  Future<void> playCMajorChordDemo() async {
    await _playHighlightedPianoNotes(const <int>{
      60,
      64,
      67,
    }, lastPlayedNote: PitchCalculator.midiToNote(67));
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

  Future<void> handlePianoNotePressed(int midiNoteNumber) async {
    final MusicNote? note = PitchCalculator.midiToNote(midiNoteNumber);
    if (note == null) {
      return;
    }

    state = state.copyWith(
      pressedMidiNotes: Set<int>.unmodifiable(<int>{
        ...state.pressedMidiNotes,
        midiNoteNumber,
      }),
      lastPlayedNote: note,
    );

    final PianoAudioResult result = await _pianoAudioService.playNote(
      midiNoteNumber,
    );
    _syncPianoAudioState(result);
    if (!result.isSuccess) {
      await _audioPlaybackService.playNote(note);
    }
  }

  Future<void> handlePianoNoteReleased(int midiNoteNumber) async {
    state = state.copyWith(
      pressedMidiNotes: Set<int>.unmodifiable(
        state.pressedMidiNotes
            .where((int note) => note != midiNoteNumber)
            .toSet(),
      ),
    );

    final PianoAudioResult result = await _pianoAudioService.stopNote(
      midiNoteNumber,
    );
    _syncPianoAudioState(result);
  }

  Future<void> _initializePianoAudio() async {
    final PianoAudioResult initializeResult = await _pianoAudioService
        .initialize();
    _syncPianoAudioState(initializeResult);

    final PianoAudioResult loadResult = await _pianoAudioService.loadSoundFont(
      defaultPianoSoundFontAssetPath,
    );
    _syncPianoAudioState(loadResult);
  }

  Future<void> _playHighlightedPianoNotes(
    Set<int> midiNotes, {
    required MusicNote? lastPlayedNote,
  }) async {
    final int sessionId = ++_automatedPlaybackSessionId;
    await _stopMidiNotes(state.highlightedMidiNotes);

    state = state.copyWith(
      highlightedMidiNotes: Set<int>.unmodifiable(midiNotes),
      lastPlayedNote: lastPlayedNote,
    );

    final PianoAudioResult result = await _pianoAudioService.playChord(
      midiNotes,
    );
    _syncPianoAudioState(result);
    if (!result.isSuccess) {
      await _playFallbackNotes(
        midiNotes.map(PitchCalculator.midiToNote).whereType<MusicNote>(),
      );
    }

    await Future<void>.delayed(const Duration(seconds: 1));
    if (sessionId != _automatedPlaybackSessionId) {
      return;
    }

    await _stopMidiNotes(midiNotes);
    if (sessionId != _automatedPlaybackSessionId) {
      return;
    }

    state = state.copyWith(
      highlightedMidiNotes: const <int>{},
      notationSequence: state.notationSequence.withVisualStates(
        const <String>{},
      ),
    );
  }

  Future<void> _playNotationSequence(
    NotationSequence sequence, {
    required int bpm,
  }) async {
    final int sessionId = ++_automatedPlaybackSessionId;
    final List<_NotationPlaybackStep> steps = _buildPlaybackSteps(
      sequence,
      bpm: bpm,
    );

    await _stopMidiNotes(state.highlightedMidiNotes);

    for (final _NotationPlaybackStep step in steps) {
      if (sessionId != _automatedPlaybackSessionId) {
        return;
      }

      _setHighlightedMidiNotes(step.midiNoteNumbers);
      state = state.copyWith(
        notationSequence: sequence.withVisualStates(step.activeEventIds),
        lastPlayedNote: step.lastPlayedNote,
      );

      final PianoAudioResult result = await _pianoAudioService.playChord(
        step.midiNoteNumbers,
      );
      _syncPianoAudioState(result);
      if (!result.isSuccess) {
        await _playFallbackNotes(step.notes);
      }

      await Future<void>.delayed(step.duration);

      if (sessionId != _automatedPlaybackSessionId) {
        return;
      }

      await _stopMidiNotes(step.midiNoteNumbers);
      if (sessionId != _automatedPlaybackSessionId) {
        return;
      }

      _setHighlightedMidiNotes(const <int>{});
      state = state.copyWith(
        notationSequence: sequence.withVisualStates(const <String>{}),
      );
    }
  }

  Future<void> _stopMidiNotes(Iterable<int> midiNoteNumbers) async {
    for (final int midiNoteNumber in midiNoteNumbers) {
      final PianoAudioResult result = await _pianoAudioService.stopNote(
        midiNoteNumber,
      );
      _syncPianoAudioState(result);
    }
  }

  void _setHighlightedMidiNotes(Set<int> midiNoteNumbers) {
    state = state.copyWith(
      highlightedMidiNotes: Set<int>.unmodifiable(midiNoteNumbers),
    );
  }

  void _syncPianoAudioState(PianoAudioResult result) {
    final PianoAudioResultType? nextStatusType;
    if (result.isSuccess) {
      nextStatusType = _pianoAudioService.isSoundFontLoaded
          ? PianoAudioResultType.success
          : state.pianoStatusType;
    } else {
      nextStatusType = result.type;
    }

    state = state.copyWith(
      isPianoSoundFontLoaded: _pianoAudioService.isSoundFontLoaded,
      pianoStatusType: nextStatusType,
      preservePianoStatusType: false,
    );
  }

  Future<void> _playFallbackNotes(Iterable<MusicNote> notes) async {
    for (final MusicNote note in notes) {
      await _audioPlaybackService.playNote(note);
    }
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
