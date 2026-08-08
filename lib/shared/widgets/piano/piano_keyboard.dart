import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_virtual_piano/flutter_virtual_piano.dart';

import '../../../core/music/music_note.dart';
import '../../../core/music/note_label_formatter.dart';
import '../../../core/music/note_naming_system.dart';
import '../../../core/music/piano_keyboard_layout.dart';
import '../../../core/music/piano_note_range.dart';
import '../../../l10n/l10n.dart';
import 'flutter_virtual_piano_midi_adapter.dart';

typedef PianoNotePressedCallback = void Function(int midiNote);
typedef PianoNoteReleasedCallback = void Function(int midiNote);
typedef PianoNoteTouchCallback = void Function(PianoNoteTouchDetails details);

class PianoNoteTouchDetails {
  const PianoNoteTouchDetails({
    required this.midiNote,
    required this.verticalPosition,
  });

  final int midiNote;
  final double verticalPosition;
}

class PianoKeyboard extends StatelessWidget {
  const PianoKeyboard({
    super.key,
    required this.startMidiNote,
    required this.endMidiNote,
    required this.highlightedMidiNotes,
    required this.pressedMidiNotes,
    required this.showNoteLabels,
    required this.noteNamingSystem,
    required this.pianoHeight,
    this.whiteKeyWidth = 56,
    this.onNotePressed,
    this.onNoteReleased,
    this.onNoteTouchDown,
    this.onNoteTouchSlide,
  }) : assert(startMidiNote <= endMidiNote);

  static const NoteLabelFormatter _noteLabelFormatter = NoteLabelFormatter();
  static const FlutterVirtualPianoMidiAdapter _midiAdapter =
      FlutterVirtualPianoMidiAdapter();

  final int startMidiNote;
  final int endMidiNote;
  final Set<int> highlightedMidiNotes;
  final Set<int> pressedMidiNotes;
  final bool showNoteLabels;
  final NoteNamingSystem noteNamingSystem;
  final double pianoHeight;
  final double whiteKeyWidth;
  final PianoNotePressedCallback? onNotePressed;
  final PianoNoteReleasedCallback? onNoteReleased;
  final PianoNoteTouchCallback? onNoteTouchDown;
  final PianoNoteTouchCallback? onNoteTouchSlide;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final PianoNoteRange visibleRange = PianoNoteRange(
      startMidiNoteNumber: startMidiNote,
      endMidiNoteNumber: endMidiNote,
    );
    final List<MusicNote> whiteKeys = PianoKeyboardLayout.whiteKeysForRange(
      range: visibleRange,
    );
    final double width = math.max(whiteKeys.length * whiteKeyWidth, 320);
    final List<_PianoKeyFrame> keyFrames = _buildKeyFrames(
      range: visibleRange,
      width: width,
      height: pianoHeight,
    );

    final List<HighlightedNoteSet> highlightedNoteSets = <HighlightedNoteSet>[
      if (pressedMidiNotes.isNotEmpty)
        HighlightedNoteSet(pressedMidiNotes, colorScheme.primaryContainer),
      if (highlightedMidiNotes.isNotEmpty)
        HighlightedNoteSet(highlightedMidiNotes, colorScheme.tertiaryContainer),
    ];

    return SizedBox(
      key: const ValueKey<String>('piano-keyboard-widget'),
      width: width,
      height: pianoHeight,
      child: Stack(
        children: [
          ExcludeSemantics(
            child: VirtualPiano(
              noteRange: _midiAdapter.toPackageNoteRange(
                startMidiNote: startMidiNote,
                endMidiNote: endMidiNote,
              ),
              highlightedNoteSets: highlightedNoteSets,
              whiteKeyColor: colorScheme.surface,
              blackKeyColor: colorScheme.inverseSurface,
              elevation: 1.5,
              borderWidth: 0.8,
              keyHighlightColorBlend: 0.82,
              showKeyLabels: false,
            ),
          ),
          Stack(
            children: keyFrames
                .map((_PianoKeyFrame frame) {
                  final bool isPressed = pressedMidiNotes.contains(
                    frame.note.midiNoteNumber,
                  );
                  final bool isHighlighted = highlightedMidiNotes.contains(
                    frame.note.midiNoteNumber,
                  );
                  final String semanticLabel = context.l10n.pianoKeySemantics(
                    _noteLabelFormatter.formatAccessibleScientificName(
                      frame.note,
                      l10n: context.l10n,
                      namingSystem: noteNamingSystem,
                    ),
                  );
                  final String visibleLabel = _noteLabelFormatter
                      .formatScientificName(
                        frame.note,
                        namingSystem: noteNamingSystem,
                      );

                  return Positioned.fromRect(
                    rect: frame.rect,
                    child: _PianoKeyOverlay(
                      key: ValueKey<String>(
                        'piano-key-hitbox-${frame.note.midiNoteNumber}',
                      ),
                      note: frame.note,
                      showNoteLabel: showNoteLabels,
                      isPressed: isPressed,
                      isHighlighted: isHighlighted,
                      visibleLabel: visibleLabel,
                      semanticLabel: semanticLabel,
                      colorScheme: colorScheme,
                      borderRadius: frame.borderRadius,
                      onNotePressed: onNotePressed,
                      onNoteReleased: onNoteReleased,
                      onNoteTouchDown: onNoteTouchDown,
                      onNoteTouchSlide: onNoteTouchSlide,
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  List<_PianoKeyFrame> _buildKeyFrames({
    required PianoNoteRange range,
    required double width,
    required double height,
  }) {
    final List<MusicNote> notes = PianoKeyboardLayout.notesForRange(
      range: range,
    );
    final List<MusicNote> whiteKeys = notes
        .where((MusicNote note) => !note.isBlackKey)
        .toList(growable: false);
    final List<MusicNote> blackKeys = notes
        .where((MusicNote note) => note.isBlackKey)
        .toList(growable: false);
    final Map<int, int> whiteKeyIndices = <int, int>{
      for (int index = 0; index < whiteKeys.length; index++)
        whiteKeys[index].midiNoteNumber: index,
    };
    final double keyWidth = width / whiteKeys.length;
    final List<_PianoKeyFrame> whiteKeyFrames = <_PianoKeyFrame>[];
    final List<_PianoKeyFrame> blackKeyFrames = <_PianoKeyFrame>[];

    for (final MusicNote note in whiteKeys) {
      final int whiteIndex = whiteKeyIndices[note.midiNoteNumber]!;
      whiteKeyFrames.add(
        _PianoKeyFrame(
          note: note,
          rect: Rect.fromLTWH(whiteIndex * keyWidth, 0, keyWidth, height),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(keyWidth / 6),
            bottomRight: Radius.circular(keyWidth / 6),
          ),
        ),
      );
    }

    for (final MusicNote note in blackKeys) {
      final int? precedingWhiteIndex = whiteKeyIndices[note.midiNoteNumber - 1];
      if (precedingWhiteIndex == null) {
        continue;
      }

      final double blackWidth = keyWidth * (2 / 3);
      blackKeyFrames.add(
        _PianoKeyFrame(
          note: note,
          rect: Rect.fromLTWH(
            (precedingWhiteIndex * keyWidth) + (keyWidth * (2 / 3)),
            0,
            blackWidth,
            height * 0.6,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(blackWidth / 6),
            bottomRight: Radius.circular(blackWidth / 6),
          ),
        ),
      );
    }

    return <_PianoKeyFrame>[...whiteKeyFrames, ...blackKeyFrames];
  }
}

class _PianoKeyFrame {
  const _PianoKeyFrame({
    required this.note,
    required this.rect,
    required this.borderRadius,
  });

  final MusicNote note;
  final Rect rect;
  final BorderRadius borderRadius;
}

class _PianoKeyOverlay extends StatelessWidget {
  const _PianoKeyOverlay({
    super.key,
    required this.note,
    required this.showNoteLabel,
    required this.isPressed,
    required this.isHighlighted,
    required this.visibleLabel,
    required this.semanticLabel,
    required this.colorScheme,
    required this.borderRadius,
    this.onNotePressed,
    this.onNoteReleased,
    this.onNoteTouchDown,
    this.onNoteTouchSlide,
  });

  final MusicNote note;
  final bool showNoteLabel;
  final bool isPressed;
  final bool isHighlighted;
  final String visibleLabel;
  final String semanticLabel;
  final ColorScheme colorScheme;
  final BorderRadius borderRadius;
  final PianoNotePressedCallback? onNotePressed;
  final PianoNoteReleasedCallback? onNoteReleased;
  final PianoNoteTouchCallback? onNoteTouchDown;
  final PianoNoteTouchCallback? onNoteTouchSlide;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isBlackKey = note.isBlackKey;
    final Color pressedBorderColor = isBlackKey
        ? colorScheme.primary
        : colorScheme.primary;
    final Color highlightMarkerColor = colorScheme.tertiary;
    final Color labelColor = isBlackKey
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    double resolveVerticalPosition(Offset localPosition) {
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      final double height = renderBox?.size.height ?? 1;
      return (localPosition.dy / height).clamp(0.0, 1.0).toDouble();
    }

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: semanticLabel,
      button: true,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (PointerDownEvent event) {
          final double verticalPosition = resolveVerticalPosition(
            event.localPosition,
          );
          onNotePressed?.call(note.midiNoteNumber);
          onNoteTouchDown?.call(
            PianoNoteTouchDetails(
              midiNote: note.midiNoteNumber,
              verticalPosition: verticalPosition,
            ),
          );
        },
        onPointerMove: (PointerMoveEvent event) {
          final double verticalPosition = resolveVerticalPosition(
            event.localPosition,
          );
          onNoteTouchSlide?.call(
            PianoNoteTouchDetails(
              midiNote: note.midiNoteNumber,
              verticalPosition: verticalPosition,
            ),
          );
        },
        onPointerUp: (_) {
          onNoteReleased?.call(note.midiNoteNumber);
        },
        onPointerCancel: (_) {
          onNoteReleased?.call(note.midiNoteNumber);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: isPressed
                ? Border.all(color: pressedBorderColor, width: 2.4)
                : null,
          ),
          child: Stack(
            children: [
              if (isHighlighted)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    key: ValueKey<String>(
                      'piano-key-highlight-${note.midiNoteNumber}',
                    ),
                    width: isBlackKey ? 12 : 14,
                    height: isBlackKey ? 12 : 14,
                    margin: EdgeInsets.only(top: isBlackKey ? 6 : 8),
                    decoration: BoxDecoration(
                      color: highlightMarkerColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isBlackKey
                            ? colorScheme.surface
                            : colorScheme.onSurface,
                        width: 1.4,
                      ),
                    ),
                  ),
                ),
              if (isPressed)
                Positioned.fill(
                  child: Container(
                    key: ValueKey<String>(
                      'piano-key-pressed-${note.midiNoteNumber}',
                    ),
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      border: Border.all(color: pressedBorderColor, width: 2.4),
                    ),
                  ),
                ),
              if (showNoteLabel)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(2, 2, 2, isBlackKey ? 6 : 8),
                    child: Text(
                      visibleLabel,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          (isBlackKey
                                  ? textTheme.labelSmall
                                  : textTheme.labelMedium)
                              ?.copyWith(
                                color: labelColor,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                              ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
