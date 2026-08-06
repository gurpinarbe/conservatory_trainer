import 'music_clef.dart';
import 'music_note.dart';

abstract final class MusicClefSelector {
  static MusicClef selectBestClef(Iterable<MusicNote> notes) {
    if (notes.isEmpty) {
      return MusicClef.treble;
    }

    final List<int> midiNotes = notes
        .map((MusicNote note) => note.midiNoteNumber)
        .toList(growable: false);
    final double averageMidi =
        midiNotes.reduce((int a, int b) => a + b) / midiNotes.length;

    return averageMidi < 60 ? MusicClef.bass : MusicClef.treble;
  }
}
