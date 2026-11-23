Class {
	#name : 'EntradaControles',
	#superclass : 'Morph',
	#instVars : [
		'sistema',
		'panel',
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
EntradaControles >> configurarSistema: unSistema panel: unPanel [

	sistema := unSistema.
	panel := unPanel.
	estado := #enEspera.
	self color: Color transparent.
	self extent: panel extent.
	self addMorph: panel.
	panel position: self position
]

{ #category : 'inicializacion' }
EntradaControles >> configurarEstilo: unEstilo [

	estilo := unEstilo.
	botonInicio ifNotNil: [ botonInicio delete. cuadroFinal delete ].
	self construirComponentes
]

{ #category : 'interfaz' }
EntradaControles >> mostrarEstado: unEstado [

	estado = unEstado ifTrue: [ ^ self ].
	estado := unEstado.
	self actualizarComponentes
]

{ #category : 'inicializacion' }
EntradaControles >> boton: texto selector: selector en: posicionLocal tamanio: medida [

	| boton lienzo rotulo |
	boton := SimpleButtonMorph new
		label: texto;
		extent: medida;
		position: self position + posicionLocal;
		color: (estilo at: #relieve);
		borderStyle: (BorderStyle raised width: 4; color: (estilo at: #metal); yourself);
		target: sistema;
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
EntradaControles >> construirComponentes [

	botonInicio := self boton: 'JUGAR' selector: #solicitarInicio
		en: 219 @ 91 tamanio: 202 @ 42.
	self addMorph: botonInicio.

	cuadroFinal := Morph new
		color: Color transparent;
		bounds: panel limitesCuadroFinal;
		yourself.
	self addMorph: cuadroFinal.

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
EntradaControles >> nick [

	^ campoNick text asString trimBoth
]

{ #category : 'interfaz' }
EntradaControles >> actualizarComponentes [

	botonInicio ifNil: [ ^ self ].
	self visible: estado ~= #enCurso.
	botonInicio visible: estado = #enEspera.
	cuadroFinal visible: estado = #finalizada.
	estado = #finalizada ifTrue: [
		campoNick setText: ''.
		self world ifNotNil: [ campoNick textArea takeKeyboardFocus ] ]
]

{ #category : 'interfaz' }
EntradaControles >> montarEn: unContenedor posicion: unaPosicion [

	unContenedor addMorph: self.
	self position: unaPosicion
]
