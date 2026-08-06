import 'dart:typed_data';

import 'package:conservatory_trainer/core/audio/tone_audio_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wave tone audio source returns wav data', () async {
    final WaveToneAudioSource source = WaveToneAudioSource(
      frequencyHz: 440,
      duration: const Duration(milliseconds: 300),
    );

    final response = await source.request();
    final List<List<int>> chunks = await response.stream.toList();
    final Uint8List bytes = Uint8List.fromList(
      chunks.expand((List<int> chunk) => chunk).toList(growable: false),
    );

    expect(response.contentType, 'audio/wav');
    expect(response.sourceLength, bytes.length);
    expect(response.contentLength, bytes.length);
    expect(String.fromCharCodes(bytes.sublist(0, 4)), 'RIFF');
    expect(String.fromCharCodes(bytes.sublist(8, 12)), 'WAVE');
    expect(bytes.length, greaterThan(44));
  });

  test('wave tone audio source supports range requests', () async {
    final WaveToneAudioSource source = WaveToneAudioSource(
      frequencyHz: 261.63,
      duration: const Duration(milliseconds: 200),
    );

    final response = await source.request(44, 84);
    final List<List<int>> chunks = await response.stream.toList();
    final int totalLength = chunks.fold<int>(
      0,
      (int total, List<int> chunk) => total + chunk.length,
    );

    expect(response.offset, 44);
    expect(response.contentLength, 40);
    expect(totalLength, 40);
  });
}
