import 'dart:async';

import 'package:just_audio/just_audio.dart';

import '../music/music_note.dart';
import '../music/pitch_calculator.dart';
import 'piano_note_audio_asset_resolver.dart';
import 'tone_audio_source.dart';

abstract class AudioPlaybackService {
  Future<bool> playNote(MusicNote note);

  Future<bool> playMidiNoteNumber(int midiNoteNumber);

  Future<bool> playAsset(String assetPath);

  Future<void> stop();

  Future<void> dispose();
}

class JustAudioPlaybackService implements AudioPlaybackService {
  JustAudioPlaybackService({
    PianoNoteAudioAssetResolver? noteAudioAssetResolver,
  }) : _noteAudioAssetResolver =
           noteAudioAssetResolver ?? const DefaultPianoNoteAudioAssetResolver();

  final PianoNoteAudioAssetResolver _noteAudioAssetResolver;
  final Set<AudioPlayer> _activePlayers = <AudioPlayer>{};

  @override
  Future<bool> playNote(MusicNote note) async {
    final AudioPlayer player = AudioPlayer();
    _activePlayers.add(player);

    try {
      await player.setAsset(_noteAudioAssetResolver.assetPathForNote(note));
    } catch (_) {
      try {
        await player.setAudioSource(
          WaveToneAudioSource(frequencyHz: note.frequencyHz),
        );
      } catch (_) {
        _activePlayers.remove(player);
        await player.dispose();
        return false;
      }
    }

    unawaited(_playAndRelease(player));
    return true;
  }

  @override
  Future<bool> playMidiNoteNumber(int midiNoteNumber) async {
    final MusicNote? note = PitchCalculator.midiToNote(midiNoteNumber);
    if (note == null) {
      return false;
    }

    return playNote(note);
  }

  @override
  Future<bool> playAsset(String assetPath) async {
    final AudioPlayer player = AudioPlayer();
    _activePlayers.add(player);

    try {
      await player.setAsset(assetPath);
      unawaited(_playAndRelease(player));
      return true;
    } catch (_) {
      _activePlayers.remove(player);
      await player.dispose();
      return false;
    }
  }

  @override
  Future<void> stop() async {
    final List<AudioPlayer> players = List<AudioPlayer>.from(_activePlayers);

    for (final AudioPlayer player in players) {
      try {
        await player.stop();
      } catch (_) {
        // Bir oynatıcı hata verse bile diğerlerini kapatmaya devam ediyoruz.
      } finally {
        _activePlayers.remove(player);
        await player.dispose();
      }
    }
  }

  @override
  Future<void> dispose() async {
    await stop();
  }

  Future<void> _playAndRelease(AudioPlayer player) async {
    try {
      await player.play();
    } catch (_) {
      // Eksik asset veya codec hatalarında uygulamayı düşürmüyoruz.
    } finally {
      _activePlayers.remove(player);
      await player.dispose();
    }
  }
}
