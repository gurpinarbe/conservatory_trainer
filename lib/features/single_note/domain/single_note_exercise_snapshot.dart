import '../../../core/music/music_note.dart';
import '../../../core/music/pitch_result_state.dart';

class SingleNoteExerciseSnapshot {
  const SingleNoteExerciseSnapshot({
    required this.targetNote,
    required this.detectedNote,
    required this.centDifference,
    required this.resultState,
    required this.resultMessage,
  });

  final MusicNote targetNote;
  final MusicNote detectedNote;
  final double centDifference;
  final PitchResultState resultState;
  final String resultMessage;
}
