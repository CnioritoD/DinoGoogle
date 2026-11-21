"==============================================================
 JUEGO DINO - PARTE DE CONTROLES
 Clases: SistemaControles y PanelControles
 (Smalltalk / Morphic - Squeak o Pharo)
 Formato: 'Clase >> metodo' = crear el metodo en esa clase.
=============================================================="


"--------------------------------------------------------------
 1) DEFINICION DE CLASES
--------------------------------------------------------------"

Object subclass: #SistemaControles
    instanceVariableNames: 'coordinador panel'
    classVariableNames: ''
    package: 'Dino-Controles'.

Morph subclass: #PanelControles
    instanceVariableNames: 'sistema botonInicio botonReinicio textoPuntaje textoEstado'
    classVariableNames: ''
    package: 'Dino-Controles'.

"Nota: en Squeak, reemplazar 'package:' por 'category:'."


"--------------------------------------------------------------
 2) SistemaControles
    Intermediario entre el CoordinadorPartida y el PanelControles.
    No conoce Morphic: solo traduce eventos <-> solicitudes.
--------------------------------------------------------------"

SistemaControles >> configurarCoordinador: unCoordinador panel: unPanel
    "Conecta el sistema con el coordinador y con su panel."
    coordinador := unCoordinador.
    panel := unPanel.
    panel configurarSistema: self

SistemaControles >> solicitarInicio
    "Evento del panel: el usuario pidio iniciar la partida."
    coordinador iniciarPartida

SistemaControles >> solicitarReinicio
    "Evento del panel: el usuario pidio reiniciar la partida."
    coordinador reiniciarPartida

SistemaControles >> mostrarPuntaje: unPuntaje estado: unEstado
    "Llamado por el coordinador para refrescar lo que ve el usuario."
    panel mostrarPuntaje: unPuntaje estado: unEstado


"--------------------------------------------------------------
 3) PanelControles
    Parte visual: botones Iniciar / Reiniciar y textos de
    puntaje y estado.
--------------------------------------------------------------"

PanelControles >> initialize
    super initialize.
    self construirComponentes

PanelControles >> configurarSistema: unSistema
    "Recibe el sistema recien cuando ya existe, y recien ahi
     conecta los botones."
    sistema := unSistema.
    self conectarAcciones

PanelControles >> mostrarPuntaje: unPuntaje estado: unEstado
    | textos |
    textos := Dictionary new
        at: #esperando put: 'Presiona Iniciar';
        at: #enCurso put: 'Jugando...';
        at: #terminado put: 'Game Over';
        yourself.
    textoPuntaje contents: 'Puntaje: ', unPuntaje printString.
    textoEstado contents: (textos at: unEstado ifAbsent: [ unEstado asString ])

"----- metodos privados -----"

PanelControles >> construirComponentes
    self
        color: (Color gray: 0.9);
        borderWidth: 1;
        changeTableLayout;
        listDirection: #leftToRight;
        hResizing: #shrinkWrap;
        vResizing: #shrinkWrap;
        cellInset: 8;
        layoutInset: 8.

    botonInicio := SimpleButtonMorph new label: 'Iniciar'.
    botonReinicio := SimpleButtonMorph new label: 'Reiniciar'.
    textoPuntaje := StringMorph contents: 'Puntaje: 0'.
    textoEstado := StringMorph contents: 'Presiona Iniciar'.

    self
        addMorphBack: botonInicio;
        addMorphBack: botonReinicio;
        addMorphBack: textoPuntaje;
        addMorphBack: textoEstado

PanelControles >> conectarAcciones
    botonInicio
        target: sistema;
        actionSelector: #solicitarInicio.
    botonReinicio
        target: sistema;
        actionSelector: #solicitarReinicio


"--------------------------------------------------------------
 4) PRUEBA RAPIDA (Playground)
    Usa un coordinador falso para probar los controles solos,
    sin necesidad del resto del juego.
--------------------------------------------------------------"

"Object subclass: #CoordinadorFalso ... con iniciarPartida y
 reiniciarPartida que hagan 'Transcript show: ...'. Despues:

| panel sistema |
panel := PanelControles new.
sistema := SistemaControles new.
sistema configurarCoordinador: CoordinadorFalso new panel: panel.
panel openInWorld.
sistema mostrarPuntaje: 12 estado: #enCurso.
"
