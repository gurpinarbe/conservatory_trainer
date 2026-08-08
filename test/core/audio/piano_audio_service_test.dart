import 'package:conservatory_trainer/core/audio/piano_audio_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stopAll clears active notes', () async {
    final FakePianoAudioService service = FakePianoAudioService();

    await service.initialize();
    await service.loadSoundFont(defaultPianoSoundFontAssetPath);
    await service.playChord(const <int>{60, 64, 67});

    expect(service.activeMidiNotes, equals(const <int>{60, 64, 67}));

    await service.stopAll();

    expect(service.activeMidiNotes, isEmpty);
  });
}
