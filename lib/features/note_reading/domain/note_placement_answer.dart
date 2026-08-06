import '../../../core/music/note_value.dart';
import '../../../core/music/staff_position.dart';

class NotePlacementAnswer {
  const NotePlacementAnswer({
    required this.selectedMidiNoteNumber,
    required this.selectedStaffPosition,
    required this.selectedNoteValue,
    required this.expectedMidiNoteNumber,
    required this.expectedNoteValue,
  });

  final int selectedMidiNoteNumber;
  final StaffPosition selectedStaffPosition;
  final NoteValue selectedNoteValue;
  final int expectedMidiNoteNumber;
  final NoteValue expectedNoteValue;

  bool get isPitchCorrect => selectedMidiNoteNumber == expectedMidiNoteNumber;

  bool get isRhythmCorrect => selectedNoteValue == expectedNoteValue;
}
