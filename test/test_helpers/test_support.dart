import 'dart:typed_data';

import 'package:conservatory_trainer/app/app.dart';
import 'package:conservatory_trainer/app/locale_controller.dart';
import 'package:conservatory_trainer/app/note_naming_controller.dart';
import 'package:conservatory_trainer/core/audio/audio_playback_service.dart';
import 'package:conservatory_trainer/core/audio/audio_providers.dart';
import 'package:conservatory_trainer/core/audio/audio_recording_service.dart';
import 'package:conservatory_trainer/core/audio/piano_audio_service.dart';
import 'package:conservatory_trainer/core/music/music_note.dart';
import 'package:conservatory_trainer/core/music/note_naming_system.dart';
import 'package:conservatory_trainer/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildLocalizedMaterialApp(
  Widget home, {
  Locale locale = const Locale('tr'),
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: ConservatoryTrainerApp.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: home,
  );
}

Widget buildConservatoryTestApp({
  Locale? selectedLocale,
  NoteNamingSystem noteNamingSystem = NoteNamingSystem.fixedDo,
  List<Override> extraOverrides = const <Override>[],
}) {
  return ProviderScope(
    overrides: <Override>[
      localeControllerProvider.overrideWith(
        () => TestLocaleController(selectedLocale),
      ),
      noteNamingControllerProvider.overrideWith(
        () => TestNoteNamingController(noteNamingSystem),
      ),
      ...extraOverrides,
    ],
    child: const ConservatoryTrainerApp(),
  );
}

Future<AppLocalizations> loadAppLocalizations(Locale locale) {
  return AppLocalizations.delegate.load(locale);
}

class TestLocaleController extends LocaleController {
  TestLocaleController(this.initialLocale);

  final Locale? initialLocale;

  @override
  Locale? build() => initialLocale;
}

class TestNoteNamingController extends NoteNamingController {
  TestNoteNamingController(this.initialSystem);

  final NoteNamingSystem initialSystem;

  @override
  NoteNamingSystem build() => initialSystem;
}

class FakeAudioRecordingService implements AudioRecordingService {
  @override
  Future<void> dispose() async {}

  @override
  Future<MicrophonePermissionStatus> requestMicrophonePermission() async {
    return MicrophonePermissionStatus.granted;
  }

  @override
  Future<Stream<Uint8List>?> startPcmStream() async {
    return const Stream<Uint8List>.empty();
  }

  @override
  Future<void> stop() async {}
}

List<Override> testAudioOverrides({
  PianoAudioService? pianoAudioService,
  AudioPlaybackService? audioPlaybackService,
  AudioRecordingService? recordingService,
}) {
  return <Override>[
    pianoAudioServiceProvider.overrideWithValue(
      pianoAudioService ?? FakePianoAudioService(),
    ),
    audioPlaybackServiceProvider.overrideWithValue(
      audioPlaybackService ?? FakeAudioPlaybackService(),
    ),
    audioRecordingServiceProvider.overrideWithValue(
      recordingService ?? FakeAudioRecordingService(),
    ),
  ];
}

class FakeAudioPlaybackService implements AudioPlaybackService {
  final List<int> playedMidiNotes = <int>[];
  final List<MusicNote> playedNotes = <MusicNote>[];
  final List<String> playedAssets = <String>[];
  bool stopCalled = false;

  @override
  Future<void> dispose() async {}

  @override
  Future<bool> playAsset(String assetPath) async {
    playedAssets.add(assetPath);
    return true;
  }

  @override
  Future<bool> playMidiNoteNumber(int midiNoteNumber) async {
    playedMidiNotes.add(midiNoteNumber);
    return true;
  }

  @override
  Future<bool> playNote(MusicNote note) async {
    playedNotes.add(note);
    playedMidiNotes.add(note.midiNoteNumber);
    return true;
  }

  @override
  Future<void> stop() async {
    stopCalled = true;
  }
}
