import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/note_naming_controller.dart';
import '../../../core/audio/audio_providers.dart';
import '../../../core/audio/piano_audio_service.dart';
import '../../../core/music/music_localizations.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/note_label_formatter.dart';
import '../../../core/music/note_naming_system.dart';
import '../../../core/music/piano_keyboard_layout.dart';
import '../../../core/music/piano_note_range.dart';
import '../../../core/music/pitch_calculator.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/piano/piano_keyboard.dart';

class FreePianoScreen extends ConsumerStatefulWidget {
  const FreePianoScreen({super.key});

  @override
  ConsumerState<FreePianoScreen> createState() => _FreePianoScreenState();
}

class _FreePianoScreenState extends ConsumerState<FreePianoScreen>
    with WidgetsBindingObserver {
  static const Duration _demoDuration = Duration(seconds: 1);
  static const int _demoVelocity = 100;
  static const int _visibleOctaveCount = 2;
  static const double _whiteKeyWidth = 64;

  late final PianoAudioService _pianoAudioService;
  Set<int> _pressedMidiNotes = const <int>{};
  Set<int> _highlightedMidiNotes = const <int>{};
  MusicNote? _lastPlayedNote;
  String? _soundFontStatusMessage;
  bool _isSoundFontLoaded = false;
  bool _isSustainEnabled = false;
  bool _showNoteLabels = true;
  int _currentStartOctave = 4;
  int _playbackSessionId = 0;

  PianoNoteRange get _supportedRange => PianoKeyboardLayout.supportedRange;

  PianoNoteRange get _visibleRange =>
      PianoKeyboardLayout.visibleRangeForOctaveStart(
        _currentStartOctave,
        range: _supportedRange,
        visibleOctaveCount: _visibleOctaveCount,
      );

  bool get _canMoveToPreviousOctave {
    return _currentStartOctave > _supportedRange.minOctave;
  }

  bool get _canMoveToNextOctave {
    return _currentStartOctave <
        _supportedRange.maxStartOctave(visibleOctaveCount: _visibleOctaveCount);
  }

  @override
  void initState() {
    super.initState();
    _pianoAudioService = ref.read(pianoAudioServiceProvider);
    WidgetsBinding.instance.addObserver(this);
    _currentStartOctave = _supportedRange.clampVisibleStartOctave(
      4,
      visibleOctaveCount: _visibleOctaveCount,
    );
    unawaited(_initializePianoAudio());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_stopAllPlayback(clearHighlights: true));
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        unawaited(_stopAllPlayback(clearHighlights: true));
      case AppLifecycleState.resumed:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;
    final NoteNamingSystem noteNamingSystem = ref.watch(
      noteNamingControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.freePianoAppBarTitle)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double keyboardHeight = (constraints.maxHeight * 0.38).clamp(
              220.0,
              280.0,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_soundFontStatusMessage != null)
                      _StatusBanner(
                        message: _soundFontStatusMessage!,
                        isReady: _isSoundFontLoaded,
                      ),
                    _LastPlayedNoteSection(
                      lastPlayedNote: _lastPlayedNote,
                      noteNamingSystem: noteNamingSystem,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        SizedBox(
                          width: 220,
                          child: SwitchListTile.adaptive(
                            key: const ValueKey<String>(
                              'free-piano-show-note-names',
                            ),
                            contentPadding: EdgeInsets.zero,
                            value: _showNoteLabels,
                            onChanged: (bool value) {
                              setState(() {
                                _showNoteLabels = value;
                              });
                            },
                            title: Text(l10n.showNoteNamesOnKeys),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: SwitchListTile.adaptive(
                            key: const ValueKey<String>(
                              'free-piano-sustain-switch',
                            ),
                            contentPadding: EdgeInsets.zero,
                            value: _isSustainEnabled,
                            onChanged: (bool value) {
                              unawaited(_handleSustainChanged(value));
                            },
                            title: Text(l10n.sustainLabel),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton.tonalIcon(
                          key: const ValueKey<String>('free-piano-stop-all'),
                          onPressed: () {
                            unawaited(_stopAllPlayback(clearHighlights: true));
                          },
                          icon: const Icon(Icons.stop_circle_outlined),
                          label: Text(l10n.stopAllPianoButton),
                        ),
                        OutlinedButton.icon(
                          key: const ValueKey<String>('free-piano-demo-a4'),
                          onPressed: () {
                            unawaited(
                              _playDemoNotes(
                                const <int>{69},
                                lastPlayedNote: PitchCalculator.midiToNote(69),
                              ),
                            );
                          },
                          icon: const Icon(Icons.music_note_rounded),
                          label: Text(l10n.playA4DemoButton),
                        ),
                        OutlinedButton.icon(
                          key: const ValueKey<String>(
                            'free-piano-demo-c-major',
                          ),
                          onPressed: () {
                            unawaited(
                              _playDemoNotes(
                                const <int>{60, 64, 67},
                                lastPlayedNote: PitchCalculator.midiToNote(67),
                              ),
                            );
                          },
                          icon: const Icon(Icons.library_music_rounded),
                          label: Text(l10n.playCMajorDemoButton),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _OctaveControls(
                      rangeLabel: l10n.octaveRangeLabel(
                        _currentStartOctave,
                        _currentStartOctave + (_visibleOctaveCount - 1),
                      ),
                      canMoveToPreviousOctave: _canMoveToPreviousOctave,
                      canMoveToNextOctave: _canMoveToNextOctave,
                      onPreviousPressed: () {
                        unawaited(_changeOctave(-1));
                      },
                      onNextPressed: () {
                        unawaited(_changeOctave(1));
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: keyboardHeight + 28,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: PianoKeyboard(
                                startMidiNote:
                                    _visibleRange.startMidiNoteNumber,
                                endMidiNote: _visibleRange.endMidiNoteNumber,
                                highlightedMidiNotes: _highlightedMidiNotes,
                                pressedMidiNotes: _pressedMidiNotes,
                                showNoteLabels: _showNoteLabels,
                                noteNamingSystem: noteNamingSystem,
                                pianoHeight: keyboardHeight,
                                whiteKeyWidth: _whiteKeyWidth,
                                onNoteReleased: (int midiNoteNumber) {
                                  unawaited(
                                    _handleNoteReleased(midiNoteNumber),
                                  );
                                },
                                onNoteTouchDown:
                                    (PianoNoteTouchDetails details) {
                                      unawaited(_handleNotePressed(details));
                                    },
                                onNoteTouchSlide: _handleNoteSlide,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _initializePianoAudio() async {
    _applyAudioResult(await _pianoAudioService.initialize());
    _applyAudioResult(
      await _pianoAudioService.loadSoundFont(defaultPianoSoundFontAssetPath),
    );
  }

  Future<void> _handleNotePressed(PianoNoteTouchDetails details) async {
    final MusicNote? note = PitchCalculator.midiToNote(details.midiNote);
    if (note == null) {
      return;
    }

    if (mounted) {
      setState(() {
        _pressedMidiNotes = <int>{..._pressedMidiNotes, details.midiNote};
        _lastPlayedNote = note;
      });
    }

    final PianoAudioResult result = await _pianoAudioService.playNote(
      details.midiNote,
      velocity: _resolveVelocity(details),
    );
    _applyAudioResult(result);
  }

  Future<void> _handleNoteReleased(int midiNoteNumber) async {
    if (mounted) {
      setState(() {
        _pressedMidiNotes = _pressedMidiNotes
            .where((int note) => note != midiNoteNumber)
            .toSet();
      });
    }

    final PianoAudioResult result = await _pianoAudioService.stopNote(
      midiNoteNumber,
    );
    _applyAudioResult(result);
  }

  void _handleNoteSlide(PianoNoteTouchDetails details) {
    // Intentionally kept as a dedicated hook so velocity / aftertouch logic
    // can evolve later without changing the widget contract.
  }

  Future<void> _handleSustainChanged(bool enabled) async {
    final PianoAudioResult result = await _pianoAudioService.setSustainEnabled(
      enabled,
    );
    _applyAudioResult(result);
  }

  Future<void> _changeOctave(int delta) async {
    final int nextStartOctave = _supportedRange.clampVisibleStartOctave(
      _currentStartOctave + delta,
      visibleOctaveCount: _visibleOctaveCount,
    );

    if (nextStartOctave == _currentStartOctave) {
      return;
    }

    if (_pressedMidiNotes.isNotEmpty ||
        _highlightedMidiNotes.isNotEmpty ||
        _isSustainEnabled) {
      await _stopAllPlayback(clearHighlights: true);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _currentStartOctave = nextStartOctave;
    });
  }

  Future<void> _playDemoNotes(
    Set<int> midiNotes, {
    required MusicNote? lastPlayedNote,
  }) async {
    final int sessionId = ++_playbackSessionId;
    await _stopAllPlayback(clearHighlights: true, incrementSession: false);
    if (!mounted) {
      return;
    }

    setState(() {
      _highlightedMidiNotes = Set<int>.unmodifiable(midiNotes);
      _lastPlayedNote = lastPlayedNote;
    });

    final PianoAudioResult result = await _pianoAudioService.playChord(
      midiNotes,
      velocity: _demoVelocity,
    );
    _applyAudioResult(result);

    await Future<void>.delayed(_demoDuration);
    if (!mounted || sessionId != _playbackSessionId) {
      return;
    }

    for (final int midiNote in midiNotes) {
      final PianoAudioResult noteOffResult = await _pianoAudioService.stopNote(
        midiNote,
      );
      _applyAudioResult(noteOffResult);
    }

    if (!mounted || sessionId != _playbackSessionId) {
      return;
    }

    setState(() {
      _highlightedMidiNotes = const <int>{};
    });
  }

  Future<void> _stopAllPlayback({
    bool clearHighlights = false,
    bool incrementSession = true,
  }) async {
    if (incrementSession) {
      _playbackSessionId++;
    }

    final PianoAudioResult result = await _pianoAudioService.stopAll();
    _applyAudioResult(result);

    if (!mounted) {
      return;
    }

    setState(() {
      _pressedMidiNotes = const <int>{};
      if (clearHighlights) {
        _highlightedMidiNotes = const <int>{};
      }
    });
  }

  void _applyAudioResult(PianoAudioResult result) {
    if (!mounted) {
      return;
    }

    final AppLocalizations l10n = context.l10n;

    setState(() {
      _isSoundFontLoaded = _pianoAudioService.isSoundFontLoaded;
      _isSustainEnabled = _pianoAudioService.isSustainEnabled;

      if (result.isSuccess) {
        _soundFontStatusMessage = _isSoundFontLoaded
            ? result.type.localizedMessage(l10n)
            : _soundFontStatusMessage;
      } else {
        _soundFontStatusMessage = result.type.localizedMessage(l10n);
      }
    });
  }

  int _resolveVelocity(PianoNoteTouchDetails details) {
    return 100;
  }
}

class _OctaveControls extends StatelessWidget {
  const _OctaveControls({
    required this.rangeLabel,
    required this.canMoveToPreviousOctave,
    required this.canMoveToNextOctave,
    required this.onPreviousPressed,
    required this.onNextPressed,
  });

  final String rangeLabel;
  final bool canMoveToPreviousOctave;
  final bool canMoveToNextOctave;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            key: const ValueKey<String>('free-piano-prev-octave'),
            onPressed: canMoveToPreviousOctave ? onPreviousPressed : null,
            icon: const Icon(Icons.chevron_left_rounded),
            label: Text(l10n.previousOctave),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              rangeLabel,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            key: const ValueKey<String>('free-piano-next-octave'),
            onPressed: canMoveToNextOctave ? onNextPressed : null,
            icon: const Icon(Icons.chevron_right_rounded),
            label: Text(l10n.nextOctave),
          ),
        ),
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.message, required this.isReady});

  final String message;
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      key: const ValueKey<String>('free-piano-soundfont-message'),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isReady
            ? colorScheme.primaryContainer
            : colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            isReady ? Icons.check_circle_outline_rounded : Icons.info_outline,
            color: isReady
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isReady
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LastPlayedNoteSection extends StatelessWidget {
  const _LastPlayedNoteSection({
    required this.lastPlayedNote,
    required this.noteNamingSystem,
  });

  static const NoteLabelFormatter _noteLabelFormatter = NoteLabelFormatter();

  final MusicNote? lastPlayedNote;
  final NoteNamingSystem noteNamingSystem;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.lastPlayedNoteTitle,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lastPlayedNote == null
                ? l10n.noNotePlayedYet
                : _noteLabelFormatter.formatScientificName(
                    lastPlayedNote!,
                    namingSystem: noteNamingSystem,
                  ),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          if (lastPlayedNote != null)
            Text(
              l10n.lastPlayedNoteDetails(
                _noteLabelFormatter.formatScientificName(
                  lastPlayedNote!,
                  namingSystem: NoteNamingSystem.letterNames,
                ),
                lastPlayedNote!.midiNoteNumber,
                _formatFrequency(context, lastPlayedNote!.frequencyHz),
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            )
          else
            Text(
              l10n.lastPlayedNoteHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
        ],
      ),
    );
  }

  String _formatFrequency(BuildContext context, double value) {
    final String localeName = Localizations.localeOf(context).toLanguageTag();
    final NumberFormat format = NumberFormat.decimalPatternDigits(
      locale: localeName,
      decimalDigits: 2,
    );
    return '${format.format(value)} Hz';
  }
}
