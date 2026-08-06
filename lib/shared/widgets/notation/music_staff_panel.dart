import 'package:flutter/material.dart';

import '../../../core/music/music_clef.dart';
import '../../../core/music/music_clef_selector.dart';
import '../../../core/music/notation_sequence.dart';
import 'custom_painter_notation_renderer.dart';
import 'music_staff_view.dart';

class MusicStaffPanel extends StatelessWidget {
  const MusicStaffPanel({
    super.key,
    required this.sequence,
    required this.isExpanded,
    required this.showActiveHighlights,
    required this.clefPreference,
    required this.onExpandedChanged,
    required this.onShowActiveHighlightsChanged,
    required this.onClefPreferenceChanged,
  });

  final NotationSequence sequence;
  final bool isExpanded;
  final bool showActiveHighlights;
  final MusicClefPreference clefPreference;
  final ValueChanged<bool> onExpandedChanged;
  final ValueChanged<bool> onShowActiveHighlightsChanged;
  final ValueChanged<MusicClefPreference> onClefPreferenceChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MusicClef resolvedClef =
        clefPreference.fixedClef ??
        MusicClefSelector.selectBestClef(sequence.allNotes);
    final String timeSignatureLabel = sequence.measures.isEmpty
        ? '-'
        : sequence.measures.first.timeSignature.label;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                key: const ValueKey<String>('notation-panel-toggle'),
                onPressed: () => onExpandedChanged(!isExpanded),
                icon: Icon(
                  isExpanded
                      ? Icons.music_off_rounded
                      : Icons.music_note_rounded,
                ),
                label: Text(isExpanded ? 'Porteyi Kapat' : 'Porteyi Aç'),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Porte Üzerindeki Gösterim',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Aynı MIDI notası ses, piyano ve porte tarafından ortak olarak kullanılır.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _InfoChip(
                                label: 'Çözülen anahtar',
                                value: _clefLabel(resolvedClef),
                              ),
                              _InfoChip(
                                label: 'Ölçü',
                                value: timeSignatureLabel,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            value: showActiveHighlights,
                            onChanged: onShowActiveHighlightsChanged,
                            title: const Text('Çalan notaları portede göster'),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Anahtar seçimi',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                <MusicClefPreference>[
                                  MusicClefPreference.auto,
                                  MusicClefPreference.treble,
                                  MusicClefPreference.bass,
                                ].map((MusicClefPreference option) {
                                  return ChoiceChip(
                                    label: Text(option.label),
                                    selected: clefPreference == option,
                                    onSelected: (_) {
                                      onClefPreferenceChanged(option);
                                    },
                                  );
                                }).toList(),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: MusicStaffView(
                              sequence: sequence,
                              clef: resolvedClef,
                              showActiveHighlights: showActiveHighlights,
                              renderer: CustomPainterNotationRenderer(
                                clef: resolvedClef,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  static String _clefLabel(MusicClef clef) {
    return switch (clef) {
      MusicClef.treble => 'Sol Anahtarı',
      MusicClef.bass => 'Fa Anahtarı',
      MusicClef.alto => 'Alto Anahtarı',
      MusicClef.tenor => 'Tenor Anahtarı',
    };
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
