import '../music/music_note.dart';
import '../music/piano_keyboard_layout.dart';
import '../music/piano_note_range.dart';

abstract class PianoNoteAudioAssetResolver {
  String assetPathForNote(MusicNote note);

  List<String> requiredAssetFileNames({PianoNoteRange range});
}

class DefaultPianoNoteAudioAssetResolver
    implements PianoNoteAudioAssetResolver {
  const DefaultPianoNoteAudioAssetResolver({
    this.basePath = 'assets/audio/piano',
    this.fileExtension = 'mp3',
  });

  final String basePath;
  final String fileExtension;

  @override
  String assetPathForNote(MusicNote note) {
    return '$basePath/${_fileNameForNote(note)}';
  }

  @override
  List<String> requiredAssetFileNames({
    PianoNoteRange range = PianoKeyboardLayout.supportedRange,
  }) {
    return PianoKeyboardLayout.notesForRange(
      range: range,
    ).map(_fileNameForNote).toList();
  }

  String _fileNameForNote(MusicNote note) {
    return '${_assetSlug(note.noteName)}${note.octave}.$fileExtension';
  }

  String _assetSlug(String noteName) {
    return switch (noteName) {
      'C' => 'c',
      'C#' => 'c_sharp',
      'D' => 'd',
      'D#' => 'd_sharp',
      'E' => 'e',
      'F' => 'f',
      'F#' => 'f_sharp',
      'G' => 'g',
      'G#' => 'g_sharp',
      'A' => 'a',
      'A#' => 'a_sharp',
      'B' => 'b',
      _ => noteName.toLowerCase(),
    };
  }
}
