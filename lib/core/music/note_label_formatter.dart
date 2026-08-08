import '../../l10n/l10n.dart';
import 'music_accidental.dart';
import 'music_note.dart';
import 'note_naming_system.dart';

class NoteLabelFormatter {
  const NoteLabelFormatter();

  String formatScientificName(
    MusicNote note, {
    required NoteNamingSystem namingSystem,
    NoteSpellingPreference spellingPreference = NoteSpellingPreference.sharp,
  }) {
    return '${formatPitchClass(note.pitchClass, namingSystem: namingSystem, spellingPreference: spellingPreference)}${note.octave}';
  }

  String formatPitchClass(
    PitchClass pitchClass, {
    required NoteNamingSystem namingSystem,
    NoteSpellingPreference spellingPreference = NoteSpellingPreference.sharp,
  }) {
    final _ResolvedNoteName resolved = _resolve(
      pitchClass,
      namingSystem: namingSystem,
      spellingPreference: spellingPreference,
    );

    return switch (resolved.accidental) {
      MusicAccidental.natural => resolved.baseName,
      MusicAccidental.sharp => '${resolved.baseName}♯',
      MusicAccidental.flat => '${resolved.baseName}♭',
    };
  }

  String formatAccessibleScientificName(
    MusicNote note, {
    required AppLocalizations l10n,
    required NoteNamingSystem namingSystem,
    NoteSpellingPreference spellingPreference = NoteSpellingPreference.sharp,
  }) {
    final _ResolvedNoteName resolved = _resolve(
      note.pitchClass,
      namingSystem: namingSystem,
      spellingPreference: spellingPreference,
    );

    return switch (resolved.accidental) {
      MusicAccidental.natural => l10n.noteAccessibilityNatural(
        resolved.baseName,
        note.octave.toString(),
      ),
      MusicAccidental.sharp => l10n.noteAccessibilityAccidental(
        resolved.baseName,
        l10n.accidentalSharpWord,
        note.octave.toString(),
      ),
      MusicAccidental.flat => l10n.noteAccessibilityAccidental(
        resolved.baseName,
        l10n.accidentalFlatWord,
        note.octave.toString(),
      ),
    };
  }

  _ResolvedNoteName _resolve(
    PitchClass pitchClass, {
    required NoteNamingSystem namingSystem,
    required NoteSpellingPreference spellingPreference,
  }) {
    final bool useFixedDo = namingSystem == NoteNamingSystem.fixedDo;

    return switch ((pitchClass, spellingPreference, useFixedDo)) {
      (PitchClass.c, _, false) => const _ResolvedNoteName('C'),
      (PitchClass.cSharp, NoteSpellingPreference.sharp, false) =>
        const _ResolvedNoteName('C', accidental: MusicAccidental.sharp),
      (PitchClass.cSharp, NoteSpellingPreference.flat, false) =>
        const _ResolvedNoteName('D', accidental: MusicAccidental.flat),
      (PitchClass.d, _, false) => const _ResolvedNoteName('D'),
      (PitchClass.dSharp, NoteSpellingPreference.sharp, false) =>
        const _ResolvedNoteName('D', accidental: MusicAccidental.sharp),
      (PitchClass.dSharp, NoteSpellingPreference.flat, false) =>
        const _ResolvedNoteName('E', accidental: MusicAccidental.flat),
      (PitchClass.e, _, false) => const _ResolvedNoteName('E'),
      (PitchClass.f, _, false) => const _ResolvedNoteName('F'),
      (PitchClass.fSharp, NoteSpellingPreference.sharp, false) =>
        const _ResolvedNoteName('F', accidental: MusicAccidental.sharp),
      (PitchClass.fSharp, NoteSpellingPreference.flat, false) =>
        const _ResolvedNoteName('G', accidental: MusicAccidental.flat),
      (PitchClass.g, _, false) => const _ResolvedNoteName('G'),
      (PitchClass.gSharp, NoteSpellingPreference.sharp, false) =>
        const _ResolvedNoteName('G', accidental: MusicAccidental.sharp),
      (PitchClass.gSharp, NoteSpellingPreference.flat, false) =>
        const _ResolvedNoteName('A', accidental: MusicAccidental.flat),
      (PitchClass.a, _, false) => const _ResolvedNoteName('A'),
      (PitchClass.aSharp, NoteSpellingPreference.sharp, false) =>
        const _ResolvedNoteName('A', accidental: MusicAccidental.sharp),
      (PitchClass.aSharp, NoteSpellingPreference.flat, false) =>
        const _ResolvedNoteName('B', accidental: MusicAccidental.flat),
      (PitchClass.b, _, false) => const _ResolvedNoteName('B'),
      (PitchClass.c, _, true) => const _ResolvedNoteName('Do'),
      (PitchClass.cSharp, NoteSpellingPreference.sharp, true) =>
        const _ResolvedNoteName('Do', accidental: MusicAccidental.sharp),
      (PitchClass.cSharp, NoteSpellingPreference.flat, true) =>
        const _ResolvedNoteName('Re', accidental: MusicAccidental.flat),
      (PitchClass.d, _, true) => const _ResolvedNoteName('Re'),
      (PitchClass.dSharp, NoteSpellingPreference.sharp, true) =>
        const _ResolvedNoteName('Re', accidental: MusicAccidental.sharp),
      (PitchClass.dSharp, NoteSpellingPreference.flat, true) =>
        const _ResolvedNoteName('Mi', accidental: MusicAccidental.flat),
      (PitchClass.e, _, true) => const _ResolvedNoteName('Mi'),
      (PitchClass.f, _, true) => const _ResolvedNoteName('Fa'),
      (PitchClass.fSharp, NoteSpellingPreference.sharp, true) =>
        const _ResolvedNoteName('Fa', accidental: MusicAccidental.sharp),
      (PitchClass.fSharp, NoteSpellingPreference.flat, true) =>
        const _ResolvedNoteName('Sol', accidental: MusicAccidental.flat),
      (PitchClass.g, _, true) => const _ResolvedNoteName('Sol'),
      (PitchClass.gSharp, NoteSpellingPreference.sharp, true) =>
        const _ResolvedNoteName('Sol', accidental: MusicAccidental.sharp),
      (PitchClass.gSharp, NoteSpellingPreference.flat, true) =>
        const _ResolvedNoteName('La', accidental: MusicAccidental.flat),
      (PitchClass.a, _, true) => const _ResolvedNoteName('La'),
      (PitchClass.aSharp, NoteSpellingPreference.sharp, true) =>
        const _ResolvedNoteName('La', accidental: MusicAccidental.sharp),
      (PitchClass.aSharp, NoteSpellingPreference.flat, true) =>
        const _ResolvedNoteName('Si', accidental: MusicAccidental.flat),
      (PitchClass.b, _, true) => const _ResolvedNoteName('Si'),
    };
  }
}

class _ResolvedNoteName {
  const _ResolvedNoteName(
    this.baseName, {
    this.accidental = MusicAccidental.natural,
  });

  final String baseName;
  final MusicAccidental accidental;
}
