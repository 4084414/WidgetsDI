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
  required int step,
  required int min,
  required int max,
}) {
  final next = current + step;

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

/// Estado del selector de cantidades
/// Aquí controlamos el valor actual y lo que ocurre al pulsar los botones.
class QuantityStepperState extends State<QuantityStepper> {
  // Guardamos la cantidad actual.
  // Es una variable que puede cambiar mientras usamos el componente.
  // late indica que se inicializará antes de utilizarla
  late int _valor;

  @override
  void initState() {
    // Llamamos al método de la clase padre para inicializar correctamente
    // el estado del widget.
    super.initState();

    // Si se ha indicado un valor inicial, lo usamos.
    // Si no, empezamos con el valor mínimo permitido
    _valor = widget.initialValue ?? widget.min;
  }

  // Método para actualizar la cantidad cuando se pulsa un botón
  void _actualizarValor(int nuevoValor) {
    // Si el nuevo valor es igual al actual, no hacemos nada.
    // Así evitamos actualizaciones que no son necesarias
    if (nuevoValor == _valor) return;

    // Actualizamos el valor y avisamos a Flutter de que debe
    // reconstruir la interfaz para mostrar el cambio
    setState(() {
      _valor = nuevoValor;
    });

    // Si existe la función onChanged, le enviamos el nuevo valor
    // El símbolo ? permite llamar a la función solo si no es null.
    widget.onChanged?.call(_valor);

    // Comprobamos si hemos llegado al mínimo.
    if (_valor == widget.min) {
      // Si existe onLimitReached avisamos de que se ha alcanzado
      // el límite mínimo.
      widget.onLimitReached?.call(StepperLimit.min);

      // Si no estamos en el mínimo comprobamos si hemos llegado al máximo
    } else if (_valor == widget.max) {
      // Avisamos de que se ha alcanzado el límite máximo.
      widget.onLimitReached?.call(StepperLimit.max);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construimos la interfaz del selector
    // Row coloca sus elementos uno al lado del otro.
    return Row(
      // La fila ocupa solo el espacio que necesitan sus elementos.
      mainAxisSize: MainAxisSize.min,
      children: [
        // BOTÓN PARA RESTAR
        IconButton(
          // Texto de ayuda que aparece al mantener el cursor sobre el botón.
          tooltip: widget.decrementTooltip,

          // Icono con el símbolo de restar.
          icon: const Icon(Icons.remove),

          // Si estamos en el mínimo o por debajo, desactivamos el botón.
          // Si no, permitimos pulsarlo y restamos el valor del step.
          onPressed: _valor <= widget.min
              ? null
              : () {
                  _actualizarValor(
                    nextStepperValue(
                      current: _valor,
                      step: -widget.step,
                      min: widget.min,
                      max: widget.max,
                    ),
                  );
                },
        ),

        // VALOR ACTUAL
        Semantics(
          // Etiqueta que ayuda a los lectores de pantalla a identificar
          // qué representa el número.
          label: widget.semanticLabel,

          // Mostramos la cantidad actual en pantalla.
          child: Text(
            '$_valor',

            // Damos al número un tamaño de 18 y lo ponemos en negrita.
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // BOTÓN PARA SUMAR
        IconButton(
          // Texto de ayuda del botón para incrementar la cantidad.
          tooltip: widget.incrementTooltip,

          // Icono con el símbolo de sumar.
          icon: const Icon(Icons.add),

          // Si hemos llegado al máximo, desactivamos el botón.
          // Si todavía no hemos llegado, sumamos el valor del step.
          onPressed: _valor >= widget.max
              ? null
              : () {
                  _actualizarValor(
                    nextStepperValue(
                      current: _valor,
                      step: widget.step,
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
