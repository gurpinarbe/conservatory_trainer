import 'notation_event.dart';
import 'time_signature.dart';

class Measure {
  const Measure({
    required this.index,
    required this.timeSignature,
    required this.events,
  });

  final int index;
  final TimeSignature timeSignature;
  final List<NotationEvent> events;

  int get totalUnits => events.fold<int>(
    0,
    (int total, NotationEvent event) => total + event.durationUnits,
  );

  Measure copyWith({
    int? index,
    TimeSignature? timeSignature,
    List<NotationEvent>? events,
  }) {
    return Measure(
      index: index ?? this.index,
      timeSignature: timeSignature ?? this.timeSignature,
      events: events ?? this.events,
    );
  }
}
