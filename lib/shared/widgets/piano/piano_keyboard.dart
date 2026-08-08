import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_virtual_piano/flutter_virtual_piano.dart';

import '../../../core/music/piano_keyboard_layout.dart';
import '../../../core/music/piano_note_range.dart';

typedef PianoNotePressedCallback = void Function(int midiNote);
typedef PianoNoteReleasedCallback = void Function(int midiNote);
typedef PianoNotePressSlideCallback =
    void Function(int midiNote, double verticalPosition);

class PianoKeyboard extends StatelessWidget {
  const PianoKeyboard({
    super.key,
    required this.startMidiNote,
    required this.endMidiNote,
    required this.highlightedMidiNotes,
    required this.pressedMidiNotes,
    required this.showNoteLabels,
    required this.pianoHeight,
    this.whiteKeyWidth = 56,
    this.onNotePressed,
    this.onNoteReleased,
    this.onNotePressSlide,
  }) : assert(startMidiNote <= endMidiNote);

  final int startMidiNote;
  final int endMidiNote;
  final Set<int> highlightedMidiNotes;
  final Set<int> pressedMidiNotes;
  final bool showNoteLabels;
  final double pianoHeight;
  final double whiteKeyWidth;
  final PianoNotePressedCallback? onNotePressed;
  final PianoNoteReleasedCallback? onNoteReleased;
  final PianoNotePressSlideCallback? onNotePressSlide;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PianoNoteRange visibleRange = PianoNoteRange(
      startMidiNoteNumber: startMidiNote,
      endMidiNoteNumber: endMidiNote,
    );
    final double width = math.max(
      PianoKeyboardLayout.whiteKeysForRange(range: visibleRange).length *
          whiteKeyWidth,
      320,
    );

    final List<HighlightedNoteSet> highlightedNoteSets = <HighlightedNoteSet>[
      if (pressedMidiNotes.isNotEmpty)
        HighlightedNoteSet(
          pressedMidiNotes,
          theme.colorScheme.primaryContainer,
        ),
      if (highlightedMidiNotes.isNotEmpty)
        HighlightedNoteSet(
          highlightedMidiNotes,
          theme.colorScheme.tertiaryContainer,
        ),
    ];

    return SizedBox(
      key: const ValueKey<String>('piano-keyboard-widget'),
      width: width,
      height: pianoHeight,
      child: VirtualPiano(
        noteRange: RangeValues(
          startMidiNote.toDouble(),
          endMidiNote.toDouble(),
        ),
        highlightedNoteSets: highlightedNoteSets,
        whiteKeyColor: const Color(0xFFFDFBF7),
        blackKeyColor: const Color(0xFF222327),
        elevation: 1.5,
        borderWidth: 0.8,
        keyHighlightColorBlend: 0.82,
        showKeyLabels: showNoteLabels,
        onNotePressed: onNotePressed == null
            ? null
            : (int note, double _) {
                onNotePressed!(note);
              },
        onNoteReleased: onNoteReleased,
        onNotePressSlide: onNotePressSlide,
      ),
    );
  }
}
