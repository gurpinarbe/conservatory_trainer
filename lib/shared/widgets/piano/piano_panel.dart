import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/note_naming_controller.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/note_label_formatter.dart';
import '../../../core/music/note_naming_system.dart';
import '../../../core/music/piano_keyboard_layout.dart';
import '../../../core/music/piano_note_range.dart';
import '../../../core/music/pitch_calculator.dart';
import '../../../l10n/l10n.dart';
import 'piano_keyboard.dart';

class PianoPanel extends StatefulWidget {
  const PianoPanel({
    super.key,
    required this.highlightedMidiNotes,
    required this.pressedMidiNotes,
    required this.showHighlightedMidiNotes,
    required this.autoFollowHighlightedNotes,
    required this.onShowHighlightedMidiNotesChanged,
    required this.onAutoFollowHighlightedNotesChanged,
    required this.onNotePressed,
    required this.onNoteReleased,
    required this.onPlayLa4DemoPressed,
    required this.onPlayCMajorChordDemoPressed,
    this.onDevelopmentDemoPressed,
    this.lastPlayedNote,
    this.noteRange = PianoKeyboardLayout.supportedRange,
    this.initialOctave = 4,
    this.initiallyExpanded = false,
    this.showDemoActions = true,
    this.soundFontStatusMessage,
    this.isSoundFontLoaded = false,
  });

  final Set<int> highlightedMidiNotes;
  final Set<int> pressedMidiNotes;
  final bool showHighlightedMidiNotes;
  final bool autoFollowHighlightedNotes;
  final ValueChanged<bool> onShowHighlightedMidiNotesChanged;
  final ValueChanged<bool> onAutoFollowHighlightedNotesChanged;
  final ValueChanged<int> onNotePressed;
  final ValueChanged<int> onNoteReleased;
  final VoidCallback onPlayLa4DemoPressed;
  final VoidCallback onPlayCMajorChordDemoPressed;
  final VoidCallback? onDevelopmentDemoPressed;
  final MusicNote? lastPlayedNote;
  final PianoNoteRange noteRange;
  final int initialOctave;
  final bool initiallyExpanded;
  final bool showDemoActions;
  final String? soundFontStatusMessage;
  final bool isSoundFontLoaded;

  @override
  State<PianoPanel> createState() => _PianoPanelState();
}

class _PianoPanelState extends State<PianoPanel> {
  static const Duration _panelAnimationDuration = Duration(milliseconds: 240);
  static const int _visibleOctaveCount = 2;
  static const NoteLabelFormatter _noteLabelFormatter = NoteLabelFormatter();

  late int _currentOctave;
  bool _isExpanded = false;
  bool _showNoteLabels = false;

  Set<int> get _visibleHighlightedMidiNotes {
    return widget.showHighlightedMidiNotes
        ? widget.highlightedMidiNotes
        : const <int>{};
  }

  PianoNoteRange get _visibleRange =>
      PianoKeyboardLayout.visibleRangeForOctaveStart(
        _currentOctave,
        range: widget.noteRange,
        visibleOctaveCount: _visibleOctaveCount,
      );

  bool get _canMoveToPreviousOctave {
    return _currentOctave > widget.noteRange.minOctave;
  }

  bool get _canMoveToNextOctave {
    return _currentOctave <
        widget.noteRange.maxStartOctave(
          visibleOctaveCount: _visibleOctaveCount,
        );
  }

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _currentOctave = widget.noteRange.clampVisibleStartOctave(
      widget.initialOctave,
      visibleOctaveCount: _visibleOctaveCount,
    );
  }

  @override
  void didUpdateWidget(covariant PianoPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool shouldAutoFollow =
        widget.autoFollowHighlightedNotes &&
        widget.highlightedMidiNotes.isNotEmpty &&
        oldWidget.highlightedMidiNotes != widget.highlightedMidiNotes;

    if (shouldAutoFollow) {
      setState(() {
        _currentOctave = PianoKeyboardLayout.startOctaveForHighlightedNotes(
          widget.highlightedMidiNotes,
          range: widget.noteRange,
          fallbackOctave: _currentOctave,
          visibleOctaveCount: _visibleOctaveCount,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;
    final NoteNamingSystem noteNamingSystem = ProviderScope.containerOf(
      context,
      listen: true,
    ).read(noteNamingControllerProvider);
    final MusicNote? lastPlayedNote = widget.lastPlayedNote;
    final MusicNote la4 = PitchCalculator.midiToNote(69)!;
    final MusicNote c4 = PitchCalculator.midiToNote(60)!;
    final String la4Label = _noteLabelFormatter.formatScientificName(
      la4,
      namingSystem: noteNamingSystem,
    );
    final String cMajorRoot = _noteLabelFormatter.formatPitchClass(
      c4.pitchClass,
      namingSystem: noteNamingSystem,
    );

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                key: const ValueKey<String>('piano-panel-toggle'),
                onPressed: _toggleExpanded,
                icon: Icon(
                  _isExpanded
                      ? Icons.keyboard_hide_rounded
                      : Icons.piano_rounded,
                ),
                label: Text(
                  _isExpanded ? l10n.pianoCloseButton : l10n.pianoOpenButton,
                ),
              ),
            ),
            AnimatedSize(
              duration: _panelAnimationDuration,
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.soundFontStatusMessage != null)
                            _StatusBanner(
                              message: widget.soundFontStatusMessage!,
                              isReady: widget.isSoundFontLoaded,
                            ),
                          _LastPlayedNoteCard(
                            lastPlayedNote: lastPlayedNote,
                            noteNamingSystem: noteNamingSystem,
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            value: widget.showHighlightedMidiNotes,
                            onChanged: widget.onShowHighlightedMidiNotesChanged,
                            title: Text(l10n.showExerciseNotesOnPiano),
                          ),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            value: widget.autoFollowHighlightedNotes,
                            onChanged:
                                widget.onAutoFollowHighlightedNotesChanged,
                            title: Text(l10n.followHighlightByOctave),
                          ),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            value: _showNoteLabels,
                            onChanged: (bool value) {
                              setState(() {
                                _showNoteLabels = value;
                              });
                            },
                            title: Text(l10n.showNoteNamesOnKeys),
                          ),
                          const SizedBox(height: 8),
                          if (widget.showDemoActions) ...[
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                FilledButton.tonalIcon(
                                  key: const ValueKey<String>(
                                    'piano-demo-la4-button',
                                  ),
                                  onPressed: widget.onPlayLa4DemoPressed,
                                  icon: const Icon(Icons.music_note_rounded),
                                  label: Text(
                                    l10n.playReferenceNoteButton(la4Label),
                                  ),
                                ),
                                FilledButton.tonalIcon(
                                  key: const ValueKey<String>(
                                    'piano-demo-c-major-button',
                                  ),
                                  onPressed:
                                      widget.onPlayCMajorChordDemoPressed,
                                  icon: const Icon(Icons.library_music_rounded),
                                  label: Text(
                                    l10n.playMajorChordButton(
                                      l10n.majorChordName(cMajorRoot),
                                    ),
                                  ),
                                ),
                                if (widget.onDevelopmentDemoPressed != null)
                                  TextButton.icon(
                                    key: const ValueKey<String>(
                                      'single-note-demo-sequence-button',
                                    ),
                                    onPressed: widget.onDevelopmentDemoPressed,
                                    icon: const Icon(Icons.queue_music_rounded),
                                    label: Text(l10n.developmentDemoButton),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                          _OctaveControls(
                            currentOctave: _currentOctave,
                            canMoveToPreviousOctave: _canMoveToPreviousOctave,
                            canMoveToNextOctave: _canMoveToNextOctave,
                            onPreviousPressed: () => _moveOctave(-1),
                            onNextPressed: () => _moveOctave(1),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFECE4D6),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: PianoKeyboard(
                                startMidiNote:
                                    _visibleRange.startMidiNoteNumber,
                                endMidiNote: _visibleRange.endMidiNoteNumber,
                                highlightedMidiNotes:
                                    _visibleHighlightedMidiNotes,
                                pressedMidiNotes: widget.pressedMidiNotes,
                                showNoteLabels: _showNoteLabels,
                                noteNamingSystem: noteNamingSystem,
                                pianoHeight: 220,
                                onNotePressed: widget.onNotePressed,
                                onNoteReleased: widget.onNoteReleased,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _moveOctave(int delta) {
    setState(() {
      _currentOctave = widget.noteRange.clampVisibleStartOctave(
        _currentOctave + delta,
        visibleOctaveCount: _visibleOctaveCount,
      );
    });
  }
}

class _OctaveControls extends StatelessWidget {
  const _OctaveControls({
    required this.currentOctave,
    required this.canMoveToPreviousOctave,
    required this.canMoveToNextOctave,
    required this.onPreviousPressed,
    required this.onNextPressed,
  });

  final int currentOctave;
  final bool canMoveToPreviousOctave;
  final bool canMoveToNextOctave;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 430) {
          return Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Tooltip(
                  message: l10n.previousOctave,
                  child: OutlinedButton(
                    key: const ValueKey<String>('piano-prev-octave'),
                    onPressed: canMoveToPreviousOctave
                        ? onPreviousPressed
                        : null,
                    child: const Icon(Icons.chevron_left_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    l10n.octaveLabel(currentOctave),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 56,
                height: 56,
                child: Tooltip(
                  message: l10n.nextOctave,
                  child: OutlinedButton(
                    key: const ValueKey<String>('piano-next-octave'),
                    onPressed: canMoveToNextOctave ? onNextPressed : null,
                    child: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                key: const ValueKey<String>('piano-prev-octave'),
                onPressed: canMoveToPreviousOctave ? onPreviousPressed : null,
                icon: const Icon(Icons.chevron_left_rounded),
                label: Text(
                  l10n.previousOctave,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  l10n.octaveLabel(currentOctave),
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
                key: const ValueKey<String>('piano-next-octave'),
                onPressed: canMoveToNextOctave ? onNextPressed : null,
                icon: const Icon(Icons.chevron_right_rounded),
                label: Text(
                  l10n.nextOctave,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        );
      },
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
      key: const ValueKey<String>('piano-soundfont-message'),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isReady
            ? colorScheme.primaryContainer
            : colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LastPlayedNoteCard extends StatelessWidget {
  const _LastPlayedNoteCard({
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
      decimalDigits: 1,
    );
    return '${format.format(value)} Hz';
  }
}
