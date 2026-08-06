import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/music/measure.dart';
import '../../../core/music/music_note.dart';
import '../../../core/music/notation_event.dart';
import '../../../core/music/notation_sequence.dart';
import '../../../shared/widgets/notation/music_staff_view.dart';
import '../application/staff_note_quiz_controller.dart';
import '../domain/staff_note_quiz_state.dart';

class StaffNoteQuizScreen extends ConsumerWidget {
  const StaffNoteQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StaffNoteQuizState state = ref.watch(staffNoteQuizControllerProvider);
    final NotationSequence sequence = _visualSequence(state);

    return Scaffold(
      appBar: AppBar(title: const Text('Portedeki Notayı Bul')),
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
                        'Portedeki notayı seç',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bu alıştırmada oktav bilgisi de değerlendiriliyor.',
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
              _OptionGrid(state: state),
              if (state.isAnswered) ...[
                const SizedBox(height: 20),
                _ResultCard(state: state),
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
                    label: const Text('Yeni Soru'),
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
            'Notayı Gör ve Adını Bul',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Şimdilik Sol anahtarında Do4 ile Do5 arasındaki notalar üretiliyor.',
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
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _ScoreChip(label: 'Doğru', value: state.correctAnswerCount.toString()),
        _ScoreChip(label: 'Yanlış', value: state.wrongAnswerCount.toString()),
        _ScoreChip(
          label: 'Toplam',
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
            '$label: ',
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
  const _OptionGrid({required this.state});

  final StaffNoteQuizState state;

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
          children: state.question.options.map((MusicNote option) {
            final bool isSelected =
                state.selectedAnswer?.midiNoteNumber == option.midiNoteNumber;
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
                    option.turkishScientificName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.state});

  final StaffNoteQuizState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isCorrect = state.wasLastAnswerCorrect == true;

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
            isCorrect ? 'Doğru cevap' : 'Yanlış cevap',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            state.question.targetNote.turkishScientificName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isCorrect
                ? 'Notayı doğru oktavla birlikte tanıdın.'
                : 'Doğru cevap ${state.question.targetNote.turkishScientificName} olmalıydı.',
          ),
        ],
      ),
    );
  }
}
