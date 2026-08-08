enum MusicClef { treble, bass, alto, tenor }

enum MusicClefPreference { auto, treble, bass, alto, tenor }

extension MusicClefPreferenceX on MusicClefPreference {
  MusicClef? get fixedClef {
    return switch (this) {
      MusicClefPreference.auto => null,
      MusicClefPreference.treble => MusicClef.treble,
      MusicClefPreference.bass => MusicClef.bass,
      MusicClefPreference.alto => MusicClef.alto,
      MusicClefPreference.tenor => MusicClef.tenor,
    };
  }
}
