Class {
	#name : 'PanelControles',
	#superclass : 'Morph',
	#instVars : [
		'sistema',
		'botonInicio',
		'cuadroFinal',
		'campoNick',
		'estado',
		'resultados',
		'fuenteTabla'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'inicializacion' }
PanelControles >> boton: texto selector: selector en: posicionLocal tamanio: medida [

	| boton |
	boton := SimpleButtonMorph new
		label: texto font: (LogicalFont familyName: 'Source Sans Pro' pointSize: 16);
		extent: medida;
		position: self position + posicionLocal;
		color: Color white;
		borderWidth: 1;
		borderColor: Color black;
		useRoundedCorners;
		target: sistema;
		actionSelector: selector;
		yourself.
	boton submorphs first color: Color black.
	^ boton
]

{ #category : 'privado' }
PanelControles >> conectarAcciones [
    botonInicio
        target: sistema;
        actionSelector: #solicitarInicio.
    botonReinicio
        target: sistema;
        actionSelector: #solicitarReinicio
]

{ #category : 'inicializacion' }
PanelControles >> configurarSistema: unSistema [

	sistema := unSistema.
	self construirComponentes
]

{ #category : 'inicializacion' }
PanelControles >> construirComponentes [

	| titulo etiqueta |
	botonInicio := self boton: 'Ready' selector: #solicitarInicio
		en: 226 @ 37 tamanio: 188 @ 46.
	self addMorph: botonInicio.

	cuadroFinal := BorderedMorph new
		extent: 340 @ 244;
		color: (Color gray: 0.52);
		borderWidth: 0;
		useRoundedCorners;
		yourself.
	self addMorph: cuadroFinal.
	cuadroFinal position: self position + (150 @ 50).

	titulo := StringMorph contents: 'GAME OVER'.
	titulo font: (LogicalFont familyName: 'Source Sans Pro' pointSize: 28).
	titulo color: (Color r: 0.84 g: 0.04 b: 0.06).
	cuadroFinal addMorph: titulo.
	titulo position: cuadroFinal position + (((340 - titulo width) // 2) @ 19).

	etiqueta := StringMorph contents: 'Nick name'.
	etiqueta font: (LogicalFont familyName: 'Source Sans Pro' pointSize: 16).
	etiqueta color: Color black.
	cuadroFinal addMorph: etiqueta.
	etiqueta position: cuadroFinal position + (49 @ 78).

	campoNick := RubTextFieldMorph new
		font: fuenteTabla;
		color: Color white;
		borderWidth: 2;
		borderColor: Color black;
		maxLength: 20;
		extent: 242 @ 40;
		yourself.
	campoNick textArea textColor: Color black.
	cuadroFinal addMorph: campoNick.
	campoNick position: cuadroFinal position + (49 @ 105).

	cuadroFinal addMorph: (self boton: 'Restart' selector: #solicitarReinicio
		en: 182 @ 234 tamanio: 126 @ 39).
	cuadroFinal addMorph: (self boton: 'Exit' selector: #solicitarSalida
		en: 332 @ 234 tamanio: 126 @ 39).
	cuadroFinal hide
]

{ #category : 'dibujo' }
PanelControles >> dibujarFila: valores en: origen columnas: columnas sobre: canvas [

	valores doWithIndex: [ :texto :indice |
		| x ancho izquierda celda |
		x := columnas at: indice.
		ancho := (columnas at: indice + 1) - x.
		celda := (origen + ((x + 3) @ 0)) extent: (ancho - 6) @ 30.
		izquierda := ((ancho - (fuenteTabla widthOfString: texto)) // 2) max: 4.
		canvas clipBy: celda during: [ :lienzo |
			lienzo drawString: texto from: 1 to: texto size
				at: origen + ((x + izquierda) @ 6) font: fuenteTabla color: Color black ] ]
]

{ #category : 'dibujo' }
PanelControles >> dibujarTablaEn: canvas [

	| origen columnas encabezados |
	origen := self position + (52 @ 112).
	columnas := #(0 38 202 365 536).
	encabezados := #('N°' 'Nick Name' 'Time' 'Score').
	canvas fillRectangle: (origen extent: 536 @ 186) color: Color white.
	2 to: 4 do: [ :indice |
		canvas fillRectangle: ((origen + ((columnas at: indice) @ 0)) extent: 2 @ 186)
			color: (Color gray: 0.52) ].
	1 to: 5 do: [ :fila |
		canvas fillRectangle: ((origen + (0 @ (fila * 31))) extent: 536 @ 1)
			color: (Color gray: 0.52) ].
	self dibujarFila: encabezados en: origen columnas: columnas sobre: canvas.
	resultados doWithIndex: [ :resultado :indice |
		self
			dibujarFila: { indice printString. resultado first.
				(resultado second printShowingDecimalPlaces: 2), ' s'. resultado third printString }
			en: origen + (0 @ (indice * 31))
			columnas: columnas
			sobre: canvas ]
]

{ #category : 'dibujo' }
PanelControles >> drawOn: canvas [

	estado = #enEspera ifFalse: [ ^ self ].
	canvas fillRectangle: self bounds color: (Color gray: 0.52).
	self dibujarTablaEn: canvas
]

{ #category : 'inicializacion' }
PanelControles >> initialize [

	super initialize.
	self extent: 640 @ 344.
	self color: Color transparent.
	estado := #enEspera.
	resultados := #().
	fuenteTabla := LogicalFont familyName: 'Source Sans Pro' pointSize: 13
]

{ #category : 'interfaz' }
PanelControles >> mostrarPuntaje: unPuntaje estado: unEstado [

	estado = unEstado ifTrue: [ ^ self ].
	estado := unEstado.
	botonInicio visible: estado = #enEspera.
	cuadroFinal visible: estado = #finalizada.
	estado = #finalizada ifTrue: [
		campoNick setText: ''.
		self world ifNotNil: [ campoNick textArea takeKeyboardFocus ] ].
	self changed
]

{ #category : 'interfaz' }
PanelControles >> mostrarResultados: unaColeccion [

	resultados := unaColeccion.
	estado = #enEspera ifTrue: [ self changed ]
]

{ #category : 'interfaz' }
PanelControles >> nick [

	^ campoNick text asString trimBoth
]
