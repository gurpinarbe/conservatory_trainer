import '../../l10n/l10n.dart';
import '../audio/piano_audio_service.dart';
import 'music_clef.dart';
import 'note_naming_system.dart';
import 'note_value.dart';
import 'pitch_result_state.dart';

extension MusicClefLocalizationX on MusicClef {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MusicClef.treble => l10n.clefTreble,
      MusicClef.bass => l10n.clefBass,
      MusicClef.alto => l10n.clefAlto,
      MusicClef.tenor => l10n.clefTenor,
    };
  }
}

extension MusicClefPreferenceLocalizationX on MusicClefPreference {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MusicClefPreference.auto => l10n.clefAuto,
      MusicClefPreference.treble => l10n.clefTreble,
      MusicClefPreference.bass => l10n.clefBass,
      MusicClefPreference.alto => l10n.clefAlto,
      MusicClefPreference.tenor => l10n.clefTenor,
    };
  }
}

extension NoteValueLocalizationX on NoteValue {
  String localizedName(AppLocalizations l10n) {
    return switch (this) {
      NoteValue.whole => l10n.noteValueWhole,
      NoteValue.half => l10n.noteValueHalf,
      NoteValue.quarter => l10n.noteValueQuarter,
      NoteValue.eighth => l10n.noteValueEighth,
      NoteValue.sixteenth => l10n.noteValueSixteenth,
      NoteValue.dottedHalf => l10n.noteValueDottedHalf,
      NoteValue.dottedQuarter => l10n.noteValueDottedQuarter,
      NoteValue.dottedEighth => l10n.noteValueDottedEighth,
    };
  }
}

extension PitchResultStateLocalizationX on PitchResultState {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      PitchResultState.flat => l10n.pitchFlat,
      PitchResultState.correct => l10n.pitchCorrect,
      PitchResultState.sharp => l10n.pitchSharp,
    };
  }
}

extension PianoAudioResultTypeLocalizationX on PianoAudioResultType {
  String localizedMessage(AppLocalizations l10n) {
    return switch (this) {
      PianoAudioResultType.success => l10n.pianoSoundReady,
      PianoAudioResultType.invalidMidiNote => l10n.invalidMidiNoteMessage,
      PianoAudioResultType.soundFontMissing =>
        l10n.pianoSoundFontMissingMessage,
      PianoAudioResultType.soundFontInvalid =>
        l10n.pianoSoundFontInvalidMessage,
      PianoAudioResultType.soundFontNotLoaded =>
        l10n.pianoSoundFontMissingMessage,
      PianoAudioResultType.engineError => l10n.pianoEngineErrorMessage,
    };
  }
}

extension NoteNamingSystemLocalizationX on NoteNamingSystem {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      NoteNamingSystem.fixedDo => l10n.noteNamingFixedDoOption,
      NoteNamingSystem.letterNames => l10n.noteNamingLetterNamesOption,
    };
  }

  String localizedDescription(AppLocalizations l10n) {
    return switch (this) {
      NoteNamingSystem.fixedDo => l10n.noteNamingFixedDoDescription,
      NoteNamingSystem.letterNames => l10n.noteNamingLetterNamesDescription,
    };
  }
}
