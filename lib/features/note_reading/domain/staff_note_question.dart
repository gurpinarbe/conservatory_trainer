import '../../../core/music/music_clef.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/notation_sequence.dart';

class StaffNoteQuestion {
  const StaffNoteQuestion({
    required this.targetNote,
    required this.options,
    required this.sequence,
    this.clef = MusicClef.treble,
  });

  final MusicNote targetNote;
  final List<MusicNote> options;
  final NotationSequence sequence;
  final MusicClef clef;

  bool isCorrectAnswer(MusicNote answer) {
    return answer.midiNoteNumber == targetNote.midiNoteNumber;
  }
}
