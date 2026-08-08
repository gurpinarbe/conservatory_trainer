import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'audio_playback_service.dart';
import 'piano_audio_service.dart';
import 'audio_recording_service.dart';

final audioRecordingServiceProvider = Provider<AudioRecordingService>((
  Ref ref,
) {
  final AudioRecordingService service = RecordAudioRecordingService();
  ref.onDispose(() {
    unawaited(service.dispose());
  });
  return service;
});

final audioPlaybackServiceProvider = Provider<AudioPlaybackService>((Ref ref) {
  final AudioPlaybackService service = JustAudioPlaybackService();
  ref.onDispose(() {
    unawaited(service.dispose());
  });
  return service;
});

final pianoAudioServiceProvider = Provider<PianoAudioService>((Ref ref) {
  final PianoAudioService service = MidiProPianoAudioService();
  ref.onDispose(() {
    unawaited(service.dispose());
  });
  return service;
});
