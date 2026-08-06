import '../../../core/music/music_clef.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/notation_sequence.dart';
import 'single_note_exercise_snapshot.dart';

class SingleNoteExerciseState {
  const SingleNoteExerciseState({
    required this.snapshot,
    required this.notationSequence,
    required this.highlightedMidiNotes,
    required this.showNotesOnPiano,
    required this.showNotesOnStaff,
    required this.autoFollowOctave,
    required this.isStaffPanelExpanded,
    required this.staffClefPreference,
    this.lastPlayedNote,
  });

  final SingleNoteExerciseSnapshot snapshot;
  final NotationSequence notationSequence;
  final Set<int> highlightedMidiNotes;
  final bool showNotesOnPiano;
  final bool showNotesOnStaff;
  final bool autoFollowOctave;
  final bool isStaffPanelExpanded;
  final MusicClefPreference staffClefPreference;
  final MusicNote? lastPlayedNote;

  Set<int> get visibleHighlightedMidiNotes {
    return showNotesOnPiano ? highlightedMidiNotes : const <int>{};
  }

  NotationSequence get displayedNotationSequence {
    if (showNotesOnStaff) {
      return notationSequence;
    }

    return notationSequence.withVisualStates(const <String>{});
  }

  SingleNoteExerciseState copyWith({
    SingleNoteExerciseSnapshot? snapshot,
    NotationSequence? notationSequence,
    Set<int>? highlightedMidiNotes,
    bool? showNotesOnPiano,
    bool? showNotesOnStaff,
    bool? autoFollowOctave,
    bool? isStaffPanelExpanded,
    MusicClefPreference? staffClefPreference,
    MusicNote? lastPlayedNote,
    bool preserveLastPlayedNote = true,
  }) {
    return SingleNoteExerciseState(
      snapshot: snapshot ?? this.snapshot,
      notationSequence: notationSequence ?? this.notationSequence,
      highlightedMidiNotes: highlightedMidiNotes ?? this.highlightedMidiNotes,
      showNotesOnPiano: showNotesOnPiano ?? this.showNotesOnPiano,
      showNotesOnStaff: showNotesOnStaff ?? this.showNotesOnStaff,
      autoFollowOctave: autoFollowOctave ?? this.autoFollowOctave,
      isStaffPanelExpanded: isStaffPanelExpanded ?? this.isStaffPanelExpanded,
      staffClefPreference: staffClefPreference ?? this.staffClefPreference,
      lastPlayedNote: preserveLastPlayedNote
          ? lastPlayedNote ?? this.lastPlayedNote
          : lastPlayedNote,
    );
  }
}
