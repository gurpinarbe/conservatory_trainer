import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/l10n.dart';
import '../application/exercise_catalog.dart';
import '../application/exercise_localizations.dart';
import '../domain/exercise_category.dart';
import '../domain/exercise_definition.dart';
import 'exercise_card.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key, required this.category});

  final ExerciseCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ExerciseCatalog catalog = ref.watch(exerciseCatalogProvider);
    final AppLocalizations l10n = context.l10n;
    final List<ExerciseDefinition> exercises = catalog.exercisesForCategory(
      category,
    );
    final int availableCount = catalog.availableCountForCategory(category);

    return Scaffold(
      appBar: AppBar(title: Text(category.localizedTitle(l10n))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryHeroCard(
                category: category,
                availableCount: availableCount,
                totalCount: exercises.length,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.categoryExercisesTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              ...exercises.map((ExerciseDefinition exercise) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ExerciseCard(
                    exercise: exercise,
                    onTap: () => context.push(exercise.route),
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

class _CategoryHeroCard extends StatelessWidget {
  const _CategoryHeroCard({
    required this.category,
    required this.availableCount,
    required this.totalCount,
  });

  final ExerciseCategory category;
  final int availableCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: <Color>[
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.localizedTitle(l10n),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            category.localizedDescription(l10n),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.94),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _CountChip(
                label: l10n.activeLabel,
                value: availableCount.toString(),
              ),
              _CountChip(label: l10n.totalLabel, value: totalCount.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          Text(
            ': ',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
