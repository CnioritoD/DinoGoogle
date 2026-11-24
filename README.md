# DinoGoogle

DinoGoogle es un juego de desplazamiento lateral desarrollado en Smalltalk con Pharo 12 y Morphic. El personaje salta o se agacha para esquivar obstáculos. Superar un obstáculo o recoger una moneda suma un punto. Una colisión con un obstáculo termina la partida.

## Requisitos

- Pharo 12 de 64 bits, con Iceberg para clonar y cargar el repositorio.
- Conexión a GitHub para clonar desde Iceberg. Si ya tenés una copia del código, podés cargarla desde disco.


## Ejecutar y jugar

Abrí el **Playground**, seleccioná esta expresión y ejecutala con **Do it**.

```smalltalk
AplicacionJuego new abrir
```

Presioná **JUGAR** para iniciar la partida.

| Acción | Control |
| --- | --- |
| Saltar | Barra espaciadora, flecha arriba o clic izquierdo en el escenario |
| Agacharse | Mantener presionada la flecha abajo. Soltala para volver a pararte. |
| Empezar otra partida | **REINICIAR** en la pantalla de partida terminada |
| Volver al menú inicial | **SALIR** en la pantalla de partida terminada |

## Estructura del repositorio

- `src/DinoGoogle/` contiene las clases del modelo y la interfaz.
- `docs/` contiene el [diagrama UML](docs/diagrama-de-clases.svg) y su [fuente editable](docs/diagrama-de-clases.dot).
