import 'music_clef.dart';
import 'music_note.dart';
import 'staff_position.dart';

abstract final class StaffPositionCalculator {
  static StaffPosition positionForNote({
    required MusicNote note,
    required MusicClef clef,
  }) {
    final int bottomLineDiatonicIndex = switch (clef) {
      MusicClef.treble => _diatonicIndex('E', 4),
      MusicClef.bass => _diatonicIndex('G', 2),
      MusicClef.alto => _diatonicIndex('F', 3),
      MusicClef.tenor => _diatonicIndex('D', 3),
    };

    return StaffPosition(
      stepsFromBottomLine: note.diatonicIndex - bottomLineDiatonicIndex,
    );
  }

  static int _diatonicIndex(String naturalNoteName, int octave) {
    return (octave * 7) + _naturalNoteStepIndex(naturalNoteName);
  }

  static int _naturalNoteStepIndex(String naturalNoteName) {
    return switch (naturalNoteName) {
      'C' => 0,
      'D' => 1,
      'E' => 2,
      'F' => 3,
      'G' => 4,
      'A' => 5,
      'B' => 6,
      _ => throw ArgumentError.value(
        naturalNoteName,
        'naturalNoteName',
        'Unsupported note name',
      ),
    };
  }
}
