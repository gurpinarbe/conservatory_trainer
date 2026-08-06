import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import 'exercise_card.dart';
import 'exercise_module.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<ExerciseModule> _modules = <ExerciseModule>[
    ExerciseModule(
      title: 'Tek Ses Tekrarı',
      description: 'Tek bir hedef notayı duyup aynı sesi tekrar etmeyi çalış.',
      icon: Icons.graphic_eq_rounded,
      isAvailable: true,
      routePath: AppRoute.singleNote.path,
    ),
    ExerciseModule(
      title: 'Nota Okuma ve Yazma',
      description: 'Porte üzerinde notaları okuyup yazmaya adım adım başla.',
      icon: Icons.music_video_rounded,
      isAvailable: true,
      routePath: AppRoute.noteReading.path,
    ),
    ExerciseModule(
      title: 'Çift Ses Ayırma',
      description: 'İki sesi birbirinden ayırt etme becerini geliştir.',
      icon: Icons.hearing_rounded,
      isAvailable: false,
    ),
    ExerciseModule(
      title: 'Üç ve Dört Ses Ayırma',
      description: 'Akor içindeki sesleri tek tek duymaya hazırlan.',
      icon: Icons.library_music_rounded,
      isAvailable: false,
    ),
    ExerciseModule(
      title: 'Melodi Tekrarı',
      description: 'Kısa melodileri dinleyip sesinle tekrar etmeyi dene.',
      icon: Icons.music_note_rounded,
      isAvailable: false,
    ),
    ExerciseModule(
      title: 'Ritim Tekrarı',
      description: 'Duyduğun ritimleri aynı akışla geri vurmaya hazırlan.',
      icon: Icons.piano_rounded,
      isAvailable: false,
    ),
    ExerciseModule(
      title: 'Sınav Simülasyonu',
      description: 'Farklı egzersizleri tek akışta çözerek prova yap.',
      icon: Icons.fact_check_rounded,
      isAvailable: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int columnCount = _gridColumnCount(constraints.maxWidth);
            final double cardHeight = columnCount == 1 ? 292 : 252;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeroSection(),
                  const SizedBox(height: 24),
                  Text(
                    'Egzersizler',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Dar telefonlarda tek sütun, geniş ekranlarda daha rahat
                  // taranabilen bir kart ızgarası gösteriyoruz.
                  GridView.builder(
                    itemCount: _modules.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: cardHeight,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final ExerciseModule module = _modules[index];
                      return ExerciseCard(
                        title: module.title,
                        description: module.description,
                        icon: module.icon,
                        isAvailable: module.isAvailable,
                        onTap: () => _openModule(context, module),
                      );
                    },
                  ),
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

  void _openModule(BuildContext context, ExerciseModule module) {
    if (!module.isAvailable || module.routePath == null) {
      return;
    }

    context.push(module.routePath!);
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

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
              'İlk çalışma prototipi',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Konservatuvara Hazırlık',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Kulak, melodi ve ritim çalışmalarını tek bir yerde yap.',
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
