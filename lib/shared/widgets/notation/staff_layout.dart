import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../core/music/music_clef.dart';
import '../../../core/music/notation_event.dart';
import '../../../core/music/notation_sequence.dart';
import '../../../core/music/staff_position.dart';
import '../../../core/music/staff_position_calculator.dart';

class StaffLayoutData {
  const StaffLayoutData({
    required this.width,
    required this.height,
    required this.staffTop,
    required this.bottomLineY,
    required this.lineSpacing,
    required this.leadingWidth,
    required this.measures,
    required this.events,
  });

  final double width;
  final double height;
  final double staffTop;
  final double bottomLineY;
  final double lineSpacing;
  final double leadingWidth;
  final List<StaffMeasureLayout> measures;
  final List<StaffEventLayout> events;

  Rect? rectForEvent(String eventId) {
    for (final StaffEventLayout eventLayout in events) {
      if (eventLayout.event.id == eventId) {
        return eventLayout.bounds;
      }
    }

    return null;
  }
}

class StaffMeasureLayout {
  const StaffMeasureLayout({
    required this.index,
    required this.bounds,
    required this.timeSignatureLabel,
    required this.isActive,
  });

  final int index;
  final Rect bounds;
  final String timeSignatureLabel;
  final bool isActive;
}

class StaffEventLayout {
  const StaffEventLayout({
    required this.event,
    required this.noteCenter,
    required this.position,
  });

  final NotationEvent event;
  final Offset noteCenter;
  final StaffPosition? position;

  Rect get bounds => Rect.fromCenter(center: noteCenter, width: 72, height: 96);
}

abstract final class StaffLayoutCalculator {
  static const double horizontalPadding = 24;
  static const double leadingWidth = 78;
  static const double lineSpacing = 16;
  static const double measureSpacing = 20;
  static const double minMeasureWidth = 196;
  static const double unitWidth = 16;

  static StaffLayoutData build({
    required NotationSequence sequence,
    required MusicClef clef,
  }) {
    final List<_PositionedNote> positionedNotes = <_PositionedNote>[];

    for (final NotationEvent event in sequence.allEvents) {
      if (event is! NoteEvent) {
        continue;
      }

      positionedNotes.add(
        _PositionedNote(
          eventId: event.id,
          position: StaffPositionCalculator.positionForNote(
            note: event.note,
            clef: clef,
          ),
        ),
      );
    }

    final int minStep = positionedNotes.isEmpty
        ? 0
        : positionedNotes
              .map((_PositionedNote positionedNote) {
                return positionedNote.position.stepsFromBottomLine;
              })
              .reduce(math.min);
    final int maxStep = positionedNotes.isEmpty
        ? 8
        : positionedNotes
              .map((_PositionedNote positionedNote) {
                return positionedNote.position.stepsFromBottomLine;
              })
              .reduce(math.max);
    final double stepHeight = lineSpacing / 2;
    final double aboveStepCount = math.max(0, maxStep - 8).toDouble();
    final double belowStepCount = math.max(0, -minStep).toDouble();
    final double topOverflow = math.max(24.0, aboveStepCount * stepHeight + 24);
    final double bottomOverflow = math.max(
      24.0,
      belowStepCount * stepHeight + 24,
    );
    final double staffTop = topOverflow;
    final double bottomLineY = staffTop + (lineSpacing * 4);
    final double height = bottomLineY + bottomOverflow + 28;

    final List<StaffMeasureLayout> measureLayouts = <StaffMeasureLayout>[];
    final List<StaffEventLayout> eventLayouts = <StaffEventLayout>[];
    double currentLeft = horizontalPadding + leadingWidth;

    for (final measure in sequence.measures) {
      final double measureWidth = math.max(
        minMeasureWidth,
        measure.timeSignature.measureUnits * unitWidth + 72,
      );
      final Rect measureBounds = Rect.fromLTWH(
        currentLeft,
        staffTop - 22,
        measureWidth,
        lineSpacing * 4 + 44,
      );

      measureLayouts.add(
        StaffMeasureLayout(
          index: measure.index,
          bounds: measureBounds,
          timeSignatureLabel: measure.timeSignature.label,
          isActive: sequence.activeMeasureIndex == measure.index,
        ),
      );

      for (final NotationEvent event in measure.events) {
        final double noteCenterX =
            measureBounds.left + 30 + (event.startUnits * unitWidth);

        if (event is NoteEvent) {
          final StaffPosition position =
              StaffPositionCalculator.positionForNote(
                note: event.note,
                clef: clef,
              );

          eventLayouts.add(
            StaffEventLayout(
              event: event,
              noteCenter: Offset(
                noteCenterX,
                bottomLineY - (position.stepsFromBottomLine * stepHeight),
              ),
              position: position,
            ),
          );
        } else {
          eventLayouts.add(
            StaffEventLayout(
              event: event,
              noteCenter: Offset(noteCenterX, staffTop + (lineSpacing * 2)),
              position: null,
            ),
          );
        }
      }

      currentLeft = measureBounds.right + measureSpacing;
    }

    final double width = measureLayouts.isEmpty
        ? 320
        : measureLayouts.last.bounds.right + horizontalPadding;

    return StaffLayoutData(
      width: width,
      height: height,
      staffTop: staffTop,
      bottomLineY: bottomLineY,
      lineSpacing: lineSpacing,
      leadingWidth: leadingWidth,
      measures: measureLayouts,
      events: eventLayouts,
    );
  }
}

class _PositionedNote {
  const _PositionedNote({required this.eventId, required this.position});

  final String eventId;
  final StaffPosition position;
}
