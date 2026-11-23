Class {
	#name : 'SistemaControles',
	#superclass : 'Object',
	#instVars : [
		'coordinador',
		'panel',
		'contenedor',
		'estilo',
		'estado',
		'botonInicio',
		'cuadroFinal',
		'campoNick'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'inicializacion' }
SistemaControles >> configurarCoordinador: unCoordinador panel: unPanel [

	coordinador := unCoordinador.
	panel := unPanel.
	estado := #enEspera.
	contenedor := Morph new color: Color transparent; extent: panel extent; yourself.
	contenedor addMorph: panel.
	panel position: contenedor position
]

{ #category : 'interfaz' }
SistemaControles >> montarEn: unContenedor posicion: unaPosicion [

	unContenedor addMorph: contenedor.
	contenedor position: unaPosicion
]

{ #category : 'interfaz' }
SistemaControles >> mostrarPuntaje: unPuntaje estado: unEstado [

	panel mostrarPuntaje: unPuntaje estado: unEstado.
	estado = unEstado ifTrue: [ ^ self ].
	estado := unEstado.
	self actualizarComponentes
]

{ #category : 'interfaz' }
SistemaControles >> mostrarResultados: unaColeccion [

	panel mostrarResultados: unaColeccion
]

{ #category : 'interfaz' }
SistemaControles >> panel [

	^ panel
]

{ #category : 'acciones' }
SistemaControles >> solicitarInicio [

	coordinador iniciarPartida
]

{ #category : 'acciones' }
SistemaControles >> solicitarReinicio [

	coordinador guardarResultado: self nick.
	coordinador prepararSiguientePartida
]

{ #category : 'acciones' }
SistemaControles >> solicitarSalida [

	coordinador guardarResultado: self nick.
	coordinador salir
]

{ #category : 'inicializacion' }
SistemaControles >> configurarEstilo: unEstilo [

	estilo := unEstilo.
	panel configurarEstilo: unEstilo.
	botonInicio ifNotNil: [ botonInicio delete. cuadroFinal delete ].
	self construirComponentes
]

{ #category : 'inicializacion' }
SistemaControles >> boton: texto selector: selector en: posicionLocal tamanio: medida [

	| boton lienzo rotulo |
	boton := SimpleButtonMorph new
		label: texto;
		extent: medida;
		position: contenedor position + posicionLocal;
		color: (estilo at: #relieve);
		borderStyle: (BorderStyle raised width: 4; color: (estilo at: #metal); yourself);
		target: self;
		actionSelector: selector;
		yourself.
	boton submorphs first hide.
	lienzo := FormCanvas extent: (((texto size * 6) - 1) * 2) @ 14.
	(estilo at: #texto) valueWithArguments: { texto. lienzo form boundingBox. 2. (estilo at: #tinta). lienzo }.
	rotulo := ImageMorph withForm: lienzo form.
	rotulo position: boton center - (rotulo extent // 2).
	boton addMorph: rotulo.
	rotulo lock.
	^ boton
]

{ #category : 'inicializacion' }
SistemaControles >> construirComponentes [

	botonInicio := self boton: 'JUGAR' selector: #solicitarInicio
		en: 219 @ 91 tamanio: 202 @ 42.
	contenedor addMorph: botonInicio.

	cuadroFinal := Morph new
		color: Color transparent;
		bounds: panel limitesCuadroFinal;
		yourself.
	contenedor addMorph: cuadroFinal.

	campoNick := RubTextFieldMorph new
		font: (LogicalFont familyName: 'Source Code Pro' pointSize: 13);
		color: (estilo at: #pantalla);
		borderWidth: 0;
		maxLength: 20;
		extent: 246 @ 24;
		yourself.
	campoNick textArea textColor: (estilo at: #luz).
	cuadroFinal addMorph: campoNick.
	campoNick position: cuadroFinal position + (160 @ 166).

	cuadroFinal addMorph: (self boton: 'REINICIAR' selector: #solicitarReinicio
		en: 57 @ 254 tamanio: 170 @ 43).
	cuadroFinal addMorph: (self boton: 'SALIR' selector: #solicitarSalida
		en: 413 @ 254 tamanio: 170 @ 43).
	self actualizarComponentes
]

{ #category : 'acciones' }
SistemaControles >> nick [

	^ campoNick text asString trimBoth
]

{ #category : 'interfaz' }
SistemaControles >> actualizarComponentes [

	botonInicio ifNil: [ ^ self ].
	contenedor visible: estado ~= #enCurso.
	botonInicio visible: estado = #enEspera.
	cuadroFinal visible: estado = #finalizada.
	estado = #finalizada ifTrue: [
		campoNick setText: ''.
		contenedor world ifNotNil: [ campoNick textArea takeKeyboardFocus ] ]
]
