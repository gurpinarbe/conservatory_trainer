import '../../../core/music/notation_sequence.dart';
import '../../../core/music/time_signature.dart';

class MelodyWritingAttempt {
  const MelodyWritingAttempt({
    required this.timeSignature,
    required this.expectedSequence,
    required this.submittedSequence,
    this.pitchAccuracy = 0,
    this.rhythmAccuracy = 0,
    this.noteOrderAccuracy = 0,
    this.missingNoteCount = 0,
    this.extraNoteCount = 0,
    this.isMeasureIntegrityValid = false,
  });

  final TimeSignature timeSignature;
  final NotationSequence expectedSequence;
  final NotationSequence submittedSequence;
  final double pitchAccuracy;
  final double rhythmAccuracy;
  final double noteOrderAccuracy;
  final int missingNoteCount;
  final int extraNoteCount;
  final bool isMeasureIntegrityValid;
}
