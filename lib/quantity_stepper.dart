import 'package:flutter/material.dart';

/// Límite alcanzado por el selector.
enum StepperLimit {
  /// Límite mínimo.
  min,

  /// Límite máximo.
  max,
}

/// Callback que recibe el límite alcanzado.
typedef LimitReached = void Function(StepperLimit limit);

/// Calcula el siguiente valor dentro de los límites.
int nextStepperValue({
  required int current,
  required int delta,
  required int min,
  required int max,
}) {
  final next = current + delta;

  if (next < min) return min;
  if (next > max) return max;

  return next;
}

/// Widget para incrementar o decrementar una cantidad.
class QuantityStepper extends StatefulWidget {
  /// Valor mínimo permitido.
  final int min;

  /// Valor máximo permitido.
  final int max;

  /// Incremento o decremento por interacción.
  final int step;

  /// Valor inicial; si es `null`, se utiliza [min].
  final int? initialValue;

  /// Etiqueta de accesibilidad.
  final String semanticLabel;

  /// Tooltip del botón para restar.
  final String decrementTooltip;

  /// Tooltip del botón para sumar.
  final String incrementTooltip;

  /// Callback que recibe el nuevo valor.
  final ValueChanged<int>? onChanged;

  /// Callback que se ejecuta al alcanzar un límite.
  final LimitReached? onLimitReached;

  /// Crea un selector de cantidades.
  ///
  /// [min] debe ser menor que [max], [step] positivo y
  /// [initialValue], si existe, debe estar dentro de los límites.
  const QuantityStepper({
    super.key,
    this.min = 0,
    this.max = 10,
    this.step = 1,
    this.initialValue,
    this.semanticLabel = 'Cantidad',
    this.decrementTooltip = 'Restar',
    this.incrementTooltip = 'Sumar',
    this.onChanged,
    this.onLimitReached,
  }) : assert(min < max, 'min debe ser menor que max'),
       assert(step > 0, 'step debe ser mayor que 0'),
       assert(
         initialValue == null || (initialValue >= min && initialValue <= max),
         'initialValue debe estar entre min y max',
       );

  /// Devuelve el valor mínimo.
  int get getMin => min;

  ///Crea el estado del selector
  @override
  State<QuantityStepper> createState() {
    return QuantityStepperState();
  }
}

/// Estado del selector de cantidades.
class QuantityStepperState extends State<QuantityStepper> {
  // Estado mutable: el valor empieza por el mínimo
  late int _valor;

  @override
  void initState() {
    super.initState();
    _valor = widget.initialValue ?? widget.min;
  }

  void _actualizarValor(int nuevoValor) {
    if (nuevoValor == _valor) return;

    setState(() {
      _valor = nuevoValor;
    });

    widget.onChanged?.call(_valor);

    if (_valor == widget.min) {
      widget.onLimitReached?.call(StepperLimit.min);
    } else if (_valor == widget.max) {
      widget.onLimitReached?.call(StepperLimit.max);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón para restar
        IconButton(
          tooltip: widget.decrementTooltip,
          icon: const Icon(Icons.remove),
          onPressed: _valor <= widget.min
              ? null
              : () {
                  _actualizarValor(
                    nextStepperValue(
                      current: _valor,
                      delta: -widget.step,
                      min: widget.min,
                      max: widget.max,
                    ),
                  );
                },
        ),
        // Valor actual
        Semantics(
          label: widget.semanticLabel,
          child: Text(
            '$_valor',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Botón para sumar
        IconButton(
          tooltip: widget.incrementTooltip,
          icon: const Icon(Icons.add),
          onPressed: _valor >= widget.max
              ? null
              : () {
                  _actualizarValor(
                    nextStepperValue(
                      current: _valor,
                      delta: widget.step,
                      min: widget.min,
                      max: widget.max,
                    ),
                  );
                },
        ),
      ],
    );
  }
}
