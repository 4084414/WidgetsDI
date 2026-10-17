import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diwidgets/quantity_stepper.dart';

void main() {
  // Pruebas Unitarias
  // Comprobamos que la función nextStepperValue calcula bien
  // el siguiente valor sin necesidad de crear la interfaz.
  group('nextStepperValue', () {
    test('sumar incremento', () {
      // Si el valor actual es 5 y sumamos 1, el resultado debe ser 6.
      expect(nextStepperValue(current: 5, step: 1, min: 0, max: 10), 6);
    });

    test('restar decremento', () {
      // Si estamos en 5 y restamos 1, el resultado debe ser 4.
      expect(nextStepperValue(current: 5, step: -1, min: 0, max: 10), 4);
    });

    test('no baja del mínimo', () {
      // Comprobamos que el valor no pueda ser menor que 0.
      // Aunque restemos 1, debe seguir siendo 0.
      expect(nextStepperValue(current: 0, step: -1, min: 0, max: 10), 0);
    });

    test('no supera el máximo', () {
      // Si ya estamos en el máximo, no debe permitir sumar más.
      expect(nextStepperValue(current: 10, step: 1, min: 0, max: 10), 10);
    });

    test('limita un salto al máximo', () {
      // Si estamos en 9 y sumamos 2, el resultado no puede ser 11.
      // La función debe limitarlo al máximo permitido, que es 10.
      expect(nextStepperValue(current: 9, step: 2, min: 0, max: 10), 10);
    });
  });

  // PRUEBAS DE WIDGET
  // En este grupo comprobamos el funcionamiento del componente
  // QuantityStepper, incluyendo los botones y los eventos.

  group('QuantityStepper', () {
    testWidgets('sumar muestra el nuevo valor y emite onChanged', (
      WidgetTester tester,
    ) async {
      // Creamos una variable para guardar el valor que nos devuelva
      // el componente cuando cambie la cantidad.
      int? valorEmitido;

      // Montamos la interfaz de prueba con el valor inicial en 5.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantityStepper(
              initialValue: 5,
              onChanged: (valor) {
                // Guardamos el nuevo valor cuando se ejecuta onChanged.
                valorEmitido = valor;
              },
            ),
          ),
        ),
      );

      // Buscamos el botón Sumar y simulamos una pulsación.
      await tester.tap(find.byTooltip('Sumar'));

      // Actualizamos la interfaz después de la pulsación.
      await tester.pump();

      // Comprobamos que en pantalla aparece el nuevo valor, que es 6.
      expect(find.text('6'), findsOneWidget);

      // Comprobamos que el evento onChanged también ha devuelto el 6.
      expect(valorEmitido, 6);
    });

    testWidgets('el botón restar está desactivado en el mínimo', (
      WidgetTester tester,
    ) async {
      // Creamos el componente con mínimo 0 y valor inicial 0.
      // Así podemos comprobar qué ocurre cuando ya estamos en el mínimo.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuantityStepper(min: 0, max: 10, initialValue: 0),
          ),
        ),
      );

      // Buscamos el botón que tiene el tooltip "Restar"
      // y obtenemos su IconButton para revisar sus propiedades.
      final botonRestar = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('Restar'),
          matching: find.byType(IconButton),
        ),
      );

      // Comprobamos que onPressed sea null.
      // En Flutter, esto significa que el botón está desactivado.
      expect(botonRestar.onPressed, isNull);
    });

    testWidgets('onLimitReached recibe StepperLimit.max', (
      WidgetTester tester,
    ) async {
      // Creamos una variable para guardar el límite que se alcance.
      StepperLimit? limiteRecibido;

      // Montamos el componente con máximo 5 y valor inicial 4.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuantityStepper(
              min: 0,
              max: 5,
              initialValue: 4,
              onLimitReached: (limite) {
                // Guardamos el límite que nos comunica el componente.
                limiteRecibido = limite;
              },
            ),
          ),
        ),
      );

      // Pulsamos Sumar para pasar de 4 a 5, que es el máximo.
      await tester.tap(find.byTooltip('Sumar'));
      await tester.pump();

      // Comprobamos que el valor mostrado sea 5.
      expect(find.text('5'), findsOneWidget);

      // Comprobamos que se ha notificado que hemos llegado al máximo.
      expect(limiteRecibido, StepperLimit.max);
    });
  });
}
