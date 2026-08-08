import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/note_naming_controller.dart';
import '../../../core/music/music_clef.dart';
import '../../../core/music/music_localizations.dart';
import '../../../core/music/note_label_formatter.dart';
import '../../../core/music/note_naming_system.dart';
import '../../../core/music/pitch_result_state.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/notation/music_staff_panel.dart';
import '../../../shared/widgets/piano/piano_panel.dart';
import '../application/single_note_exercise_controller.dart';
import '../domain/single_note_exercise_snapshot.dart';
import '../domain/single_note_exercise_state.dart';
import 'widgets/exercise_metric_card.dart';

class SingleNoteScreen extends ConsumerStatefulWidget {
  const SingleNoteScreen({super.key});

  static const NoteLabelFormatter _noteLabelFormatter = NoteLabelFormatter();

  @override
  ConsumerState<SingleNoteScreen> createState() => _SingleNoteScreenState();
}

class _SingleNoteScreenState extends ConsumerState<SingleNoteScreen> {
  String? _statusMessage;

  @override
  Widget build(BuildContext context) {
    final SingleNoteExerciseState exerciseState = ref.watch(
      singleNoteExerciseControllerProvider,
    );
    final SingleNoteExerciseSnapshot snapshot = exerciseState.snapshot;
    final NoteNamingSystem noteNamingSystem = ref.watch(
      noteNamingControllerProvider,
    );
    final AppLocalizations l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.singleNoteAppBarTitle)),
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
              onClefPreferenceChanged: (MusicClefPreference value) {
                ref
                    .read(singleNoteExerciseControllerProvider.notifier)
                    .setStaffClefPreference(value);
              },
            );
            final Widget actionButtons = _ActionButtonsSection(
              onListenPressed: _handleListenPressed,
              onRecordPressed: _handleRecordPressed,
              statusMessage: _statusMessage,
            );
            final Widget metricsSection = _MetricsSection(
              snapshot: snapshot,
              noteNamingSystem: noteNamingSystem,
            );
            final Widget pianoPanel = PianoPanel(
              highlightedMidiNotes: exerciseState.highlightedMidiNotes,
              pressedMidiNotes: exerciseState.pressedMidiNotes,
              showHighlightedMidiNotes: exerciseState.showNotesOnPiano,
              autoFollowHighlightedNotes: exerciseState.autoFollowOctave,
              lastPlayedNote: exerciseState.lastPlayedNote,
              soundFontStatusMessage: exerciseState.pianoStatusType
                  ?.localizedMessage(l10n),
              isSoundFontLoaded: exerciseState.isPianoSoundFontLoaded,
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
                unawaited(_handleDevelopmentDemoPressed());
              },
              onPlayLa4DemoPressed: () {
                unawaited(
                  ref
                      .read(singleNoteExerciseControllerProvider.notifier)
                      .playLa4Demo(),
                );
              },
              onPlayCMajorChordDemoPressed: () {
                unawaited(
                  ref
                      .read(singleNoteExerciseControllerProvider.notifier)
                      .playCMajorChordDemo(),
                );
              },
              onNotePressed: (int midiNoteNumber) {
                unawaited(
                  ref
                      .read(singleNoteExerciseControllerProvider.notifier)
                      .handlePianoNotePressed(midiNoteNumber),
                );
              },
              onNoteReleased: (int midiNoteNumber) {
                unawaited(
                  ref
                      .read(singleNoteExerciseControllerProvider.notifier)
                      .handlePianoNoteReleased(midiNoteNumber),
                );
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
                                  context,
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
                        context,
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

  static String _formatFrequency(BuildContext context, double value) {
    final String localeName = Localizations.localeOf(context).toLanguageTag();
    final int fractionDigits = value == value.roundToDouble() ? 0 : 1;
    final NumberFormat format = NumberFormat.decimalPatternDigits(
      locale: localeName,
      decimalDigits: fractionDigits,
    );
    return '${format.format(value)} Hz';
  }

  static String _formatCent(BuildContext context, double value) {
    final String localeName = Localizations.localeOf(context).toLanguageTag();
    final NumberFormat format = NumberFormat.decimalPatternDigits(
      locale: localeName,
      decimalDigits: 1,
    );
    return format.format(value);
  }

  Future<void> _handleListenPressed() async {
    final SingleNoteUserFeedback feedback = await ref
        .read(singleNoteExerciseControllerProvider.notifier)
        .handleListenPressed();

    if (!mounted) {
      return;
    }

    _setStatusMessage(
      _feedbackMessage(
        context,
        feedback,
        ref.read(singleNoteExerciseControllerProvider),
      ),
    );
  }

  Future<void> _handleRecordPressed() async {
    final SingleNoteUserFeedback feedback = await ref
        .read(singleNoteExerciseControllerProvider.notifier)
        .handleRecordPressed();

    if (!mounted) {
      return;
    }

    _setStatusMessage(
      _feedbackMessage(
        context,
        feedback,
        ref.read(singleNoteExerciseControllerProvider),
      ),
    );
  }

  Future<void> _handleDevelopmentDemoPressed() async {
    final SingleNoteUserFeedback feedback = await ref
        .read(singleNoteExerciseControllerProvider.notifier)
        .playDevelopmentDemoSequence();

    if (!mounted) {
      return;
    }

    _setStatusMessage(
      _feedbackMessage(
        context,
        feedback,
        ref.read(singleNoteExerciseControllerProvider),
      ),
    );
  }

  String _feedbackMessage(
    BuildContext context,
    SingleNoteUserFeedback feedback,
    SingleNoteExerciseState state,
  ) {
    final AppLocalizations l10n = context.l10n;
    final String audioStatus =
        state.pianoStatusType?.localizedMessage(l10n) ??
        l10n.pianoSoundFontMissingMessage;

    return switch (feedback) {
      SingleNoteUserFeedback.previewSoundPlaying =>
        l10n.previewSoundPlayingMessage,
      SingleNoteUserFeedback.previewSoundShowing =>
        l10n.previewSoundShowingMessage(audioStatus),
      SingleNoteUserFeedback.microphonePermissionDenied =>
        l10n.microphonePermissionDeniedMessage,
      SingleNoteUserFeedback.recordPreview => l10n.recordPreviewMessage,
      SingleNoteUserFeedback.demoSequencePlaying =>
        l10n.demoSequencePlayingMessage,
      SingleNoteUserFeedback.demoSequenceShowing =>
        l10n.demoSequenceShowingMessage(audioStatus),
    };
  }

  void _setStatusMessage(String message) {
    setState(() {
      _statusMessage = message;
    });
  }
}

class _ActionButtonsSection extends StatelessWidget {
  const _ActionButtonsSection({
    required this.onListenPressed,
    required this.onRecordPressed,
    this.statusMessage,
  });

  final VoidCallback onListenPressed;
  final VoidCallback onRecordPressed;
  final String? statusMessage;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onListenPressed,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(l10n.listenButton),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onRecordPressed,
            icon: const Icon(Icons.mic_none_rounded),
            label: Text(l10n.singStartButton),
          ),
        ),
        const SizedBox(height: 14),
        _ActionStatusBanner(message: statusMessage),
      ],
    );
  }
}

class _ActionStatusBanner extends StatelessWidget {
  const _ActionStatusBanner({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 72),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: message == null
            ? const SizedBox.shrink()
            : Container(
                key: ValueKey<String>(message!),
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({
    required this.snapshot,
    required this.noteNamingSystem,
  });

  final SingleNoteExerciseSnapshot snapshot;
  final NoteNamingSystem noteNamingSystem;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double metricWidth = _metricWidth(constraints.maxWidth);
        final String detectedNoteName = SingleNoteScreen._noteLabelFormatter
            .formatScientificName(
              snapshot.detectedNote,
              namingSystem: noteNamingSystem,
            );

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: metricWidth,
              child: ExerciseMetricCard(
                label: l10n.detectedNoteLabel,
                value: detectedNoteName,
                caption: l10n.detectedNoteCaption,
                icon: Icons.music_note_rounded,
              ),
            ),
            SizedBox(
              width: metricWidth,
              child: ExerciseMetricCard(
                label: l10n.detectedFrequencyLabel,
                value: _SingleNoteScreenState._formatFrequency(
                  context,
                  snapshot.detectedNote.frequencyHz,
                ),
                caption: l10n.detectedFrequencyCaption,
                icon: Icons.tune_rounded,
              ),
            ),
            SizedBox(
              width: metricWidth,
              child: ExerciseMetricCard(
                label: l10n.centDifferenceLabel,
                value: _SingleNoteScreenState._formatCent(
                  context,
                  snapshot.centDifference,
                ),
                caption: l10n.centDifferenceCaption,
                icon: Icons.speed_rounded,
              ),
            ),
            SizedBox(
              width: metricWidth,
              child: _ResultCard(resultState: snapshot.resultState),
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
    final AppLocalizations l10n = context.l10n;

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
            l10n.singleNoteHeroTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.singleNoteHeroDescription,
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
                label: l10n.targetNoteLabel,
                value: l10n.targetNoteOnStaff,
                icon: Icons.album_rounded,
              ),
              _InfoPill(
                label: l10n.targetFrequencyLabel,
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
  const _ResultCard({required this.resultState});

  final PitchResultState resultState;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppLocalizations l10n = context.l10n;

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
              l10n.resultTitle,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _ResultScale(activeState: resultState),
            const SizedBox(height: 16),
            Text(
              resultState.localizedLabel(l10n),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.resultPanelDescription,
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
    final AppLocalizations l10n = context.l10n;

    return Row(
      children: [
        _ResultSegment(
          label: l10n.pitchFlat,
          isActive: activeState == PitchResultState.flat,
        ),
        const SizedBox(width: 8),
        _ResultSegment(
          label: l10n.pitchCorrect,
          isActive: activeState == PitchResultState.correct,
        ),
        const SizedBox(width: 8),
        _ResultSegment(
          label: l10n.pitchSharp,
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
