import 'package:flutter/material.dart';

import '../../../core/music/note_value.dart';

class NoteValueSymbol extends StatelessWidget {
  const NoteValueSymbol({super.key, required this.noteValue, this.size = 72});

  final NoteValue noteValue;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NoteValueSymbolPainter(
          noteValue: noteValue,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _NoteValueSymbolPainter extends CustomPainter {
  const _NoteValueSymbolPainter({required this.noteValue, required this.color});

  final NoteValue noteValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.42, size.height * 0.62);
    final bool isWhole = noteValue == NoteValue.whole;
    final bool isOpenHead =
        isWhole ||
        noteValue == NoteValue.half ||
        noteValue == NoteValue.dottedHalf;
    final Rect noteRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.26,
      height: size.height * 0.16,
    );
    final Paint fillPaint = Paint()
      ..color = isOpenHead ? Colors.white : color
      ..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.36);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawOval(noteRect, fillPaint);
    canvas.drawOval(noteRect, strokePaint);
    canvas.restore();

    if (!isWhole) {
      final Offset stemStart = Offset(
        center.dx + noteRect.width / 2,
        center.dy,
      );
      final Offset stemEnd = Offset(
        stemStart.dx,
        stemStart.dy - size.height * 0.42,
      );
      canvas.drawLine(stemStart, stemEnd, strokePaint);

      final int flagCount = switch (noteValue) {
        NoteValue.eighth || NoteValue.dottedEighth => 1,
        NoteValue.sixteenth => 2,
        _ => 0,
      };

      for (int index = 0; index < flagCount; index++) {
        final Path path = Path()
          ..moveTo(stemEnd.dx, stemEnd.dy + (index * 8))
          ..quadraticBezierTo(
            stemEnd.dx + 16,
            stemEnd.dy + 4 + (index * 8),
            stemEnd.dx + 8,
            stemEnd.dy + 14 + (index * 8),
          );
        canvas.drawPath(path, strokePaint);
      }
    }

    if (noteValue.isDotted) {
      canvas.drawCircle(
        Offset(center.dx + noteRect.width, center.dy - 2),
        3,
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NoteValueSymbolPainter oldDelegate) {
    return oldDelegate.noteValue != noteValue || oldDelegate.color != color;
  }
}
