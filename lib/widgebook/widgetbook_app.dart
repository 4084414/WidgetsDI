import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'quantity_stepper_use_cases.dart';

void main() {
  runApp(const WidgetbookApp());
}

/// Aplicación de Widgetbook para probar los componentes.
class WidgetbookApp extends StatelessWidget {
  /// Crea la aplicación de Widgetbook.
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(directories: [quantityStepperUseCases]);
  }
}
