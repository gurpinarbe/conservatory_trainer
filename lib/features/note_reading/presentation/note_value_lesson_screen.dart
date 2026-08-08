import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/music/music_localizations.dart';
import '../../../core/music/note_value.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/notation/note_value_symbol.dart';
import '../application/note_value_lesson_controller.dart';

class NoteValueLessonScreen extends ConsumerWidget {
  const NoteValueLessonScreen({super.key});

  static const List<NoteValue> _items = <NoteValue>[
    NoteValue.whole,
    NoteValue.half,
    NoteValue.quarter,
    NoteValue.eighth,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NoteValueLessonState state = ref.watch(
      noteValueLessonControllerProvider,
    );
    final AppLocalizations l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.noteValueLessonAppBarTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _LessonHeader(),
              const SizedBox(height: 18),
              ..._items.map((NoteValue item) {
                final bool isActive = state.isPreviewing(item);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _LessonCard(
                    noteValue: item,
                    example: _exampleFor(item, l10n),
                    isActive: isActive,
                    activeDuration: state.activeDuration,
                    onPlayPressed: () {
                      ref
                          .read(noteValueLessonControllerProvider.notifier)
                          .preview(item);
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

  static String _exampleFor(NoteValue noteValue, AppLocalizations l10n) {
    return switch (noteValue) {
      NoteValue.whole => l10n.noteValueExampleWhole,
      NoteValue.half => l10n.noteValueExampleHalf,
      NoteValue.quarter => l10n.noteValueExampleQuarter,
      NoteValue.eighth => l10n.noteValueExampleEighth,
      _ => l10n.noteValueExampleQuarter,
    };
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

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
            l10n.noteValueLessonHeaderTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.noteValueLessonHeaderDescription,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.noteValue,
    required this.example,
    required this.isActive,
    required this.activeDuration,
    required this.onPlayPressed,
  });

  final NoteValue noteValue;
  final String example;
  final bool isActive;
  final Duration? activeDuration;
  final VoidCallback onPlayPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

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
                  child: Center(child: NoteValueSymbol(noteValue: noteValue)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        noteValue.localizedName(l10n),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.noteValueBeatsLabel(noteValue.beatsInFourFour),
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.examplePattern(example),
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
                key: ValueKey<String>('note-value-preview-${noteValue.name}'),
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
                label: Text(l10n.listenShortButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
