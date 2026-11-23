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
		'fuenteTabla',
		'puntaje'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}


{ #category : 'inicializacion' }
PanelControles >> boton: texto selector: selector en: posicionLocal tamanio: medida [

	| boton lienzo rotulo |
	boton := SimpleButtonMorph new
		label: texto;
		extent: medida;
		position: self position + posicionLocal;
		color: VistaJuego relieve;
		borderStyle: (BorderStyle raised width: 4; color: VistaJuego metal; yourself);
		target: sistema;
		actionSelector: selector;
		yourself.
	boton submorphs first hide.
	lienzo := FormCanvas extent: (((texto size * 6) - 1) * 2) @ 14.
	VistaJuego texto: texto centradoEn: lienzo form boundingBox escala: 2
		color: VistaJuego tinta en: lienzo.
	rotulo := ImageMorph withForm: lienzo form.
	rotulo position: boton center - (rotulo extent // 2).
	boton addMorph: rotulo.
	rotulo lock.
	^ boton
]

{ #category : 'inicializacion' }
PanelControles >> configurarSistema: unSistema [

	sistema := unSistema.
	self construirComponentes
]

{ #category : 'inicializacion' }
PanelControles >> construirComponentes [

	botonInicio := self boton: 'JUGAR' selector: #solicitarInicio
		en: 219 @ 91 tamanio: 202 @ 42.
	self addMorph: botonInicio.

	cuadroFinal := Morph new
		color: Color transparent;
		extent: 566 @ 282;
		yourself.
	self addMorph: cuadroFinal.
	cuadroFinal position: self position + (37 @ 30).

	campoNick := RubTextFieldMorph new
		font: fuenteTabla;
		color: VistaJuego pantalla;
		borderWidth: 0;
		maxLength: 20;
		extent: 246 @ 24;
		yourself.
	campoNick textArea textColor: VistaJuego luz.
	cuadroFinal addMorph: campoNick.
	campoNick position: cuadroFinal position + (160 @ 166).

	cuadroFinal addMorph: (self boton: 'REINICIAR' selector: #solicitarReinicio
		en: 57 @ 254 tamanio: 170 @ 43).
	cuadroFinal addMorph: (self boton: 'SALIR' selector: #solicitarSalida
		en: 413 @ 254 tamanio: 170 @ 43).
	cuadroFinal hide
]

{ #category : 'dibujo' }
PanelControles >> dibujarFinalEn: canvas [

	| origen titulo marcador entrada |
	origen := cuadroFinal position.
	canvas fillRectangle: self bounds color: VistaJuego pantalla.
	VistaJuego marco: cuadroFinal bounds fondo: VistaJuego metal hundido: false en: canvas.
	titulo := (origen + (30 @ 22)) extent: 506 @ 54.
	VistaJuego marco: titulo fondo: VistaJuego relieve hundido: false en: canvas.
	VistaJuego texto: 'PARTIDA TERMINADA' centradoEn: titulo escala: 4 color: VistaJuego tinta en: canvas.

	marcador := (origen + (153 @ 89)) extent: 260 @ 42.
	VistaJuego marco: marcador fondo: VistaJuego pantalla hundido: true en: canvas.
	VistaJuego texto: 'PUNTOS ', puntaje printString centradoEn: marcador escala: 2
		color: VistaJuego luz en: canvas.
	VistaJuego texto: 'APODO OPCIONAL' centradoEn: ((origen + (153 @ 137)) extent: 260 @ 20)
		escala: 2 color: VistaJuego tinta en: canvas.
	entrada := (origen + (153 @ 159)) extent: 260 @ 38.
	VistaJuego marco: entrada fondo: VistaJuego pantalla hundido: true en: canvas
]

{ #category : 'dibujo' }
PanelControles >> dibujarInicioEn: canvas [

	| origen titulo |
	origen := self position.
	VistaJuego marco: self bounds fondo: VistaJuego metal hundido: false en: canvas.
	titulo := (origen + (28 @ 22)) extent: 584 @ 55.
	VistaJuego marco: titulo fondo: VistaJuego relieve hundido: false en: canvas.
	VistaJuego texto: 'DINO GOOGLE' centradoEn: titulo escala: 5 color: VistaJuego tinta en: canvas.
	VistaJuego texto: 'MEJORES PARTIDAS' centradoEn: ((origen + (52 @ 143)) extent: 536 @ 22)
		escala: 2 color: VistaJuego tinta en: canvas.
	self dibujarTablaEn: canvas.
	VistaJuego texto: 'ESPACIO O CLIC PARA SALTAR   ABAJO PARA AGACHARSE'
		centradoEn: ((origen + (20 @ 307)) extent: 600 @ 24) escala: 2
		color: VistaJuego tinta en: canvas
]

{ #category : 'dibujo' }
PanelControles >> dibujarFila: valores en: origen columnas: columnas sobre: canvas [

	valores doWithIndex: [ :texto :indice |
		| x ancho izquierda celda |
		x := columnas at: indice.
		ancho := (columnas at: indice + 1) - x.
		celda := (origen + ((x + 4) @ 0)) extent: (ancho - 8) @ 20.
		izquierda := ((ancho - (fuenteTabla widthOfString: texto)) // 2) max: 4.
		canvas clipBy: celda during: [ :lienzo |
			lienzo drawString: texto from: 1 to: texto size
				at: origen + ((x + izquierda) @ 2) font: fuenteTabla color: VistaJuego tinta ] ]
]

{ #category : 'dibujo' }
PanelControles >> dibujarTablaEn: canvas [

	| origen columnas encabezados |
	origen := self position + (59 @ 177).
	columnas := #(0 44 229 377 522).
	encabezados := #('N' 'APODO' 'TIEMPO' 'PUNTOS').
	VistaJuego marco: ((origen - (7 @ 7)) extent: 536 @ 140)
		fondo: VistaJuego relieve hundido: true en: canvas.
	canvas fillRectangle: (origen extent: 522 @ 20) color: VistaJuego pantalla.
	encabezados doWithIndex: [ :texto :indice |
		| inicio ancho |
		inicio := columnas at: indice.
		ancho := (columnas at: indice + 1) - inicio.
		VistaJuego texto: texto centradoEn: ((origen + (inicio @ 0)) extent: ancho @ 20)
			escala: 2 color: VistaJuego luz en: canvas ].
	1 to: 5 do: [ :fila |
		canvas fillRectangle: ((origen + (0 @ (fila * 21))) extent: 522 @ 20)
			color: (Color gray: (fila odd ifTrue: [ 0.9 ] ifFalse: [ 0.79 ])) ].
	resultados doWithIndex: [ :resultado :indice |
		self
			dibujarFila: { indice printString. (resultado first = 'Guest'
				ifTrue: [ 'Invitado' ] ifFalse: [ resultado first ]).
				(resultado second printShowingDecimalPlaces: 2), ' s'. resultado third printString }
			en: origen + (0 @ (indice * 21))
			columnas: columnas
			sobre: canvas ].
	resultados isEmpty ifTrue: [
		VistaJuego texto: 'SIN RESULTADOS' centradoEn: ((origen + (0 @ 21)) extent: 522 @ 105)
			escala: 2 color: VistaJuego tinta en: canvas ]
]

{ #category : 'dibujo' }
PanelControles >> drawOn: canvas [

	estado = #enEspera ifTrue: [ self dibujarInicioEn: canvas ].
	estado = #finalizada ifTrue: [ self dibujarFinalEn: canvas ]
]

{ #category : 'inicializacion' }
PanelControles >> initialize [

	super initialize.
	self extent: 640 @ 344.
	self color: Color transparent.
	estado := #enEspera.
	puntaje := 0.
	resultados := #().
	fuenteTabla := LogicalFont familyName: 'Source Code Pro' pointSize: 13
]

{ #category : 'interfaz' }
PanelControles >> mostrarPuntaje: unPuntaje estado: unEstado [

	estado = unEstado ifTrue: [ ^ self ].
	estado := unEstado.
	puntaje := unPuntaje.
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
