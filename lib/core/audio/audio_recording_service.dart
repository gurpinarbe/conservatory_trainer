import 'dart:typed_data';

import 'package:record/record.dart';

enum MicrophonePermissionStatus { granted, denied }

abstract class AudioRecordingService {
  Future<MicrophonePermissionStatus> requestMicrophonePermission();

  Future<Stream<Uint8List>?> startPcmStream();

  Future<void> stop();

  Future<void> dispose();
}

class RecordAudioRecordingService implements AudioRecordingService {
  RecordAudioRecordingService({AudioRecorder? recorder})
    : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;

  @override
  Future<MicrophonePermissionStatus> requestMicrophonePermission() async {
    try {
      final bool hasPermission = await _recorder.hasPermission();
      return hasPermission
          ? MicrophonePermissionStatus.granted
          : MicrophonePermissionStatus.denied;
    } catch (_) {
      return MicrophonePermissionStatus.denied;
    }
  }

  @override
  Future<Stream<Uint8List>?> startPcmStream() async {
    final MicrophonePermissionStatus permissionStatus =
        await requestMicrophonePermission();
    if (permissionStatus != MicrophonePermissionStatus.granted) {
      return null;
    }

    try {
      return await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 44100,
          numChannels: 1,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> stop() async {
    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
    } catch (_) {
      // İzin reddi veya platform hatalarında uygulamayı düşürmüyoruz.
    }
  }

  @override
  Future<void> dispose() {
    return _recorder.dispose();
  }
}
