# diwidgets

Proyecto Flutter donde voy desarrollando y probando distintos widgets.

## QuantityStepper

`QuantityStepper` es un componente que permite aumentar o reducir una cantidad usando dos botones. Se puede configurar el valor mínimo y máximo, además de la cantidad que cambia cada vez que se pulsa un botón.

### Ejemplo de uso

```dart
QuantityStepper(
  min: 0,
  max: 10,
  initialValue: 5,
  onChanged: (value) {
    debugPrint('Cantidad: $value');
  },
)
Propiedades principales
min y max: indican la cantidad mínima y máxima.

step: establece cuánto aumenta o disminuye la cantidad.

initialValue: indica el valor inicial.

onChanged: se ejecuta cuando cambia la cantidad.

onLimitReached: avisa cuando se alcanza el mínimo o el máximo.