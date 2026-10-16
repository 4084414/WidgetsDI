import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../quantity_stepper.dart';

/// Casos de uso de QuantityStepper para Widgetbook.
final quantityStepperUseCases = WidgetbookFolder(
  name: 'QuantityStepper',
  children: [
    WidgetbookComponent(
      name: 'QuantityStepper',
      useCases: [
        // Caso 1: valores por defecto
        WidgetbookUseCase(
          name: 'Predeterminado',
          builder: (context) {
            return const Center(child: QuantityStepper());
          },
        ),

        // Caso 2: configurable mediante knobs
        WidgetbookUseCase(
          name: 'Configurable',
          builder: (context) {
            final min = context.knobs.int.slider(
              label: 'Min',
              initialValue: 0,
              min: 0,
              max: 9,
            );

            final max = context.knobs.int.slider(
              label: 'Max',
              initialValue: 10,
              min: 1,
              max: 20,
            );

            final step = context.knobs.int.slider(
              label: 'Step',
              initialValue: 1,
              min: 1,
              max: 5,
            );

            return Center(
              child: QuantityStepper(
                min: min,
                max: max <= min ? min + 1 : max,
                step: step,
              ),
            );
          },
        ),
      ],
    ),
  ],
);
