import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/music/pitch_result_state.dart';
import '../../../shared/widgets/notation/music_staff_panel.dart';
import '../../../shared/widgets/piano/piano_panel.dart';
import '../application/single_note_exercise_controller.dart';
import '../domain/single_note_exercise_state.dart';
import '../domain/single_note_exercise_snapshot.dart';
import 'widgets/exercise_metric_card.dart';

class SingleNoteScreen extends ConsumerWidget {
  const SingleNoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SingleNoteExerciseState exerciseState = ref.watch(
      singleNoteExerciseControllerProvider,
    );
    final SingleNoteExerciseSnapshot snapshot = exerciseState.snapshot;

    return Scaffold(
      appBar: AppBar(title: const Text('Tek Ses Tekrarı')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget staffPanel = MusicStaffPanel(
              sequence: exerciseState.displayedNotationSequence,
              isExpanded: exerciseState.isStaffPanelExpanded,
              showActiveHighlights: exerciseState.showNotesOnStaff,
              clefPreference: exerciseState.staffClefPreference,
              onExpandedChanged: (bool value) {
                ref
                    .read(singleNoteExerciseControllerProvider.notifier)
                    .setStaffPanelExpanded(value);
              },
              onShowActiveHighlightsChanged: (bool value) {
                ref
                    .read(singleNoteExerciseControllerProvider.notifier)
                    .setShowNotesOnStaff(value);
              },
              onClefPreferenceChanged: (value) {
                ref
                    .read(singleNoteExerciseControllerProvider.notifier)
                    .setStaffClefPreference(value);
              },
            );
            final Widget actionButtons = _ActionButtonsSection(
              onListenPressed: () => _handleListenPressed(context, ref),
              onRecordPressed: () => _handleRecordPressed(context, ref),
            );
            final Widget metricsSection = _MetricsSection(snapshot: snapshot);
            final Widget pianoPanel = PianoPanel(
              highlightedMidiNotes: exerciseState.highlightedMidiNotes,
              showHighlightedMidiNotes: exerciseState.showNotesOnPiano,
              autoFollowHighlightedNotes: exerciseState.autoFollowOctave,
              lastPlayedNote: exerciseState.lastPlayedNote,
              onShowHighlightedMidiNotesChanged: (bool value) {
                ref
                    .read(singleNoteExerciseControllerProvider.notifier)
                    .setShowNotesOnPiano(value);
              },
              onAutoFollowHighlightedNotesChanged: (bool value) {
                ref
                    .read(singleNoteExerciseControllerProvider.notifier)
                    .setAutoFollowOctave(value);
              },
              onDevelopmentDemoPressed: () {
                unawaited(_handleDevelopmentDemoPressed(context, ref));
              },
              onNotePressed: (note) {
                ref
                    .read(singleNoteExerciseControllerProvider.notifier)
                    .handleNotePressed(note);
              },
            );
            final bool useLandscapeLayout = _shouldUseLandscapeLayout(
              constraints,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (useLandscapeLayout) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 11,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _TargetSection(
                                targetFrequency: _formatFrequency(
                                  snapshot.targetNote.frequencyHz,
                                ),
                              ),
                              const SizedBox(height: 24),
                              actionButtons,
                              const SizedBox(height: 24),
                              metricsSection,
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(flex: 9, child: staffPanel),
                      ],
                    ),
                    const SizedBox(height: 24),
                    pianoPanel,
                  ] else ...[
                    _TargetSection(
                      targetFrequency: _formatFrequency(
                        snapshot.targetNote.frequencyHz,
                      ),
                    ),
                    const SizedBox(height: 24),
                    staffPanel,
                    const SizedBox(height: 24),
                    actionButtons,
                    const SizedBox(height: 24),
                    metricsSection,
                    const SizedBox(height: 24),
                    pianoPanel,
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static bool _shouldUseLandscapeLayout(BoxConstraints constraints) =>
      constraints.maxWidth >= 900 ||
      (constraints.maxWidth > constraints.maxHeight &&
          constraints.maxWidth >= 700);

  static String _formatFrequency(double value) {
    final int fractionDigits = value == value.roundToDouble() ? 0 : 1;
    return '${value.toStringAsFixed(fractionDigits)} Hz';
  }

  static String _formatCent(double value) => value.toStringAsFixed(1);

  Future<void> _handleListenPressed(BuildContext context, WidgetRef ref) async {
    final String message = await ref
        .read(singleNoteExerciseControllerProvider.notifier)
        .handleListenPressed();

    if (!context.mounted) {
      return;
    }

    _showPreviewMessage(context, message);
  }

  Future<void> _handleRecordPressed(BuildContext context, WidgetRef ref) async {
    final String message = await ref
        .read(singleNoteExerciseControllerProvider.notifier)
        .handleRecordPressed();

    if (!context.mounted) {
      return;
    }

    _showPreviewMessage(context, message);
  }

  Future<void> _handleDevelopmentDemoPressed(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final String message = await ref
        .read(singleNoteExerciseControllerProvider.notifier)
        .playDevelopmentDemoSequence();

    if (!context.mounted) {
      return;
    }

    _showPreviewMessage(context, message);
  }

  void _showPreviewMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ActionButtonsSection extends StatelessWidget {
  const _ActionButtonsSection({
    required this.onListenPressed,
    required this.onRecordPressed,
  });

  final VoidCallback onListenPressed;
  final VoidCallback onRecordPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onListenPressed,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Sesi Dinle'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onRecordPressed,
            icon: const Icon(Icons.mic_none_rounded),
            label: const Text('Söylemeye Başla'),
          ),
        ),
      ],
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({required this.snapshot});

  final SingleNoteExerciseSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double metricWidth = _metricWidth(constraints.maxWidth);

        // Kart verilerini ekrandan değil uygulama katmanından alıyoruz.
        // Gerçek analiz geldiğinde widget yapısını bozmak gerekmeyecek.
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: metricWidth,
              child: ExerciseMetricCard(
                label: 'Algılanan nota',
                value: snapshot.detectedNote.turkishScientificName,
                caption: 'Şimdilik örnek veri gösteriliyor.',
                icon: Icons.music_note_rounded,
              ),
            ),
            SizedBox(
              width: metricWidth,
              child: ExerciseMetricCard(
                label: 'Algılanan frekans',
                value: SingleNoteScreen._formatFrequency(
                  snapshot.detectedNote.frequencyHz,
                ),
                caption: 'Hedef notaya yakın örnek frekans değeri.',
                icon: Icons.tune_rounded,
              ),
            ),
            SizedBox(
              width: metricWidth,
              child: ExerciseMetricCard(
                label: 'Cent farkı',
                value: SingleNoteScreen._formatCent(snapshot.centDifference),
                caption: 'Eksi değer, sesin biraz pes kaldığını gösterir.',
                icon: Icons.speed_rounded,
              ),
            ),
            SizedBox(
              width: metricWidth,
              child: _ResultCard(
                resultState: snapshot.resultState,
                resultMessage: snapshot.resultMessage,
              ),
            ),
          ],
        );
      },
    );
  }

  static double _metricWidth(double maxWidth) {
    if (maxWidth >= 720) {
      return (maxWidth - 16) / 2;
    }

    return maxWidth;
  }
}

class _TargetSection extends StatelessWidget {
  const _TargetSection({required this.targetFrequency});

  final String targetFrequency;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Duyduğun sesi tekrar et',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Önce hedef sesi dinle, sonra aynı notayı sesinle yakalamayı dene. Nota adı yazmak yerine portedeki konumu gösteriyoruz.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _InfoPill(
                label: 'Hedef nota',
                value: 'Porte üzerinde',
                icon: Icons.album_rounded,
              ),
              _InfoPill(
                label: 'Hedef frekans',
                value: targetFrequency,
                icon: Icons.waves_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: 20, color: colorScheme.primary),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.resultState, required this.resultMessage});

  final PitchResultState resultState;
  final String resultMessage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sonuç',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _ResultScale(activeState: resultState),
            const SizedBox(height: 16),
            Text(
              resultMessage,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pes / Doğru / Tiz göstergesi gerçek analiz eklendiğinde canlı güncellenecek.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultScale extends StatelessWidget {
  const _ResultScale({required this.activeState});

  final PitchResultState activeState;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ResultSegment(
          label: 'Pes',
          isActive: activeState == PitchResultState.flat,
        ),
        const SizedBox(width: 8),
        _ResultSegment(
          label: 'Doğru',
          isActive: activeState == PitchResultState.correct,
        ),
        const SizedBox(width: 8),
        _ResultSegment(
          label: 'Tiz',
          isActive: activeState == PitchResultState.sharp,
        ),
      ],
    );
  }
}

class _ResultSegment extends StatelessWidget {
  const _ResultSegment({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isActive ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
