import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../app/locale_controller.dart';
import '../../../app/note_naming_controller.dart';
import '../../../core/music/music_localizations.dart';
import '../../../core/music/note_naming_system.dart';
import '../../../l10n/l10n.dart';
import '../application/exercise_catalog.dart';
import '../domain/exercise_category.dart';
import 'category_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ExerciseCatalog catalog = ref.watch(exerciseCatalogProvider);
    final String startRoute =
        catalog.findById(ExerciseCatalogIds.singleNoteRepeat)?.route ??
        AppRoute.home;
    final AppLocalizations l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int categoryColumnCount = _gridColumnCount(
              constraints.maxWidth,
            );
            final double categoryCardWidth = _gridItemWidth(
              constraints.maxWidth,
              categoryColumnCount,
            );
            final bool useWideHeroLayout = constraints.maxWidth >= 920;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (useWideHeroLayout)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(child: _HeroSection()),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 320,
                          child: _TodayPracticeCard(
                            onStartPressed: () => context.push(startRoute),
                          ),
                        ),
                      ],
                    )
                  else ...[
                    const _HeroSection(),
                    const SizedBox(height: 16),
                    _TodayPracticeCard(
                      onStartPressed: () => context.push(startRoute),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    l10n.exerciseCategoriesTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: catalog.categories
                        .map((ExerciseCategory category) {
                          return SizedBox(
                            width: categoryCardWidth,
                            child: CategoryCard(
                              category: category,
                              availableCount: catalog.availableCountForCategory(
                                category,
                              ),
                              totalCount: catalog
                                  .exercisesForCategory(category)
                                  .length,
                              onTap: () => context.push(
                                AppRoute.categoryPath(category.id),
                              ),
                            ),
                          );
                        })
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 28),
                  const _SettingsSection(),
                  const SizedBox(height: 28),
                  const _ProductDifferenceSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static int _gridColumnCount(double width) {
    if (width >= 1100) {
      return 3;
    }
    if (width >= 700) {
      return 2;
    }
    return 1;
  }

  static double _gridItemWidth(double width, int columnCount) {
    final double horizontalPadding = 40;
    final double totalSpacing = (columnCount - 1) * 16;
    return (width - horizontalPadding - totalSpacing) / columnCount;
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: <Color>[colorScheme.primary, const Color(0xFF2F8F6F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              l10n.homePrototypeChip,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.homeTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.homeDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayPracticeCard extends StatelessWidget {
  const _TodayPracticeCard({required this.onStartPressed});

  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.todayPracticeTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.todayPracticePlanName,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.todayPracticePlanDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onStartPressed,
                child: Text(l10n.startPracticeButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends ConsumerWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;
    final Locale? selectedLocale = ref.watch(localeControllerProvider);
    final NoteNamingSystem noteNamingSystem = ref.watch(
      noteNamingControllerProvider,
    );

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.settingsDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.languageSettingTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ChoiceChip(
                  label: Text(l10n.languageSystemOption),
                  selected: selectedLocale == null,
                  onSelected: (_) {
                    ref
                        .read(localeControllerProvider.notifier)
                        .useSystemLocale();
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.languageEnglishOption),
                  selected: selectedLocale == LocaleController.english,
                  onSelected: (_) {
                    ref.read(localeControllerProvider.notifier).selectEnglish();
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.languageTurkishOption),
                  selected: selectedLocale == LocaleController.turkish,
                  onSelected: (_) {
                    ref.read(localeControllerProvider.notifier).selectTurkish();
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              l10n.noteNamingSettingTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noteNamingSettingDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: NoteNamingSystem.values
                  .map((NoteNamingSystem option) {
                    return ChoiceChip(
                      label: Text(option.localizedLabel(l10n)),
                      tooltip: option.localizedDescription(l10n),
                      selected: noteNamingSystem == option,
                      onSelected: (_) {
                        ref
                            .read(noteNamingControllerProvider.notifier)
                            .select(option);
                      },
                    );
                  })
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDifferenceSection extends StatelessWidget {
  const _ProductDifferenceSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = context.l10n;
    final List<String> items = <String>[
      l10n.productDifferenceItemListen,
      l10n.productDifferenceItemPianoStaff,
      l10n.productDifferenceItemExam,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.productDifferenceTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items
              .map((String item) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 220,
                    maxWidth: 340,
                  ),
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_rounded),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }
}
