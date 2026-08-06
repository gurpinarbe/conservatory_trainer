import 'measure.dart';
import 'notation_event.dart';
import 'music_note.dart';

class NotationSequence {
  const NotationSequence({required this.measures});

  const NotationSequence.empty() : measures = const <Measure>[];

  final List<Measure> measures;

  List<NotationEvent> get allEvents => measures
      .expand((Measure measure) => measure.events)
      .toList(growable: false);

  Set<String> get activeEventIds => allEvents
      .where((NotationEvent event) => event.isActive)
      .map((NotationEvent event) => event.id)
      .toSet();

  Set<int> get activeMidiNoteNumbers => allEvents
      .whereType<NoteEvent>()
      .where((NoteEvent event) => event.isActive)
      .map((NoteEvent event) => event.note.midiNoteNumber)
      .toSet();

  List<MusicNote> get allNotes => allEvents
      .whereType<NoteEvent>()
      .map((NoteEvent event) => event.note)
      .toList(growable: false);

  int? get activeMeasureIndex {
    for (final Measure measure in measures) {
      if (measure.events.any((NotationEvent event) => event.isActive)) {
        return measure.index;
      }
    }
    return null;
  }

  NotationSequence withVisualStates(Set<String> activeEventIds) {
    return NotationSequence(
      measures: measures
          .map((Measure measure) {
            return measure.copyWith(
              events: measure.events
                  .map((NotationEvent event) {
                    final NotationEventVisualState visualState =
                        activeEventIds.contains(event.id)
                        ? NotationEventVisualState.active
                        : NotationEventVisualState.normal;

                    if (event is NoteEvent) {
                      return event.copyWith(visualState: visualState);
                    }
                    if (event is RestEvent) {
                      return event.copyWith(visualState: visualState);
                    }
                    return event;
                  })
                  .toList(growable: false),
            );
          })
          .toList(growable: false),
    );
  }
}
