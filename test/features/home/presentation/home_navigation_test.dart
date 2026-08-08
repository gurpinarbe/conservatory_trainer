import 'package:conservatory_trainer/core/audio/piano_audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_helpers/test_support.dart';

void main() {
  testWidgets('English locale shows the home screen in English', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildConservatoryTestApp(
        selectedLocale: const Locale('en'),
        extraOverrides: testAudioOverrides(
          pianoAudioService: FakePianoAudioService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Conservatory Trainer'), findsWidgets);
    expect(find.text('Hear and Sing'), findsOneWidget);
  });

  testWidgets('Turkish locale shows the home screen in Turkish', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildConservatoryTestApp(
        selectedLocale: const Locale('tr'),
        extraOverrides: testAudioOverrides(
          pianoAudioService: FakePianoAudioService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Konservatuvara Hazırlık'), findsWidgets);
    expect(find.text('Duy ve Söyle'), findsOneWidget);
  });

  testWidgets('unsupported device locale falls back to English', (
    WidgetTester tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('es'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      buildConservatoryTestApp(
        extraOverrides: testAudioOverrides(
          pianoAudioService: FakePianoAudioService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Conservatory Trainer'), findsWidgets);
    expect(find.text('Exercise Categories'), findsOneWidget);
  });

  testWidgets('language changes without restarting the app', (
    WidgetTester tester,
  ) async {
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('tr'),
    ];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      buildConservatoryTestApp(
        extraOverrides: testAudioOverrides(
          pianoAudioService: FakePianoAudioService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Konservatuvara Hazırlık'), findsWidgets);

    await tester.ensureVisible(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Conservatory Trainer'), findsWidgets);
    expect(find.text('Hear and Sing'), findsOneWidget);
  });

  testWidgets('tapping a category opens the correct exercise list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildConservatoryTestApp(
        selectedLocale: const Locale('en'),
        extraOverrides: testAudioOverrides(
          pianoAudioService: FakePianoAudioService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Hear and Sing'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hear and Sing'));
    await tester.pumpAndSettle();

    expect(find.text('Single Note Repetition'), findsOneWidget);
    expect(find.text('Two-Note Separation'), findsWidgets);
    expect(find.text('Active'), findsWidgets);
    expect(find.text('Coming Soon'), findsNWidgets(5));
  });

  testWidgets('tapping the active exercise opens the single note screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildConservatoryTestApp(
        selectedLocale: const Locale('en'),
        extraOverrides: testAudioOverrides(
          pianoAudioService: FakePianoAudioService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Hear and Sing'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hear and Sing'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Single Note Repetition'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Single Note Repetition'));
    await tester.pumpAndSettle();

    expect(find.text('Repeat the note you hear'), findsOneWidget);
    expect(find.text('Listen'), findsWidgets);
  });

  testWidgets('coming soon exercise opens the unavailable screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildConservatoryTestApp(
        selectedLocale: const Locale('en'),
        extraOverrides: testAudioOverrides(
          pianoAudioService: FakePianoAudioService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Hear and Sing'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hear and Sing'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Two-Note Separation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Two-Note Separation'));
    await tester.pumpAndSettle();

    expect(find.text('Two-Note Separation'), findsWidgets);
    expect(find.text('This exercise will be available soon.'), findsOneWidget);
  });

  testWidgets('small phone layout does not overflow in English and Turkish', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final Locale locale in const <Locale>[Locale('en'), Locale('tr')]) {
      await tester.pumpWidget(
        buildConservatoryTestApp(
          selectedLocale: locale,
          extraOverrides: testAudioOverrides(
            pianoAudioService: FakePianoAudioService(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    }
  });
}
