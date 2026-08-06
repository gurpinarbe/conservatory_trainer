// ignore_for_file: experimental_member_use

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';

/// Üretim asset'i yokken eğitim demosunun sessiz kalmaması için
/// bellekte kısa bir WAV tonu oluşturuyoruz.
class WaveToneAudioSource extends StreamAudioSource {
  WaveToneAudioSource({
    required double frequencyHz,
    Duration duration = const Duration(milliseconds: 900),
    int sampleRate = 44100,
    double amplitude = 0.22,
  }) : _bytes = _buildWavBytes(
         frequencyHz: frequencyHz,
         duration: duration,
         sampleRate: sampleRate,
         amplitude: amplitude,
       );

  final Uint8List _bytes;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final int safeStart = (start ?? 0).clamp(0, _bytes.length);
    final int safeEnd = (end ?? _bytes.length).clamp(safeStart, _bytes.length);
    final Uint8List chunk = _bytes.sublist(safeStart, safeEnd);

    return StreamAudioResponse(
      rangeRequestsSupported: true,
      sourceLength: _bytes.length,
      contentLength: chunk.length,
      offset: safeStart,
      contentType: 'audio/wav',
      stream: Stream<List<int>>.value(chunk),
    );
  }

  static Uint8List _buildWavBytes({
    required double frequencyHz,
    required Duration duration,
    required int sampleRate,
    required double amplitude,
  }) {
    final int totalSamples = math.max(
      1,
      (sampleRate * duration.inMilliseconds / 1000).round(),
    );
    const int channelCount = 1;
    const int bitsPerSample = 16;
    final int byteRate = sampleRate * channelCount * (bitsPerSample ~/ 8);
    final int blockAlign = channelCount * (bitsPerSample ~/ 8);
    final int dataLength = totalSamples * blockAlign;
    final ByteData byteData = ByteData(44 + dataLength);

    void writeAscii(int offset, String value) {
      for (int index = 0; index < value.length; index++) {
        byteData.setUint8(offset + index, value.codeUnitAt(index));
      }
    }

    writeAscii(0, 'RIFF');
    byteData.setUint32(4, 36 + dataLength, Endian.little);
    writeAscii(8, 'WAVE');
    writeAscii(12, 'fmt ');
    byteData.setUint32(16, 16, Endian.little);
    byteData.setUint16(20, 1, Endian.little);
    byteData.setUint16(22, channelCount, Endian.little);
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, byteRate, Endian.little);
    byteData.setUint16(32, blockAlign, Endian.little);
    byteData.setUint16(34, bitsPerSample, Endian.little);
    writeAscii(36, 'data');
    byteData.setUint32(40, dataLength, Endian.little);

    final int attackSamples = math.max(1, (sampleRate * 0.01).round());
    final int releaseSamples = math.max(1, (sampleRate * 0.06).round());

    for (int sampleIndex = 0; sampleIndex < totalSamples; sampleIndex++) {
      final double time = sampleIndex / sampleRate;
      final double envelope = _envelopeGain(
        sampleIndex: sampleIndex,
        totalSamples: totalSamples,
        attackSamples: attackSamples,
        releaseSamples: releaseSamples,
      );
      final double sampleValue =
          math.sin(2 * math.pi * frequencyHz * time) * envelope * amplitude;
      final int pcmValue = (sampleValue * 32767).round().clamp(-32768, 32767);
      byteData.setInt16(
        44 + (sampleIndex * blockAlign),
        pcmValue,
        Endian.little,
      );
    }

    return byteData.buffer.asUint8List();
  }

  static double _envelopeGain({
    required int sampleIndex,
    required int totalSamples,
    required int attackSamples,
    required int releaseSamples,
  }) {
    if (sampleIndex < attackSamples) {
      return sampleIndex / attackSamples;
    }

    final int releaseStart = totalSamples - releaseSamples;
    if (sampleIndex >= releaseStart) {
      return (totalSamples - sampleIndex) / releaseSamples;
    }

    return 1;
  }
}
