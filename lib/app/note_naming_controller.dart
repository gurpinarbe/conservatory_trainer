import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/music/note_naming_system.dart';

final noteNamingControllerProvider =
    NotifierProvider<NoteNamingController, NoteNamingSystem>(
      NoteNamingController.new,
    );

class NoteNamingController extends Notifier<NoteNamingSystem> {
  @override
  NoteNamingSystem build() => NoteNamingSystem.fixedDo;

  void select(NoteNamingSystem system) {
    state = system;
  }
}
