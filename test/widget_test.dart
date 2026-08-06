import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conservatory_trainer/app/app.dart';

void main() {
  testWidgets('Home screen opens the pitch repetition exercise', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: ConservatoryTrainerApp()),
    );

    expect(find.text('Konservatuvara Hazırlık'), findsOneWidget);
    expect(find.text('Tek Ses Tekrarı'), findsOneWidget);
    expect(find.text('Yakında'), findsNWidgets(5));

    await tester.tap(find.text('Tek Ses Tekrarı'));
    await tester.pumpAndSettle();

    expect(find.text('Duyduğun sesi tekrar et'), findsOneWidget);
    expect(find.text('Sesi Dinle'), findsOneWidget);
    expect(find.text('Söylemeye Başla'), findsOneWidget);
  });
}
