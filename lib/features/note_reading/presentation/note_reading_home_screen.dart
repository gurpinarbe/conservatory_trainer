import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../home/presentation/exercise_card.dart';
import '../../home/presentation/exercise_module.dart';

class NoteReadingHomeScreen extends StatelessWidget {
  const NoteReadingHomeScreen({super.key});

  static final List<ExerciseModule> _modules = <ExerciseModule>[
    ExerciseModule(
      title: 'Portedeki Notayı Bul',
      description: 'Portede gördüğün notayı adı ve oktavıyla birlikte tanı.',
      icon: Icons.music_note_rounded,
      isAvailable: true,
      routePath: AppRoute.staffNoteQuiz.path,
    ),
    ExerciseModule(
      title: 'Duyduğun Sesi Porteye Yerleştir',
      description: 'Duyduğun notayı ileride porteye yerleştirme çalışması.',
      icon: Icons.hearing_rounded,
      isAvailable: false,
    ),
    ExerciseModule(
      title: 'Piyanoda Çalınan Notayı Bul',
      description: 'Klavye ile porte arasında nota eşleştirmesi yap.',
      icon: Icons.piano_rounded,
      isAvailable: false,
    ),
    ExerciseModule(
      title: 'Nota Değerlerini Öğren',
      description: 'Birlikten sekizliğe kadar temel nota sürelerini dinle.',
      icon: Icons.av_timer_rounded,
      isAvailable: true,
      routePath: AppRoute.noteValueLesson.path,
    ),
    ExerciseModule(
      title: 'Eksik Ölçüyü Tamamla',
      description: 'Ölçü içindeki ritmik boşluğu doğru değerle tamamla.',
      icon: Icons.rule_folder_rounded,
      isAvailable: false,
    ),
    ExerciseModule(
      title: 'Ritmi Porteye Yaz',
      description: 'Ritim kalıplarını notasyon olarak kurmayı dene.',
      icon: Icons.timeline_rounded,
      isAvailable: false,
    ),
    ExerciseModule(
      title: 'Melodiyi Porteye Yaz',
      description: 'Gelecek aşama için boş ölçü editörü hazırlığı burada.',
      icon: Icons.edit_note_rounded,
      isAvailable: false,
      routePath: AppRoute.melodyWritingSandbox.path,
    ),
    ExerciseModule(
      title: 'Deşifre Çalışması',
      description: 'İleride anlık okuma pratiği için eklenecek çalışma.',
      icon: Icons.auto_stories_rounded,
      isAvailable: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nota Okuma ve Yazma')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int columnCount = constraints.maxWidth >= 1000
                ? 3
                : constraints.maxWidth >= 680
                ? 2
                : 1;
            final double cardHeight = columnCount == 1 ? 252 : 232;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeroCard(),
                  const SizedBox(height: 24),
                  Text(
                    'Egzersizler',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
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

  void _openModule(BuildContext context, ExerciseModule module) {
    if (!module.isAvailable || module.routePath == null) {
      return;
    }

    context.push(module.routePath!);
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF274C77), Color(0xFF5A7DA0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Porte ile Çalış',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Notaları görerek, duyarak ve piyanoda karşılığını izleyerek daha kalıcı çalış.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
