import 'package:flutter/material.dart';

import '../../../core/music/music_accidental.dart';
import '../../../core/music/music_clef.dart';
import '../../../core/music/notation_event.dart';
import '../../../core/music/note_value.dart';
import '../../../core/music/staff_position.dart';
import 'notation_renderer.dart';
import 'staff_layout.dart';

class CustomPainterNotationRenderer implements NotationRenderer {
  const CustomPainterNotationRenderer({required this.clef});

  final MusicClef clef;

  @override
  Widget build({
    required BuildContext context,
    required StaffLayoutData layout,
    required bool showActiveHighlights,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return SizedBox(
      width: layout.width,
      height: layout.height,
      child: CustomPaint(
        painter: _StaffBackgroundPainter(
          layout: layout,
          colorScheme: colorScheme,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (layout.measures.isNotEmpty) ...[
              Positioned(
                left:
                    layout.measures.first.bounds.left - layout.leadingWidth + 8,
                top: layout.staffTop - 34,
                child: Text(
                  _clefSymbol(clef),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              Positioned(
                left:
                    layout.measures.first.bounds.left -
                    layout.leadingWidth +
                    46,
                top: layout.staffTop - 8,
                child: _TimeSignatureBadge(
                  label: layout.measures.first.timeSignatureLabel,
                ),
              ),
            ],
            ...layout.events.map((StaffEventLayout eventLayout) {
              final NotationEventVisualState visualState =
                  _effectiveVisualState(
                    eventLayout.event.visualState,
                    showActiveHighlights: showActiveHighlights,
                  );

              return Positioned(
                left: eventLayout.bounds.left,
                top: eventLayout.bounds.top,
                child: _StaffEventGlyph(
                  key: ValueKey<String>('staff-event-${eventLayout.event.id}'),
                  eventLayout: eventLayout,
                  visualState: visualState,
                  showActiveHighlights: showActiveHighlights,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  static NotationEventVisualState _effectiveVisualState(
    NotationEventVisualState visualState, {
    required bool showActiveHighlights,
  }) {
    if (!showActiveHighlights &&
        visualState == NotationEventVisualState.active) {
      return NotationEventVisualState.normal;
    }

    return visualState;
  }

  static String _clefSymbol(MusicClef clef) {
    return switch (clef) {
      MusicClef.treble => '𝄞',
      MusicClef.bass => '𝄢',
      MusicClef.alto => '𝄡',
      MusicClef.tenor => '𝄡',
    };
  }
}

class _StaffBackgroundPainter extends CustomPainter {
  const _StaffBackgroundPainter({
    required this.layout,
    required this.colorScheme,
  });

  final StaffLayoutData layout;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 1.4;
    final Paint activeMeasurePaint = Paint()
      ..color = colorScheme.primaryContainer.withValues(alpha: 0.38);
    final Paint barPaint = Paint()
      ..color = colorScheme.outline
      ..strokeWidth = 1.8;

    for (final StaffMeasureLayout measure in layout.measures) {
      final double measureStartX = measure.index == 0
          ? measure.bounds.left - layout.leadingWidth + 16
          : measure.bounds.left;

      if (measure.isActive) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            measure.bounds.inflate(8),
            const Radius.circular(20),
          ),
          activeMeasurePaint,
        );
      }

      for (int lineIndex = 0; lineIndex < 5; lineIndex++) {
        final double y = layout.staffTop + (lineIndex * layout.lineSpacing);
        canvas.drawLine(
          Offset(measureStartX, y),
          Offset(measure.bounds.right, y),
          linePaint,
        );
      }

      canvas.drawLine(
        Offset(measure.bounds.left, layout.staffTop),
        Offset(measure.bounds.left, layout.bottomLineY),
        barPaint,
      );
      canvas.drawLine(
        Offset(measure.bounds.right, layout.staffTop),
        Offset(measure.bounds.right, layout.bottomLineY),
        barPaint,
      );
    }

    for (final StaffEventLayout eventLayout in layout.events) {
      final StaffPosition? position = eventLayout.position;
      if (position == null) {
        continue;
      }

      for (int step = -2; step >= position.stepsFromBottomLine; step -= 2) {
        final double y = layout.bottomLineY - (step * (layout.lineSpacing / 2));
        canvas.drawLine(
          Offset(eventLayout.noteCenter.dx - 18, y),
          Offset(eventLayout.noteCenter.dx + 18, y),
          barPaint,
        );
      }

      for (int step = 10; step <= position.stepsFromBottomLine; step += 2) {
        final double y = layout.bottomLineY - (step * (layout.lineSpacing / 2));
        canvas.drawLine(
          Offset(eventLayout.noteCenter.dx - 18, y),
          Offset(eventLayout.noteCenter.dx + 18, y),
          barPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StaffBackgroundPainter oldDelegate) {
    return oldDelegate.layout != layout ||
        oldDelegate.colorScheme != colorScheme;
  }
}

class _TimeSignatureBadge extends StatelessWidget {
  const _TimeSignatureBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> parts = label.split('/');

    return Column(
      children: [
        Text(
          parts.first,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        Text(
          parts.last,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _StaffEventGlyph extends StatelessWidget {
  const _StaffEventGlyph({
    super.key,
    required this.eventLayout,
    required this.visualState,
    required this.showActiveHighlights,
  });

  final StaffEventLayout eventLayout;
  final NotationEventVisualState visualState;
  final bool showActiveHighlights;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final IconData? badgeIcon = _badgeIcon(visualState);
    final bool isActive = visualState == NotationEventVisualState.active;

    if (eventLayout.event is RestEvent) {
      return SizedBox(
        width: eventLayout.bounds.width,
        height: eventLayout.bounds.height,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Text(
              'Sus',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }

    final NoteEvent noteEvent = eventLayout.event as NoteEvent;

    return Semantics(
      label: '${noteEvent.note.turkishScientificName} notası',
      selected: isActive,
      child: SizedBox(
        width: eventLayout.bounds.width,
        height: eventLayout.bounds.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isActive && showActiveHighlights)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Container(
                      key: ValueKey<String>(
                        'staff-highlight-${eventLayout.event.id}',
                      ),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.34,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            CustomPaint(
              size: Size(eventLayout.bounds.width, eventLayout.bounds.height),
              painter: _NoteGlyphPainter(
                noteValue: noteEvent.noteValue,
                accidental: noteEvent.accidental ?? MusicAccidental.natural,
                visualState: visualState,
                colorScheme: colorScheme,
                stemUp: (eventLayout.position?.stepsFromBottomLine ?? 0) < 4,
              ),
            ),
            if (badgeIcon != null)
              Positioned(
                right: 6,
                top: 12,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Icon(
                    badgeIcon,
                    size: 14,
                    color: _badgeColor(visualState, colorScheme),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static IconData? _badgeIcon(NotationEventVisualState visualState) {
    return switch (visualState) {
      NotationEventVisualState.normal => null,
      NotationEventVisualState.active => Icons.play_arrow_rounded,
      NotationEventVisualState.selected => Icons.radio_button_checked_rounded,
      NotationEventVisualState.correct => Icons.check_rounded,
      NotationEventVisualState.wrong => Icons.close_rounded,
      NotationEventVisualState.corrected => Icons.refresh_rounded,
    };
  }

  static Color _badgeColor(
    NotationEventVisualState visualState,
    ColorScheme colorScheme,
  ) {
    return switch (visualState) {
      NotationEventVisualState.normal => colorScheme.onSurface,
      NotationEventVisualState.active => colorScheme.primary,
      NotationEventVisualState.selected => colorScheme.tertiary,
      NotationEventVisualState.correct => Colors.green.shade700,
      NotationEventVisualState.wrong => colorScheme.error,
      NotationEventVisualState.corrected => Colors.orange.shade700,
    };
  }
}

class _NoteGlyphPainter extends CustomPainter {
  const _NoteGlyphPainter({
    required this.noteValue,
    required this.accidental,
    required this.visualState,
    required this.colorScheme,
    required this.stemUp,
  });

  final NoteValue noteValue;
  final MusicAccidental accidental;
  final NotationEventVisualState visualState;
  final ColorScheme colorScheme;
  final bool stemUp;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset noteCenter = Offset(size.width * 0.56, size.height * 0.52);
    final Color accentColor = _accentColor(colorScheme, visualState);
    final bool isWhole = noteValue == NoteValue.whole;
    final bool isOpenHead =
        isWhole ||
        noteValue == NoteValue.half ||
        noteValue == NoteValue.dottedHalf;
    final Rect noteRect = Rect.fromCenter(
      center: noteCenter,
      width: 18,
      height: 12,
    );

    final Paint fillPaint = Paint()
      ..color = isOpenHead ? colorScheme.surface : accentColor
      ..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (accidental != MusicAccidental.natural) {
      final TextPainter accidentalPainter = TextPainter(
        text: TextSpan(
          text: accidental == MusicAccidental.sharp ? '#' : 'b',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      accidentalPainter.paint(
        canvas,
        Offset(noteCenter.dx - 30, noteCenter.dy - 14),
      );
    }

    canvas.save();
    canvas.translate(noteCenter.dx, noteCenter.dy);
    canvas.rotate(-0.36);
    canvas.translate(-noteCenter.dx, -noteCenter.dy);
    canvas.drawOval(noteRect, fillPaint);
    canvas.drawOval(noteRect, strokePaint);
    canvas.restore();

    if (!isWhole) {
      final double stemLength = 28;
      final Offset stemStart = stemUp
          ? Offset(noteCenter.dx + 8, noteCenter.dy)
          : Offset(noteCenter.dx - 8, noteCenter.dy);
      final Offset stemEnd = stemUp
          ? Offset(stemStart.dx, stemStart.dy - stemLength)
          : Offset(stemStart.dx, stemStart.dy + stemLength);

      canvas.drawLine(stemStart, stemEnd, strokePaint);

      final int flagCount = _flagCount(noteValue);
      for (int flagIndex = 0; flagIndex < flagCount; flagIndex++) {
        final Path flagPath = Path();
        final double verticalOffset = flagIndex * 8;

        if (stemUp) {
          flagPath.moveTo(stemEnd.dx, stemEnd.dy + verticalOffset);
          flagPath.quadraticBezierTo(
            stemEnd.dx + 14,
            stemEnd.dy + 4 + verticalOffset,
            stemEnd.dx + 8,
            stemEnd.dy + 12 + verticalOffset,
          );
        } else {
          flagPath.moveTo(stemEnd.dx, stemEnd.dy - verticalOffset);
          flagPath.quadraticBezierTo(
            stemEnd.dx - 14,
            stemEnd.dy - 4 - verticalOffset,
            stemEnd.dx - 8,
            stemEnd.dy - 12 - verticalOffset,
          );
        }

        canvas.drawPath(
          flagPath,
          Paint()
            ..color = accentColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.2,
        );
      }
    }

    if (noteValue.isDotted) {
      canvas.drawCircle(
        Offset(noteCenter.dx + 16, noteCenter.dy - 2),
        2.4,
        Paint()..color = accentColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NoteGlyphPainter oldDelegate) {
    return oldDelegate.noteValue != noteValue ||
        oldDelegate.accidental != accidental ||
        oldDelegate.visualState != visualState ||
        oldDelegate.colorScheme != colorScheme ||
        oldDelegate.stemUp != stemUp;
  }

  static Color _accentColor(
    ColorScheme colorScheme,
    NotationEventVisualState visualState,
  ) {
    return switch (visualState) {
      NotationEventVisualState.normal => colorScheme.onSurface,
      NotationEventVisualState.active => colorScheme.primary,
      NotationEventVisualState.selected => colorScheme.tertiary,
      NotationEventVisualState.correct => Colors.green.shade700,
      NotationEventVisualState.wrong => colorScheme.error,
      NotationEventVisualState.corrected => Colors.orange.shade700,
    };
  }

  static int _flagCount(NoteValue noteValue) {
    return switch (noteValue) {
      NoteValue.eighth || NoteValue.dottedEighth => 1,
      NoteValue.sixteenth => 2,
      _ => 0,
    };
  }
}
