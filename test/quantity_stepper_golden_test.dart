import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diwidgets/quantity_stepper.dart';

void main() {
  testWidgets('QuantityStepper se muestra correctamente con valor 5', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: QuantityStepper(min: 0, max: 10, initialValue: 5),
          ),
        ),
      ),
    );

    expect(find.text('5'), findsOneWidget);

    await expectLater(
      find.byType(QuantityStepper),
      matchesGoldenFile('goldens/quantity_stepper.png'),
    );
  });
}
