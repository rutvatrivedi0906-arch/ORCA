import 'package:flutter_test/flutter_test.dart';
import 'package:marine_app/main.dart';

void main() {
  testWidgets('ORCA splash screen opens and navigates to language selection', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const OrcaApp());

    expect(find.text('ORCA'), findsOneWidget);

    expect(find.text('Marine Intelligence Platform'), findsOneWidget);

    expect(find.text('Intelligence that travels with you.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));

    await tester.pumpAndSettle();

    expect(find.text('Choose Language'), findsOneWidget);

    expect(find.text('Select your preferred language'), findsOneWidget);
  });
}
