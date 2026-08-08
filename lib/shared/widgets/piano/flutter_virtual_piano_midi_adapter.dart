import 'package:flutter/material.dart';

/// Bridges `flutter_virtual_piano` callbacks to the app's domain MIDI model.
///
/// The package source for version `0.0.10` defines `noteRange` and callback
/// note values directly in standard MIDI space (`0 == C-1`, `60 == C4`).
/// This adapter currently validates and forwards values unchanged so the
/// package dependency stays isolated from the rest of the app.
class FlutterVirtualPianoMidiAdapter {
  const FlutterVirtualPianoMidiAdapter();

  int? toDomainMidiNote(int packageNote) {
    if (packageNote < 0 || packageNote > 127) {
      return null;
    }

    return packageNote;
  }

  RangeValues toPackageNoteRange({
    required int startMidiNote,
    required int endMidiNote,
  }) {
    return RangeValues(startMidiNote.toDouble(), endMidiNote.toDouble());
  }
}
