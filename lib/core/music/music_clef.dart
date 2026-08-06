enum MusicClef { treble, bass, alto, tenor }

enum MusicClefPreference { auto, treble, bass, alto, tenor }

extension MusicClefPreferenceX on MusicClefPreference {
  String get label {
    return switch (this) {
      MusicClefPreference.auto => 'Otomatik',
      MusicClefPreference.treble => 'Sol Anahtarı',
      MusicClefPreference.bass => 'Fa Anahtarı',
      MusicClefPreference.alto => 'Alto Anahtarı',
      MusicClefPreference.tenor => 'Tenor Anahtarı',
    };
  }

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
