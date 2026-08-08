import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_providers.dart';
import '../../../core/music/music_localizations.dart';
import '../../../core/audio/piano_audio_service.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/pitch_calculator.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/piano/piano_panel.dart';

class FreePianoScreen extends ConsumerStatefulWidget {
  const FreePianoScreen({super.key});

  @override
  ConsumerState<FreePianoScreen> createState() => _FreePianoScreenState();
}

class _FreePianoScreenState extends ConsumerState<FreePianoScreen> {
  Set<int> _pressedMidiNotes = const <int>{};
  MusicNote? _lastPlayedNote;
  String? _soundFontStatusMessage;
  bool _isSoundFontLoaded = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initializePianoAudio());
  }

  @override
  void dispose() {
    unawaited(ref.read(pianoAudioServiceProvider).stopAll());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.freePianoAppBarTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.freePianoHeaderTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.freePianoHeaderDescription,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PianoPanel(
                highlightedMidiNotes: const <int>{},
                pressedMidiNotes: _pressedMidiNotes,
                showHighlightedMidiNotes: false,
                autoFollowHighlightedNotes: false,
                onShowHighlightedMidiNotesChanged: (_) {},
                onAutoFollowHighlightedNotesChanged: (_) {},
                onNotePressed: (int midiNoteNumber) {
                  unawaited(_handleNotePressed(midiNoteNumber));
                },
                onNoteReleased: (int midiNoteNumber) {
                  unawaited(_handleNoteReleased(midiNoteNumber));
                },
                onPlayLa4DemoPressed: _noop,
                onPlayCMajorChordDemoPressed: _noop,
                lastPlayedNote: _lastPlayedNote,
                soundFontStatusMessage: _soundFontStatusMessage,
                isSoundFontLoaded: _isSoundFontLoaded,
                initiallyExpanded: true,
                showDemoActions: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializePianoAudio() async {
    final PianoAudioService service = ref.read(pianoAudioServiceProvider);
    _applyAudioResult(await service.initialize());
    _applyAudioResult(
      await service.loadSoundFont(defaultPianoSoundFontAssetPath),
    );
  }

  Future<void> _handleNotePressed(int midiNoteNumber) async {
    final MusicNote? note = PitchCalculator.midiToNote(midiNoteNumber);
    if (note == null) {
      return;
    }

    setState(() {
      _pressedMidiNotes = <int>{..._pressedMidiNotes, midiNoteNumber};
      _lastPlayedNote = note;
    });

    final PianoAudioResult result = await ref
        .read(pianoAudioServiceProvider)
        .playNote(midiNoteNumber);
    _applyAudioResult(result);
  }

  Future<void> _handleNoteReleased(int midiNoteNumber) async {
    setState(() {
      _pressedMidiNotes = _pressedMidiNotes
          .where((int note) => note != midiNoteNumber)
          .toSet();
    });

    final PianoAudioResult result = await ref
        .read(pianoAudioServiceProvider)
        .stopNote(midiNoteNumber);
    _applyAudioResult(result);
  }

  void _applyAudioResult(PianoAudioResult result) {
    if (!mounted) {
      return;
    }

    final PianoAudioService service = ref.read(pianoAudioServiceProvider);
    final AppLocalizations l10n = context.l10n;

    setState(() {
      _isSoundFontLoaded = service.isSoundFontLoaded;

      if (result.isSuccess) {
        _soundFontStatusMessage = _isSoundFontLoaded
            ? result.type.localizedMessage(l10n)
            : _soundFontStatusMessage;
      } else {
        _soundFontStatusMessage = result.type.localizedMessage(l10n);
      }
    });
  }

  void _noop() {}
}
