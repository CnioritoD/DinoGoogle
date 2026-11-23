Class {
	#name : 'PanelControles',
	#superclass : 'Morph',
	#instVars : [
		'estilo',
		'estado',
		'resultados',
		'fuenteTabla',
		'puntaje'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}


{ #category : 'dibujo' }
PanelControles >> dibujarFinalEn: canvas [

	| origen titulo marcador entrada |
	origen := self limitesCuadroFinal origin.
	canvas fillRectangle: self bounds color: (estilo at: #pantalla).
	self dibujarMarco: self limitesCuadroFinal fondo: (estilo at: #metal) hundido: false en: canvas.
	titulo := (origen + (30 @ 22)) extent: 506 @ 54.
	self dibujarMarco: titulo fondo: (estilo at: #relieve) hundido: false en: canvas.
	self dibujarTexto: 'PARTIDA TERMINADA' centradoEn: titulo escala: 4 color: (estilo at: #tinta) en: canvas.

	marcador := (origen + (153 @ 89)) extent: 260 @ 42.
	self dibujarMarco: marcador fondo: (estilo at: #pantalla) hundido: true en: canvas.
	self dibujarTexto: 'PUNTOS ', puntaje printString centradoEn: marcador escala: 2
		color: (estilo at: #luz) en: canvas.
	self dibujarTexto: 'APODO OPCIONAL' centradoEn: ((origen + (153 @ 137)) extent: 260 @ 20)
		escala: 2 color: (estilo at: #tinta) en: canvas.
	entrada := (origen + (153 @ 159)) extent: 260 @ 38.
	self dibujarMarco: entrada fondo: (estilo at: #pantalla) hundido: true en: canvas
]

{ #category : 'dibujo' }
PanelControles >> dibujarInicioEn: canvas [

	| origen titulo |
	origen := self position.
	self dibujarMarco: self bounds fondo: (estilo at: #metal) hundido: false en: canvas.
	titulo := (origen + (28 @ 22)) extent: 584 @ 55.
	self dibujarMarco: titulo fondo: (estilo at: #relieve) hundido: false en: canvas.
	self dibujarTexto: 'DINO GOOGLE' centradoEn: titulo escala: 5 color: (estilo at: #tinta) en: canvas.
	self dibujarTexto: 'MEJORES PARTIDAS' centradoEn: ((origen + (52 @ 143)) extent: 536 @ 22)
		escala: 2 color: (estilo at: #tinta) en: canvas.
	self dibujarTablaEn: canvas.
	self dibujarTexto: 'ESPACIO O CLIC PARA SALTAR   ABAJO PARA AGACHARSE'
		centradoEn: ((origen + (20 @ 307)) extent: 600 @ 24) escala: 2
		color: (estilo at: #tinta) en: canvas
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
				at: origen + ((x + izquierda) @ 2) font: fuenteTabla color: (estilo at: #tinta) ] ]
]

{ #category : 'dibujo' }
PanelControles >> dibujarTablaEn: canvas [

	| origen columnas encabezados |
	origen := self position + (59 @ 177).
	columnas := #(0 44 229 377 522).
	encabezados := #('N' 'APODO' 'TIEMPO' 'PUNTOS').
	self dibujarMarco: ((origen - (7 @ 7)) extent: 536 @ 140)
		fondo: (estilo at: #relieve) hundido: true en: canvas.
	canvas fillRectangle: (origen extent: 522 @ 20) color: (estilo at: #pantalla).
	encabezados doWithIndex: [ :texto :indice |
		| inicio ancho |
		inicio := columnas at: indice.
		ancho := (columnas at: indice + 1) - inicio.
		self dibujarTexto: texto centradoEn: ((origen + (inicio @ 0)) extent: ancho @ 20)
			escala: 2 color: (estilo at: #luz) en: canvas ].
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
		self dibujarTexto: 'SIN RESULTADOS' centradoEn: ((origen + (0 @ 21)) extent: 522 @ 105)
			escala: 2 color: (estilo at: #tinta) en: canvas ]
]

{ #category : 'dibujo' }
PanelControles >> drawOn: canvas [

	estilo ifNil: [ ^ self ].
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

	(estado = unEstado and: [ puntaje = unPuntaje ]) ifTrue: [ ^ self ].
	estado := unEstado.
	puntaje := unPuntaje.
	self changed
]

{ #category : 'interfaz' }
PanelControles >> mostrarResultados: unaColeccion [

	resultados := unaColeccion.
	estado = #enEspera ifTrue: [ self changed ]
]

{ #category : 'inicializacion' }
PanelControles >> configurarEstilo: unEstilo [

	estilo := unEstilo.
	self changed
]

{ #category : 'dibujo' }
PanelControles >> dibujarMarco: unRectangulo fondo: unColor hundido: hundido en: canvas [

	(estilo at: #marco) value: unRectangulo value: unColor value: hundido value: canvas
]

{ #category : 'dibujo' }
PanelControles >> dibujarTexto: unTexto centradoEn: unRectangulo escala: escala color: unColor en: canvas [

	(estilo at: #texto) valueWithArguments: { unTexto. unRectangulo. escala. unColor. canvas }
]

{ #category : 'dibujo' }
PanelControles >> limitesCuadroFinal [

	^ self limitesCuadroFinalLocales translateBy: self position
]

{ #category : 'dibujo' }
PanelControles >> limitesCuadroFinalLocales [

	^ (37 @ 30) extent: 566 @ 282
]
