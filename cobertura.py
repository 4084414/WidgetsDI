archivo = "coverage/lcov.info"

encontrado = False
lineas = 0
lineas_cubiertas = 0

with open(archivo, encoding="utf-8") as f:
    for linea in f:
        linea = linea.strip()

        if linea.startswith("SF:"):
            encontrado = linea.replace("\\", "/").endswith(
                "/lib/quantity_stepper.dart"
            ) or linea.replace("\\", "/") == "SF:lib/quantity_stepper.dart"

        elif encontrado and linea.startswith("LF:"):
            lineas = int(linea[3:])

        elif encontrado and linea.startswith("LH:"):
            lineas_cubiertas = int(linea[3:])

        elif linea == "end_of_record" and encontrado:
            if lineas > 0:
                porcentaje = lineas_cubiertas / lineas * 100

                print("Archivo: quantity_stepper.dart")
                print(f"Líneas cubiertas: {lineas_cubiertas}/{lineas}")
                print(f"Porcentaje de cobertura: {porcentaje:.2f}%")
            else:
                print("No hay líneas ejecutables registradas.")

            break
    else:
        print("No se encontró quantity_stepper.dart en coverage/lcov.info.")
