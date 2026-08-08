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
    return '${_assetSlug(note.pitchClass)}${note.octave}.$fileExtension';
  }

  String _assetSlug(PitchClass pitchClass) {
    return switch (pitchClass) {
      PitchClass.c => 'c',
      PitchClass.cSharp => 'c_sharp',
      PitchClass.d => 'd',
      PitchClass.dSharp => 'd_sharp',
      PitchClass.e => 'e',
      PitchClass.f => 'f',
      PitchClass.fSharp => 'f_sharp',
      PitchClass.g => 'g',
      PitchClass.gSharp => 'g_sharp',
      PitchClass.a => 'a',
      PitchClass.aSharp => 'a_sharp',
      PitchClass.b => 'b',
    };
  }
}
