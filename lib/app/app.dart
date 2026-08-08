import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n.dart';
import 'app_router.dart';
import 'app_theme.dart';
import 'locale_controller.dart';

class ConservatoryTrainerApp extends ConsumerWidget {
  const ConservatoryTrainerApp({super.key});

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Locale? selectedLocale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => context.l10n.appTitle,
      theme: AppTheme.lightTheme,
      routerConfig: ref.watch(appRouterProvider),
      locale: selectedLocale,
      supportedLocales: supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
            if (locale == null) {
              return const Locale('en');
            }

            for (final Locale supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }

            return const Locale('en');
          },
    );
  }
}
