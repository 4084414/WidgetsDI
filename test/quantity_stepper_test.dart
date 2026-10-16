import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diwidgets/quantity_stepper.dart';

void main() {
  // PRUEBAS UNITARIAS
  group('nextStepperValue', () {
    test('suma el incremento', () {
      expect(nextStepperValue(current: 5, delta: 1, min: 0, max: 10), 6);
    });

    test('resta el decremento', () {
      expect(nextStepperValue(current: 5, delta: -1, min: 0, max: 10), 4);
    });

    test('no baja del mínimo', () {
      expect(nextStepperValue(current: 0, delta: -1, min: 0, max: 10), 0);
    });

    test('no supera el máximo', () {
      expect(nextStepperValue(current: 10, delta: 1, min: 0, max: 10), 10);
    });

    test('limita un salto al máximo', () {
      expect(nextStepperValue(current: 9, delta: 2, min: 0, max: 10), 10);
    });
  });

  // PRUEBAS DE WIDGET
  group('QuantityStepper', () {
    testWidgets('sumar muestra el nuevo valor y emite onChanged', (
      WidgetTester tester,
    ) async {
      int? valorEmitido;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantityStepper(
              initialValue: 5,
              onChanged: (valor) {
                valorEmitido = valor;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Sumar'));
      await tester.pump();

      expect(find.text('6'), findsOneWidget);
      expect(valorEmitido, 6);
    });

    testWidgets('el botón restar está desactivado en el mínimo', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuantityStepper(min: 0, max: 10, initialValue: 0),
          ),
        ),
      );

      final botonRestar = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('Restar'),
          matching: find.byType(IconButton),
        ),
      );

      expect(botonRestar.onPressed, isNull);
    });

    testWidgets('onLimitReached recibe StepperLimit.max', (
      WidgetTester tester,
    ) async {
      StepperLimit? limiteRecibido;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantityStepper(
              min: 0,
              max: 5,
              initialValue: 4,
              onLimitReached: (limite) {
                limiteRecibido = limite;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('Sumar'));
      await tester.pump();

      expect(find.text('5'), findsOneWidget);
      expect(limiteRecibido, StepperLimit.max);
    });
  });
}
