import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/music/music_clef.dart';
import '../../../core/music/notation_sequence.dart';
import 'custom_painter_notation_renderer.dart';
import 'notation_renderer.dart';
import 'staff_layout.dart';

class MusicStaffView extends StatefulWidget {
  MusicStaffView({
    super.key,
    required this.sequence,
    required this.clef,
    required this.showActiveHighlights,
    NotationRenderer? renderer,
  }) : renderer = renderer ?? CustomPainterNotationRenderer(clef: clef);

  final NotationSequence sequence;
  final MusicClef clef;
  final bool showActiveHighlights;
  final NotationRenderer renderer;

  @override
  State<MusicStaffView> createState() => _MusicStaffViewState();
}

class _MusicStaffViewState extends State<MusicStaffView> {
  final ScrollController _scrollController = ScrollController();
  double _viewportWidth = 0;

  @override
  void didUpdateWidget(covariant MusicStaffView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showActiveHighlights &&
        !_sameEventIds(
          oldWidget.sequence.activeEventIds,
          widget.sequence.activeEventIds,
        ) &&
        widget.sequence.activeEventIds.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerOnActiveEvent();
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
    final StaffLayoutData layout = StaffLayoutCalculator.build(
      sequence: widget.sequence,
      clef: widget.clef,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _viewportWidth = constraints.maxWidth;
        final double viewWidth = math.max(layout.width, constraints.maxWidth);

        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: viewWidth,
                height: layout.height,
                child: widget.renderer.build(
                  context: context,
                  layout: layout,
                  showActiveHighlights: widget.showActiveHighlights,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _centerOnActiveEvent() {
    if (!_scrollController.hasClients) {
      return;
    }

    final StaffLayoutData layout = StaffLayoutCalculator.build(
      sequence: widget.sequence,
      clef: widget.clef,
    );
    final String firstActiveEventId = widget.sequence.activeEventIds.first;
    final Rect? activeRect = layout.rectForEvent(firstActiveEventId);
    if (activeRect == null) {
      return;
    }

    final double targetOffset = activeRect.center.dx - (_viewportWidth / 2);
    final double clampedOffset = targetOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    );
  }

  bool _sameEventIds(Set<String> first, Set<String> second) {
    if (first.length != second.length) {
      return false;
    }

    for (final String value in first) {
      if (!second.contains(value)) {
        return false;
      }
    }

    return true;
  }
}
