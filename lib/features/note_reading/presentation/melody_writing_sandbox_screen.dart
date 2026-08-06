import 'package:flutter/material.dart';

import '../../../core/music/measure.dart';
import '../../../core/music/music_clef.dart';
import '../../../core/music/notation_event.dart';
import '../../../core/music/notation_sequence.dart';
import '../../../core/music/time_signature.dart';
import '../../../shared/widgets/notation/music_staff_view.dart';

class MelodyWritingSandboxScreen extends StatelessWidget {
  const MelodyWritingSandboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotationSequence emptySequence = NotationSequence(
      measures: const <Measure>[
        Measure(
          index: 0,
          timeSignature: TimeSignature.fourFour(),
          events: <NotationEvent>[],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Melodiyi Porteye Yaz')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bu ekran ileride sürükle-bırak nota yerleştirme için kullanılacak.',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: MusicStaffView(
                  sequence: emptySequence,
                  clef: MusicClef.treble,
                  showActiveHighlights: false,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Planlanan araçlar: nota değeri seçimi, sus ekleme, yanlış notayı silme, sağa-sola taşıma ve ölçü bütünlüğü kontrolü.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
