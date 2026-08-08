import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/note_naming_controller.dart';
import '../../../core/music/measure.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/notation_event.dart';
import '../../../core/music/notation_sequence.dart';
import '../../../core/music/note_label_formatter.dart';
import '../../../core/music/note_naming_system.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/notation/music_staff_view.dart';
import '../application/staff_note_quiz_controller.dart';
import '../domain/staff_note_quiz_state.dart';

class StaffNoteQuizScreen extends ConsumerWidget {
  const StaffNoteQuizScreen({super.key});

  static const NoteLabelFormatter _noteLabelFormatter = NoteLabelFormatter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StaffNoteQuizState state = ref.watch(staffNoteQuizControllerProvider);
    final NoteNamingSystem noteNamingSystem = ref.watch(
      noteNamingControllerProvider,
    );
    final NotationSequence sequence = _visualSequence(state);
    final AppLocalizations l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.staffQuizAppBarTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _IntroCard(),
              const SizedBox(height: 20),
              _ScoreStrip(state: state),
              const SizedBox(height: 20),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.staffQuizPromptTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.staffQuizPromptDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
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
                          sequence: sequence,
                          clef: state.question.clef,
                          showActiveHighlights: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _OptionGrid(state: state, noteNamingSystem: noteNamingSystem),
              if (state.isAnswered) ...[
                const SizedBox(height: 20),
                _ResultCard(state: state, noteNamingSystem: noteNamingSystem),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      ref
                          .read(staffNoteQuizControllerProvider.notifier)
                          .nextQuestion();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.newQuestionButton),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static NotationSequence _visualSequence(StaffNoteQuizState state) {
    if (!state.isAnswered) {
      return state.question.sequence;
    }

    return NotationSequence(
      measures: state.question.sequence.measures
          .map((Measure measure) {
            return measure.copyWith(
              events: measure.events
                  .map((NotationEvent event) {
                    if (event is! NoteEvent) {
                      return event;
                    }

                    return event.copyWith(
                      visualState: state.wasLastAnswerCorrect == true
                          ? NotationEventVisualState.correct
                          : NotationEventVisualState.corrected,
                    );
                  })
                  .toList(growable: false),
            );
          })
          .toList(growable: false),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.staffQuizIntroTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.staffQuizIntroDescription,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ScoreStrip extends StatelessWidget {
  const _ScoreStrip({required this.state});

  final StaffNoteQuizState state;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _ScoreChip(
          label: l10n.correctLabel,
          value: state.correctAnswerCount.toString(),
        ),
        _ScoreChip(
          label: l10n.wrongLabel,
          value: state.wrongAnswerCount.toString(),
        ),
        _ScoreChip(
          label: l10n.totalLabel,
          value: state.totalAnsweredQuestionCount.toString(),
        ),
      ],
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            ': ',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionGrid extends ConsumerWidget {
  const _OptionGrid({required this.state, required this.noteNamingSystem});

  final StaffNoteQuizState state;
  final NoteNamingSystem noteNamingSystem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double buttonWidth = constraints.maxWidth >= 540
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: state.question.options
              .map((MusicNote option) {
                final bool isSelected =
                    state.selectedAnswer?.midiNoteNumber ==
                    option.midiNoteNumber;
                final bool isCorrect =
                    state.question.targetNote.midiNoteNumber ==
                    option.midiNoteNumber;
                final ThemeData theme = Theme.of(context);
                final ColorScheme colorScheme = theme.colorScheme;
                final Color backgroundColor = state.isAnswered && isCorrect
                    ? Colors.green.shade100
                    : state.isAnswered && isSelected && !isCorrect
                    ? colorScheme.errorContainer
                    : colorScheme.surface;

                return SizedBox(
                  width: buttonWidth,
                  child: OutlinedButton(
                    onPressed: state.isAnswered
                        ? null
                        : () {
                            ref
                                .read(staffNoteQuizControllerProvider.notifier)
                                .submitAnswer(option);
                          },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        StaffNoteQuizScreen._noteLabelFormatter
                            .formatScientificName(
                              option,
                              namingSystem: noteNamingSystem,
                            ),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                );
              })
              .toList(growable: false),
        );
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.state, required this.noteNamingSystem});

  final StaffNoteQuizState state;
  final NoteNamingSystem noteNamingSystem;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;
    final bool isCorrect = state.wasLastAnswerCorrect == true;
    final String targetNoteLabel = StaffNoteQuizScreen._noteLabelFormatter
        .formatScientificName(
          state.question.targetNote,
          namingSystem: noteNamingSystem,
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade100 : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect ? l10n.correctAnswerTitle : l10n.wrongAnswerTitle,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            targetNoteLabel,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isCorrect
                ? l10n.staffQuizCorrectMessage
                : l10n.staffQuizWrongMessage(targetNoteLabel),
          ),
        ],
      ),
    );
  }
}
