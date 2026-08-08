import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../application/exercise_localizations.dart';
import '../domain/exercise_definition.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key, required this.exercise, this.onTap});

  final ExerciseDefinition exercise;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;
    final Color tintColor = exercise.isAvailable
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: tintColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      _iconFor(exercise.iconId),
                      color: colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: exercise.isAvailable
                          ? colorScheme.primaryContainer
                          : colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      exercise.isAvailable
                          ? l10n.statusActive
                          : l10n.comingSoon,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: exercise.isAvailable
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                exercise.localizedTitle(l10n),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                exercise.localizedDescription(l10n),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    label: exercise.difficulty.localizedLabel(l10n),
                    icon: Icons.trending_up_rounded,
                  ),
                  _InfoChip(
                    label: l10n.durationMinutes(
                      exercise.estimatedDuration.inMinutes,
                    ),
                    icon: Icons.schedule_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                exercise.isAvailable ? l10n.openTraining : l10n.viewDetails,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: exercise.isAvailable
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(String iconId) {
    return switch (iconId) {
      'single-note' => Icons.graphic_eq_rounded,
      'double-note' => Icons.hearing_rounded,
      'triple-note' => Icons.library_music_rounded,
      'chord-stack' => Icons.piano_rounded,
      'melody' => Icons.music_note_rounded,
      'interval' => Icons.swap_vert_rounded,
      'rhythm-repeat' => Icons.multitrack_audio_rounded,
      'complete-rhythm' => Icons.rule_rounded,
      'find-rhythm' => Icons.search_rounded,
      'clap' => Icons.pan_tool_alt_rounded,
      'staff-note' => Icons.edit_note_rounded,
      'write-rhythm' => Icons.timeline_rounded,
      'melodic-dictation' => Icons.queue_music_rounded,
      'staff-chord' => Icons.piano_rounded,
      'find-note' => Icons.music_note_rounded,
      'sing-note' => Icons.mic_rounded,
      'play-piano' => Icons.piano_rounded,
      'sight-reading' => Icons.auto_stories_rounded,
      'solfege' => Icons.record_voice_over_rounded,
      'exam-beginner' => Icons.fact_check_rounded,
      'exam-intermediate' => Icons.assignment_turned_in_rounded,
      'exam-advanced' => Icons.workspace_premium_rounded,
      'custom-exam' => Icons.tune_rounded,
      'free-piano' => Icons.piano_rounded,
      'free-staff' => Icons.music_video_rounded,
      'metronome' => Icons.av_timer_rounded,
      'tuner' => Icons.tune_rounded,
      'range-test' => Icons.stacked_line_chart_rounded,
      _ => Icons.apps_rounded,
    };
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
