import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/music/note_value.dart';
import '../../../shared/widgets/notation/note_value_symbol.dart';
import '../application/note_value_lesson_controller.dart';

class NoteValueLessonScreen extends ConsumerWidget {
  const NoteValueLessonScreen({super.key});

  static const List<_LessonItem> _items = <_LessonItem>[
    _LessonItem(noteValue: NoteValue.whole, example: 'Ta-a-a-a'),
    _LessonItem(noteValue: NoteValue.half, example: 'Ta-a'),
    _LessonItem(noteValue: NoteValue.quarter, example: 'Ta'),
    _LessonItem(noteValue: NoteValue.eighth, example: 'Ti-ti'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NoteValueLessonState state = ref.watch(
      noteValueLessonControllerProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Nota Değerlerini Öğren')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _LessonHeader(),
              const SizedBox(height: 18),
              ..._items.map((item) {
                final bool isActive = state.isPreviewing(item.noteValue);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _LessonCard(
                    item: item,
                    isActive: isActive,
                    activeDuration: state.activeDuration,
                    onPlayPressed: () {
                      ref
                          .read(noteValueLessonControllerProvider.notifier)
                          .preview(item.noteValue);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temel Nota Süreleri',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Ön izlemeler 60 BPM üzerinden çalışır. Şimdilik süre vurgusu ve örnek ses birlikte kullanılıyor.',
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.item,
    required this.isActive,
    required this.activeDuration,
    required this.onPlayPressed,
  });

  final _LessonItem item;
  final bool isActive;
  final Duration? activeDuration;
  final VoidCallback onPlayPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: NoteValueSymbol(noteValue: item.noteValue),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.noteValue.turkishName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '4/4 içinde ${item.noteValue.beatsInFourFour} vuruş',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Örnek: ${item.example}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isActive && activeDuration != null) ...[
              const SizedBox(height: 14),
              TweenAnimationBuilder<double>(
                key: ValueKey<String>(
                  'note-value-preview-${item.noteValue.name}',
                ),
                tween: Tween<double>(begin: 0, end: 1),
                duration: activeDuration!,
                builder: (BuildContext context, double value, Widget? child) {
                  return LinearProgressIndicator(value: value);
                },
              ),
            ],
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                onPressed: onPlayPressed,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Dinle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonItem {
  const _LessonItem({required this.noteValue, required this.example});

  final NoteValue noteValue;
  final String example;
}
