import 'package:flutter/material.dart';

import 'quantity_stepper.dart';

void main() {
  runApp(const MaterialApp(home: PantallaPrueba()));
}

/// Pantalla de prueba del componente QuantityStepper.
class PantallaPrueba extends StatefulWidget {
  /// Crea la pantalla de prueba.
  const PantallaPrueba({super.key});

  @override
  State<PantallaPrueba> createState() => _PantallaPruebaState();
}

class _PantallaPruebaState extends State<PantallaPrueba> {
  int cantidad = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuantityStepper con Flutter + Dart')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QuantityStepper(
              onChanged: (valor) {
                setState(() {
                  cantidad = valor;
                });
              },
              onLimitReached: (limite) {
                if (limite == StepperLimit.max) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Has llegado al máximo')),
                  );
                }
                if (limite == StepperLimit.min) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Has llegado al mínimo')),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Text('Cantidad seleccionada: $cantidad'),
          ],
        ),
      ),
    );
  }
}
