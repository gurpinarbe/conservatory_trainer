import 'package:flutter/material.dart';

import '../../../core/music/music_note.dart';
import '../../../core/music/piano_keyboard_layout.dart';
import '../../../core/music/piano_note_range.dart';

class PianoPanel extends StatefulWidget {
  const PianoPanel({
    super.key,
    required this.highlightedMidiNotes,
    required this.showHighlightedMidiNotes,
    required this.autoFollowHighlightedNotes,
    required this.onShowHighlightedMidiNotesChanged,
    required this.onAutoFollowHighlightedNotesChanged,
    required this.onNotePressed,
    this.onDevelopmentDemoPressed,
    this.lastPlayedNote,
    this.noteRange = PianoKeyboardLayout.supportedRange,
    this.initialOctave = 4,
  });

  final Set<int> highlightedMidiNotes;
  final bool showHighlightedMidiNotes;
  final bool autoFollowHighlightedNotes;
  final ValueChanged<bool> onShowHighlightedMidiNotesChanged;
  final ValueChanged<bool> onAutoFollowHighlightedNotesChanged;
  final ValueChanged<MusicNote> onNotePressed;
  final VoidCallback? onDevelopmentDemoPressed;
  final MusicNote? lastPlayedNote;
  final PianoNoteRange noteRange;
  final int initialOctave;

  @override
  State<PianoPanel> createState() => _PianoPanelState();
}

class _PianoPanelState extends State<PianoPanel> {
  static const Duration _panelAnimationDuration = Duration(milliseconds: 240);
  static const double _whiteKeyHeight = 196;
  static const double _blackKeyHeight = 120;
  static const double _blackKeyWidth = 42;

  final ScrollController _scrollController = ScrollController();
  final Map<int, Set<int>> _activePointerIdsByMidiNoteNumber =
      <int, Set<int>>{};

  late int _currentOctave;
  bool _isExpanded = false;
  double _whiteKeyWidth = 60;
  double _viewportWidth = 0;

  Set<int> get _pressedMidiNoteNumbers =>
      _activePointerIdsByMidiNoteNumber.keys.toSet();

  Set<int> get _visibleHighlightedMidiNotes {
    return widget.showHighlightedMidiNotes
        ? widget.highlightedMidiNotes
        : const <int>{};
  }

  @override
  void initState() {
    super.initState();
    _currentOctave = widget.noteRange.clampOctave(widget.initialOctave);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentOctave(animated: false);
    });
  }

  @override
  void didUpdateWidget(covariant PianoPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_shouldAutoFollowHighlightedNotes(oldWidget)) {
      _currentOctave = PianoKeyboardLayout.octaveForHighlightedNotes(
        widget.highlightedMidiNotes,
        range: widget.noteRange,
        fallbackOctave: _currentOctave,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentOctave(animated: true);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final String playedNoteLabel =
        widget.lastPlayedNote?.turkishScientificName ??
        'Henüz bir nota çalmadın';

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
                label: Text(_isExpanded ? 'Piyanoyu Kapat' : 'Piyanoyu Aç'),
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
                          Text(
                            'Çaldığın Nota: $playedNoteLabel',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tuşlara dokunarak notaları tek tek deneyebilirsin.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            value: widget.showHighlightedMidiNotes,
                            onChanged: widget.onShowHighlightedMidiNotesChanged,
                            title: const Text('Çalan notaları piyanoda göster'),
                          ),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            value: widget.autoFollowHighlightedNotes,
                            onChanged:
                                widget.onAutoFollowHighlightedNotesChanged,
                            title: const Text('Oktavı otomatik takip et'),
                          ),
                          if (widget.onDevelopmentDemoPressed != null)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                key: const ValueKey<String>(
                                  'single-note-demo-sequence-button',
                                ),
                                onPressed: widget.onDevelopmentDemoPressed,
                                icon: const Icon(Icons.queue_music_rounded),
                                label: const Text('Do-Mi-Sol demosunu göster'),
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  key: const ValueKey<String>(
                                    'piano-prev-octave',
                                  ),
                                  onPressed: _canMoveToPreviousOctave
                                      ? () => _moveOctave(-1)
                                      : null,
                                  icon: const Icon(Icons.chevron_left_rounded),
                                  label: const Text('Önceki Oktav'),
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
                                    '$_currentOctave. Oktav',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  key: const ValueKey<String>(
                                    'piano-next-octave',
                                  ),
                                  onPressed: _canMoveToNextOctave
                                      ? () => _moveOctave(1)
                                      : null,
                                  icon: const Icon(Icons.chevron_right_rounded),
                                  label: const Text('Sonraki Oktav'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          LayoutBuilder(
                            builder:
                                (
                                  BuildContext context,
                                  BoxConstraints constraints,
                                ) {
                                  _viewportWidth = constraints.maxWidth;
                                  _whiteKeyWidth = constraints.maxWidth < 420
                                      ? 56
                                      : 64;

                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                      color: const Color(0xFFE7E0D2),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: _buildKeyboard(context),
                                    ),
                                  );
                                },
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

  bool get _canMoveToPreviousOctave {
    return _currentOctave > widget.noteRange.minOctave;
  }

  bool get _canMoveToNextOctave {
    return _currentOctave < widget.noteRange.maxOctave;
  }

  bool _shouldAutoFollowHighlightedNotes(PianoPanel oldWidget) {
    final bool highlightsChanged = !_sameMidiSet(
      oldWidget.highlightedMidiNotes,
      widget.highlightedMidiNotes,
    );

    return highlightsChanged &&
        widget.showHighlightedMidiNotes &&
        widget.autoFollowHighlightedNotes &&
        widget.highlightedMidiNotes.isNotEmpty &&
        _pressedMidiNoteNumbers.isEmpty;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentOctave(animated: true);
      });
    }
  }

  void _moveOctave(int delta) {
    final int nextOctave = widget.noteRange.clampOctave(_currentOctave + delta);
    if (nextOctave == _currentOctave) {
      return;
    }

    setState(() {
      _currentOctave = nextOctave;
    });

    _scrollToCurrentOctave(animated: true);
  }

  Widget _buildKeyboard(BuildContext context) {
    final List<MusicNote> notes = PianoKeyboardLayout.notesForRange(
      range: widget.noteRange,
    );
    final List<MusicNote> whiteKeys = notes
        .where((MusicNote note) => !note.isBlackKey)
        .toList();
    final double keyboardWidth = whiteKeys.length * _whiteKeyWidth;

    int whiteKeyIndex = 0;
    final List<_BlackKeyLayout> blackKeyLayouts = <_BlackKeyLayout>[];

    for (final MusicNote note in notes) {
      if (note.isBlackKey) {
        blackKeyLayouts.add(
          _BlackKeyLayout(
            note: note,
            leftOffset: (whiteKeyIndex * _whiteKeyWidth) - (_blackKeyWidth / 2),
          ),
        );
      } else {
        whiteKeyIndex++;
      }
    }

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: keyboardWidth,
        height: _whiteKeyHeight,
        child: Stack(
          children: [
            Row(
              children: whiteKeys.map((MusicNote note) {
                return _PianoKey(
                  note: note,
                  width: _whiteKeyWidth,
                  height: _whiteKeyHeight,
                  isPressed: _pressedMidiNoteNumbers.contains(
                    note.midiNoteNumber,
                  ),
                  isExerciseHighlighted: _visibleHighlightedMidiNotes.contains(
                    note.midiNoteNumber,
                  ),
                  onPointerDown: _handlePointerDown,
                  onPointerUp: _handlePointerEnd,
                  showStaticLabel: true,
                );
              }).toList(),
            ),
            ...blackKeyLayouts.map((layout) {
              return Positioned(
                left: layout.leftOffset,
                top: 0,
                child: _PianoKey(
                  note: layout.note,
                  width: _blackKeyWidth,
                  height: _blackKeyHeight,
                  isPressed: _pressedMidiNoteNumbers.contains(
                    layout.note.midiNoteNumber,
                  ),
                  isExerciseHighlighted: _visibleHighlightedMidiNotes.contains(
                    layout.note.midiNoteNumber,
                  ),
                  onPointerDown: _handlePointerDown,
                  onPointerUp: _handlePointerEnd,
                  showStaticLabel: false,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _handlePointerDown(MusicNote note, int pointerId) {
    final Set<int> pointerIds = _activePointerIdsByMidiNoteNumber.putIfAbsent(
      note.midiNoteNumber,
      () => <int>{},
    );
    pointerIds.add(pointerId);

    setState(() {});
    widget.onNotePressed(note);
  }

  void _handlePointerEnd(MusicNote note, int pointerId) {
    final Set<int>? pointerIds =
        _activePointerIdsByMidiNoteNumber[note.midiNoteNumber];
    if (pointerIds == null) {
      return;
    }

    pointerIds.remove(pointerId);
    if (pointerIds.isEmpty) {
      _activePointerIdsByMidiNoteNumber.remove(note.midiNoteNumber);
    }

    setState(() {});
  }

  void _scrollToCurrentOctave({required bool animated}) {
    if (!_scrollController.hasClients) {
      return;
    }

    final double octaveWidth = 7 * _whiteKeyWidth;
    final double centeredOffset =
        ((_currentOctave - widget.noteRange.minOctave) * octaveWidth) -
        ((_viewportWidth - octaveWidth) / 2);

    final double clampedOffset = centeredOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    if (animated) {
      _scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(clampedOffset);
    }
  }

  bool _sameMidiSet(Set<int> first, Set<int> second) {
    if (first.length != second.length) {
      return false;
    }

    for (final int value in first) {
      if (!second.contains(value)) {
        return false;
      }
    }

    return true;
  }
}

class _PianoKey extends StatelessWidget {
  const _PianoKey({
    required this.note,
    required this.width,
    required this.height,
    required this.isPressed,
    required this.isExerciseHighlighted,
    required this.onPointerDown,
    required this.onPointerUp,
    required this.showStaticLabel,
  });

  final MusicNote note;
  final double width;
  final double height;
  final bool isPressed;
  final bool isExerciseHighlighted;
  final void Function(MusicNote note, int pointerId) onPointerDown;
  final void Function(MusicNote note, int pointerId) onPointerUp;
  final bool showStaticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isActive = isPressed || isExerciseHighlighted;
    final Color backgroundColor = _backgroundColor(colorScheme);
    final Color foregroundColor = note.isBlackKey
        ? Colors.white
        : colorScheme.onSurface;

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (PointerDownEvent event) {
        onPointerDown(note, event.pointer);
      },
      onPointerUp: (PointerUpEvent event) {
        onPointerUp(note, event.pointer);
      },
      onPointerCancel: (PointerCancelEvent event) {
        onPointerUp(note, event.pointer);
      },
      child: Semantics(
        label: note.accessibilityLabel,
        button: true,
        selected: isActive,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              AnimatedContainer(
                key: ValueKey<String>('piano-key-${note.midiNoteNumber}'),
                duration: const Duration(milliseconds: 110),
                width: width,
                height: height,
                margin: EdgeInsets.only(
                  left: note.isBlackKey ? 0 : 1,
                  right: note.isBlackKey ? 0 : 1,
                ),
                padding: EdgeInsets.only(
                  left: 6,
                  right: 6,
                  top: 8,
                  bottom: note.isBlackKey ? 10 : 12,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(
                    note.isBlackKey ? 12 : 16,
                  ),
                  border: Border.all(
                    color: isPressed
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                  ),
                  boxShadow: note.isBlackKey
                      ? const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ]
                      : const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isExerciseHighlighted)
                      Container(
                        key: ValueKey<String>(
                          'piano-highlight-${note.midiNoteNumber}',
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: note.isBlackKey
                              ? colorScheme.secondary
                              : colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          note.turkishScientificName,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: note.isBlackKey
                                ? colorScheme.onSecondary
                                : colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                    else if (isPressed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: note.isBlackKey
                              ? colorScheme.primary
                              : colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          note.turkishScientificName,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: note.isBlackKey
                                ? colorScheme.onPrimary
                                : colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 22),
                    const Spacer(),
                    if (showStaticLabel)
                      Text(
                        note.turkishNoteName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: foregroundColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(ColorScheme colorScheme) {
    if (note.isBlackKey) {
      if (isPressed && isExerciseHighlighted) {
        return colorScheme.tertiary;
      }
      if (isPressed) {
        return colorScheme.primary;
      }
      if (isExerciseHighlighted) {
        return colorScheme.secondary;
      }
      return const Color(0xFF28343A);
    }

    if (isPressed && isExerciseHighlighted) {
      return colorScheme.tertiaryContainer;
    }
    if (isPressed) {
      return colorScheme.primaryContainer;
    }
    if (isExerciseHighlighted) {
      return colorScheme.secondaryContainer;
    }
    return colorScheme.surface;
  }
}

class _BlackKeyLayout {
  const _BlackKeyLayout({required this.note, required this.leftOffset});

  final MusicNote note;
  final double leftOffset;
}
