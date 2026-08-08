import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../application/exercise_localizations.dart';
import '../domain/exercise_category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.availableCount,
    required this.totalCount,
    this.onTap,
  });

  final ExerciseCategory category;
  final int availableCount;
  final int totalCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

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
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(_iconFor(category), color: colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text(
                category.localizedTitle(l10n),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.localizedDescription(l10n),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _CategoryChip(
                    label: l10n.availableProgress(availableCount, totalCount),
                    icon: Icons.check_circle_outline_rounded,
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_rounded, color: colorScheme.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(ExerciseCategory category) {
    return switch (category) {
      ExerciseCategory.hearAndSing => Icons.graphic_eq_rounded,
      ExerciseCategory.hearAndTap => Icons.podcasts_rounded,
      ExerciseCategory.hearAndWrite => Icons.edit_note_rounded,
      ExerciseCategory.readAndPerform => Icons.menu_book_rounded,
      ExerciseCategory.examSimulation => Icons.fact_check_rounded,
      ExerciseCategory.freePractice => Icons.piano_rounded,
    };
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.icon});

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
