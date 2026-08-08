import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';

const String defaultPianoSoundFontAssetPath =
    'assets/soundfonts/GeneralUser-GS.sf2';
const int _defaultPianoBank = 0;
const int _defaultPianoProgram = 0;
const int _defaultPianoChannel = 0;

enum PianoAudioResultType {
  success,
  invalidMidiNote,
  soundFontMissing,
  soundFontInvalid,
  soundFontNotLoaded,
  engineError,
}

class PianoAudioResult {
  const PianoAudioResult._({
    required this.type,
    required this.activeMidiNotes,
    this.errorDetails,
  });

  const PianoAudioResult.success({Set<int> activeMidiNotes = const <int>{}})
    : this._(
        type: PianoAudioResultType.success,
        activeMidiNotes: activeMidiNotes,
      );

  const PianoAudioResult.invalidMidiNote({required Set<int> activeMidiNotes})
    : this._(
        type: PianoAudioResultType.invalidMidiNote,
        activeMidiNotes: activeMidiNotes,
      );

  const PianoAudioResult.soundFontMissing({required Set<int> activeMidiNotes})
    : this._(
        type: PianoAudioResultType.soundFontMissing,
        activeMidiNotes: activeMidiNotes,
      );

  const PianoAudioResult.soundFontInvalid({required Set<int> activeMidiNotes})
    : this._(
        type: PianoAudioResultType.soundFontInvalid,
        activeMidiNotes: activeMidiNotes,
      );

  const PianoAudioResult.soundFontNotLoaded({required Set<int> activeMidiNotes})
    : this._(
        type: PianoAudioResultType.soundFontNotLoaded,
        activeMidiNotes: activeMidiNotes,
      );

  const PianoAudioResult.engineError({
    required Set<int> activeMidiNotes,
    String? errorDetails,
  }) : this._(
         type: PianoAudioResultType.engineError,
         activeMidiNotes: activeMidiNotes,
         errorDetails: errorDetails,
       );

  final PianoAudioResultType type;
  final Set<int> activeMidiNotes;
  final String? errorDetails;

  bool get isSuccess => type == PianoAudioResultType.success;
}

abstract class PianoAudioService {
  bool get isInitialized;

  bool get isSoundFontLoaded;

  bool get isSustainEnabled;

  Set<int> get activeMidiNotes;

  Future<PianoAudioResult> initialize();

  Future<PianoAudioResult> loadSoundFont(String assetPath);

  Future<PianoAudioResult> playNote(int midiNote, {int velocity = 100});

  Future<PianoAudioResult> stopNote(int midiNote);

  Future<PianoAudioResult> playChord(Set<int> midiNotes, {int velocity = 100});

  Future<PianoAudioResult> setSustainEnabled(bool enabled);

  Future<PianoAudioResult> stopAll();

  Future<void> dispose();
}

class MidiProPianoAudioService implements PianoAudioService {
  MidiProPianoAudioService({MidiPro? midiPro})
    : _midiPro = midiPro ?? MidiPro();

  final MidiPro _midiPro;
  final Set<int> _activeMidiNotes = <int>{};

  int? _soundFontId;
  bool _isInitialized = false;
  String? _loadedAssetPath;
  PianoAudioResultType? _lastLoadFailureType;
  String? _lastLoadErrorDetails;
  bool _isSustainEnabled = false;

  @override
  bool get isInitialized => _isInitialized || _midiPro.isInitialized;

  @override
  bool get isSoundFontLoaded => _soundFontId != null;

  @override
  bool get isSustainEnabled => _isSustainEnabled;

  @override
  Set<int> get activeMidiNotes => Set<int>.unmodifiable(_activeMidiNotes);

  @override
  Future<PianoAudioResult> initialize() async {
    if (isInitialized) {
      _isInitialized = true;
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    }

    try {
      await _midiPro.init();
      _isInitialized = true;
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    } on Object catch (error) {
      _isInitialized = false;
      return PianoAudioResult.engineError(
        activeMidiNotes: activeMidiNotes,
        errorDetails: '$error',
      );
    }
  }

  @override
  Future<PianoAudioResult> loadSoundFont(String assetPath) async {
    final PianoAudioResult initResult = await initialize();
    if (!initResult.isSuccess) {
      return initResult;
    }

    if (_soundFontId != null && _loadedAssetPath == assetPath) {
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    }

    ByteData soundFontData;
    try {
      soundFontData = await rootBundle.load(assetPath);
    } on FlutterError {
      return _registerLoadFailure(PianoAudioResultType.soundFontMissing);
    } on Object catch (error) {
      return _registerLoadFailure(
        PianoAudioResultType.engineError,
        errorDetails: '$error',
      );
    }

    final Uint8List soundFontBytes = soundFontData.buffer.asUint8List(
      soundFontData.offsetInBytes,
      soundFontData.lengthInBytes,
    );

    if (!_looksLikeSoundFont(soundFontBytes)) {
      return _registerLoadFailure(PianoAudioResultType.soundFontInvalid);
    }

    try {
      if (_soundFontId != null) {
        await _midiPro.unloadSoundfont(_soundFontId!);
      }

      final int soundFontId = await _midiPro.loadSoundfontAsset(
        assetPath: assetPath,
        bank: _defaultPianoBank,
        program: _defaultPianoProgram,
      );
      try {
        await _midiPro.selectInstrument(
          sfId: soundFontId,
          channel: _defaultPianoChannel,
          bank: _defaultPianoBank,
          program: _defaultPianoProgram,
        );
      } catch (_) {
        try {
          await _midiPro.unloadSoundfont(soundFontId);
        } catch (_) {
          // Enstrüman seçimi başarısız olduğunda önceki hatayı maskelemiyoruz.
        }
        rethrow;
      }

      _soundFontId = soundFontId;
      _loadedAssetPath = assetPath;
      _lastLoadFailureType = null;
      _lastLoadErrorDetails = null;
      _isSustainEnabled = false;
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    } on Object catch (error) {
      return _registerLoadFailure(
        PianoAudioResultType.engineError,
        errorDetails: '$error',
      );
    }
  }

  @override
  Future<PianoAudioResult> playNote(int midiNote, {int velocity = 100}) async {
    if (!_isValidMidiNote(midiNote)) {
      return PianoAudioResult.invalidMidiNote(activeMidiNotes: activeMidiNotes);
    }

    final PianoAudioResult initResult = await initialize();
    if (!initResult.isSuccess) {
      return initResult;
    }

    if (_soundFontId == null) {
      return _buildUnavailableSoundFontResult();
    }

    try {
      if (_activeMidiNotes.contains(midiNote)) {
        await _midiPro.stopNote(
          sfId: _soundFontId!,
          channel: _defaultPianoChannel,
          key: midiNote,
        );
      }

      await _midiPro.playNote(
        sfId: _soundFontId!,
        channel: _defaultPianoChannel,
        key: midiNote,
        velocity: velocity.clamp(0, 127).toInt(),
      );
      _activeMidiNotes.add(midiNote);
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    } on Object catch (error) {
      return PianoAudioResult.engineError(
        activeMidiNotes: activeMidiNotes,
        errorDetails: '$error',
      );
    }
  }

  @override
  Future<PianoAudioResult> stopNote(int midiNote) async {
    if (!_isValidMidiNote(midiNote)) {
      return PianoAudioResult.invalidMidiNote(activeMidiNotes: activeMidiNotes);
    }

    _activeMidiNotes.remove(midiNote);

    if (!isInitialized || _soundFontId == null) {
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    }

    try {
      await _midiPro.stopNote(
        sfId: _soundFontId!,
        channel: _defaultPianoChannel,
        key: midiNote,
      );
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    } on Object catch (error) {
      return PianoAudioResult.engineError(
        activeMidiNotes: activeMidiNotes,
        errorDetails: '$error',
      );
    }
  }

  @override
  Future<PianoAudioResult> playChord(
    Set<int> midiNotes, {
    int velocity = 100,
  }) async {
    if (midiNotes.any((int midiNote) => !_isValidMidiNote(midiNote))) {
      return PianoAudioResult.invalidMidiNote(activeMidiNotes: activeMidiNotes);
    }

    final PianoAudioResult initResult = await initialize();
    if (!initResult.isSuccess) {
      return initResult;
    }

    if (_soundFontId == null) {
      return _buildUnavailableSoundFontResult();
    }

    try {
      for (final int midiNote in midiNotes) {
        if (_activeMidiNotes.contains(midiNote)) {
          await _midiPro.stopNote(
            sfId: _soundFontId!,
            channel: _defaultPianoChannel,
            key: midiNote,
          );
        }
      }

      for (final int midiNote in midiNotes) {
        await _midiPro.playNote(
          sfId: _soundFontId!,
          channel: _defaultPianoChannel,
          key: midiNote,
          velocity: velocity.clamp(0, 127).toInt(),
        );
      }

      _activeMidiNotes.addAll(midiNotes);
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    } on Object catch (error) {
      return PianoAudioResult.engineError(
        activeMidiNotes: activeMidiNotes,
        errorDetails: '$error',
      );
    }
  }

  @override
  Future<PianoAudioResult> setSustainEnabled(bool enabled) async {
    final PianoAudioResult initResult = await initialize();
    if (!initResult.isSuccess) {
      return initResult;
    }

    if (_soundFontId == null) {
      return _buildUnavailableSoundFontResult();
    }

    try {
      await _midiPro.setSustain(
        enabled: enabled,
        channel: _defaultPianoChannel,
        sfId: _soundFontId!,
      );
      _isSustainEnabled = enabled;
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    } on Object catch (error) {
      return PianoAudioResult.engineError(
        activeMidiNotes: activeMidiNotes,
        errorDetails: '$error',
      );
    }
  }

  @override
  Future<PianoAudioResult> stopAll() async {
    _activeMidiNotes.clear();
    _isSustainEnabled = false;

    if (!isInitialized || _soundFontId == null) {
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    }

    try {
      await _midiPro.panic();
      return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
    } on Object catch (error) {
      return PianoAudioResult.engineError(
        activeMidiNotes: activeMidiNotes,
        errorDetails: '$error',
      );
    }
  }

  @override
  Future<void> dispose() async {
    _activeMidiNotes.clear();
    _soundFontId = null;
    _loadedAssetPath = null;
    _lastLoadFailureType = null;
    _lastLoadErrorDetails = null;
    _isSustainEnabled = false;

    if (!isInitialized) {
      _isInitialized = false;
      return;
    }

    try {
      await _midiPro.dispose();
    } catch (_) {
      // Servis kapanışı sırasında hata olsa da uygulamayı düşürmüyoruz.
    } finally {
      _isInitialized = false;
    }
  }

  PianoAudioResult _registerLoadFailure(
    PianoAudioResultType type, {
    String? errorDetails,
  }) {
    _soundFontId = null;
    _loadedAssetPath = null;
    _lastLoadFailureType = type;
    _lastLoadErrorDetails = errorDetails;

    return switch (type) {
      PianoAudioResultType.soundFontMissing =>
        PianoAudioResult.soundFontMissing(activeMidiNotes: activeMidiNotes),
      PianoAudioResultType.soundFontInvalid =>
        PianoAudioResult.soundFontInvalid(activeMidiNotes: activeMidiNotes),
      PianoAudioResultType.engineError => PianoAudioResult.engineError(
        activeMidiNotes: activeMidiNotes,
        errorDetails: errorDetails,
      ),
      PianoAudioResultType.soundFontNotLoaded =>
        PianoAudioResult.soundFontNotLoaded(activeMidiNotes: activeMidiNotes),
      PianoAudioResultType.invalidMidiNote => PianoAudioResult.invalidMidiNote(
        activeMidiNotes: activeMidiNotes,
      ),
      PianoAudioResultType.success => PianoAudioResult.success(
        activeMidiNotes: activeMidiNotes,
      ),
    };
  }

  PianoAudioResult _buildUnavailableSoundFontResult() {
    return _registerLoadFailure(
      _lastLoadFailureType ?? PianoAudioResultType.soundFontNotLoaded,
      errorDetails: _lastLoadErrorDetails,
    );
  }

  bool _looksLikeSoundFont(Uint8List bytes) {
    if (bytes.lengthInBytes < 12) {
      return false;
    }

    // SF2 files are RIFF containers whose form type is `sfbk`.
    return bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x73 &&
        bytes[9] == 0x66 &&
        bytes[10] == 0x62 &&
        bytes[11] == 0x6b;
  }

  bool _isValidMidiNote(int midiNote) => midiNote >= 0 && midiNote <= 127;
}

class FakePianoAudioService implements PianoAudioService {
  FakePianoAudioService({
    this.soundFontExists = true,
    this.soundFontIsValid = true,
    this.initializationSucceeds = true,
    this.soundFontLoadSucceeds = true,
  });

  final bool soundFontExists;
  final bool soundFontIsValid;
  final bool initializationSucceeds;
  final bool soundFontLoadSucceeds;

  final Set<int> _activeMidiNotes = <int>{};
  final List<int> playedMidiNotes = <int>[];
  final List<int> stoppedMidiNotes = <int>[];
  final List<Set<int>> playedChords = <Set<int>>[];
  final List<String> loadedSoundFonts = <String>[];
  final List<bool> sustainChanges = <bool>[];
  int stopAllCallCount = 0;

  bool _isInitialized = false;
  bool _isSoundFontLoaded = false;
  bool _isSustainEnabled = false;
  PianoAudioResultType? _lastLoadFailureType;

  @override
  bool get isInitialized => _isInitialized;

  @override
  bool get isSoundFontLoaded => _isSoundFontLoaded;

  @override
  bool get isSustainEnabled => _isSustainEnabled;

  @override
  Set<int> get activeMidiNotes => Set<int>.unmodifiable(_activeMidiNotes);

  @override
  Future<PianoAudioResult> initialize() async {
    if (!initializationSucceeds) {
      return PianoAudioResult.engineError(activeMidiNotes: activeMidiNotes);
    }

    _isInitialized = true;
    return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
  }

  @override
  Future<PianoAudioResult> loadSoundFont(String assetPath) async {
    final PianoAudioResult initResult = await initialize();
    if (!initResult.isSuccess) {
      return initResult;
    }

    loadedSoundFonts.add(assetPath);

    if (!soundFontExists) {
      _isSoundFontLoaded = false;
      _lastLoadFailureType = PianoAudioResultType.soundFontMissing;
      return PianoAudioResult.soundFontMissing(
        activeMidiNotes: activeMidiNotes,
      );
    }

    if (!soundFontIsValid) {
      _isSoundFontLoaded = false;
      _lastLoadFailureType = PianoAudioResultType.soundFontInvalid;
      return PianoAudioResult.soundFontInvalid(
        activeMidiNotes: activeMidiNotes,
      );
    }

    if (!soundFontLoadSucceeds) {
      _isSoundFontLoaded = false;
      _lastLoadFailureType = PianoAudioResultType.engineError;
      return PianoAudioResult.engineError(activeMidiNotes: activeMidiNotes);
    }

    _isSoundFontLoaded = true;
    _isSustainEnabled = false;
    _lastLoadFailureType = null;
    return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
  }

  @override
  Future<PianoAudioResult> playNote(int midiNote, {int velocity = 100}) async {
    if (midiNote < 0 || midiNote > 127) {
      return PianoAudioResult.invalidMidiNote(activeMidiNotes: activeMidiNotes);
    }

    if (!_isSoundFontLoaded) {
      return _buildUnavailableSoundFontResult();
    }

    playedMidiNotes.add(midiNote);
    _activeMidiNotes.add(midiNote);
    return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
  }

  @override
  Future<PianoAudioResult> stopNote(int midiNote) async {
    stoppedMidiNotes.add(midiNote);
    _activeMidiNotes.remove(midiNote);
    return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
  }

  @override
  Future<PianoAudioResult> playChord(
    Set<int> midiNotes, {
    int velocity = 100,
  }) async {
    if (midiNotes.any((int midiNote) => midiNote < 0 || midiNote > 127)) {
      return PianoAudioResult.invalidMidiNote(activeMidiNotes: activeMidiNotes);
    }

    if (!_isSoundFontLoaded) {
      return _buildUnavailableSoundFontResult();
    }

    playedChords.add(Set<int>.from(midiNotes));
    _activeMidiNotes.addAll(midiNotes);
    return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
  }

  @override
  Future<PianoAudioResult> setSustainEnabled(bool enabled) async {
    if (!_isSoundFontLoaded) {
      return _buildUnavailableSoundFontResult();
    }

    sustainChanges.add(enabled);
    _isSustainEnabled = enabled;
    return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
  }

  @override
  Future<PianoAudioResult> stopAll() async {
    stopAllCallCount++;
    _activeMidiNotes.clear();
    _isSustainEnabled = false;
    return PianoAudioResult.success(activeMidiNotes: activeMidiNotes);
  }

  @override
  Future<void> dispose() async {
    _activeMidiNotes.clear();
    _isInitialized = false;
    _isSoundFontLoaded = false;
    _isSustainEnabled = false;
    _lastLoadFailureType = null;
  }

  PianoAudioResult _buildUnavailableSoundFontResult() {
    return switch (_lastLoadFailureType) {
      PianoAudioResultType.soundFontMissing =>
        PianoAudioResult.soundFontMissing(activeMidiNotes: activeMidiNotes),
      PianoAudioResultType.soundFontInvalid =>
        PianoAudioResult.soundFontInvalid(activeMidiNotes: activeMidiNotes),
      PianoAudioResultType.engineError => PianoAudioResult.engineError(
        activeMidiNotes: activeMidiNotes,
      ),
      _ => PianoAudioResult.soundFontNotLoaded(
        activeMidiNotes: activeMidiNotes,
      ),
    };
  }
}
