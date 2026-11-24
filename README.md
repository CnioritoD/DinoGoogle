# DinoGoogle

DinoGoogle es un juego de desplazamiento lateral desarrollado en Smalltalk con Pharo 12 y Morphic. El personaje salta o se agacha para esquivar obstáculos. Superar un obstáculo o recoger una moneda suma un punto. Una colisión con un obstáculo termina la partida.

## Requisitos

- Pharo 12 de 64 bits, con Iceberg para clonar y cargar el repositorio.
- Conexión a GitHub para clonar desde Iceberg. Si ya tenés una copia del código, podés cargarla desde disco.

## Cargar el proyecto con Iceberg

1. Abrí una imagen de **Pharo 12** y abrí **Iceberg**.
2. En **Repositories**, elegí **Add** y la opción de clonar desde una URL. Usá `https://github.com/CnioritoD/DinoGoogle.git`.
3. Abrí el repositorio **DinoGoogle** en Iceberg y hacé **Checkout** de la rama `moneda-test`.
4. Abrí la lista de paquetes del repositorio y cargá el paquete **DinoGoogle** con **Load**. El código está en `src/DinoGoogle` en formato Tonel. Pharo compila los métodos al cargar el paquete.

## Cargar el código desde el ZIP de entrega

Descomprimí el ZIP y localizá la carpeta `src` del proyecto, que contiene el paquete `DinoGoogle`. En el Playground de Pharo 12, pegá este bloque, reemplazá la ruta de ejemplo por la ruta absoluta a esa carpeta, seleccioná todo y ejecutá con **Do it** (`Ctrl+D` en Windows).

```smalltalk
| lector |
lector := TonelReader
    on: 'C:/ruta/DinoGoogle/src' asFileReference
    fileName: 'DinoGoogle'.
MCPackageLoader new
    updatePackage: (MCPackage named: 'DinoGoogle')
    withSnapshot: lector snapshot;
    load.
```

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
