import 'music_accidental.dart';
import 'music_note.dart';
import 'note_value.dart';

enum NotationEventVisualState {
  normal,
  active,
  selected,
  correct,
  wrong,
  corrected,
}

sealed class NotationEvent {
  const NotationEvent({
    required this.id,
    required this.noteValue,
    required this.startUnits,
    required this.measureIndex,
    this.visualState = NotationEventVisualState.normal,
  });

  final String id;
  final NoteValue noteValue;
  final int startUnits;
  final int measureIndex;
  final NotationEventVisualState visualState;

  int get durationUnits => noteValue.sixteenthUnits;

  double get startBeatsInFourFour => startUnits / 4;

  bool get isActive => visualState == NotationEventVisualState.active;

  bool get isRest;
}

class NoteEvent extends NotationEvent {
  const NoteEvent({
    required this.note,
    required super.id,
    required super.noteValue,
    required super.startUnits,
    required super.measureIndex,
    this.accidental,
    super.visualState,
  });

  final MusicNote note;
  final MusicAccidental? accidental;

  @override
  bool get isRest => false;

  NoteEvent copyWith({
    MusicNote? note,
    String? id,
    NoteValue? noteValue,
    int? startUnits,
    int? measureIndex,
    MusicAccidental? accidental,
    NotationEventVisualState? visualState,
  }) {
    return NoteEvent(
      note: note ?? this.note,
      id: id ?? this.id,
      noteValue: noteValue ?? this.noteValue,
      startUnits: startUnits ?? this.startUnits,
      measureIndex: measureIndex ?? this.measureIndex,
      accidental: accidental ?? this.accidental,
      visualState: visualState ?? this.visualState,
    );
  }
}

class RestEvent extends NotationEvent {
  const RestEvent({
    required super.id,
    required super.noteValue,
    required super.startUnits,
    required super.measureIndex,
    super.visualState,
  });

  @override
  bool get isRest => true;

  RestEvent copyWith({
    String? id,
    NoteValue? noteValue,
    int? startUnits,
    int? measureIndex,
    NotationEventVisualState? visualState,
  }) {
    return RestEvent(
      id: id ?? this.id,
      noteValue: noteValue ?? this.noteValue,
      startUnits: startUnits ?? this.startUnits,
      measureIndex: measureIndex ?? this.measureIndex,
      visualState: visualState ?? this.visualState,
    );
  }
}
