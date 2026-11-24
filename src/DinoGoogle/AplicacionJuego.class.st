"Ventana principal de DinoGoogle. Crea el coordinador y prepara los recursos gráficos que comparten los paneles. Para abrir el juego, evaluá AplicacionJuego new abrir."
Class {
	#name : 'AplicacionJuego',
	#superclass : 'SystemWindow',
	#instVars : [
		'coordinador',
		'estilo'
	],
	#classVars : [
		'Glifos'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'paleta' }
AplicacionJuego class >> estilo [

	| recursos |
	recursos := Dictionary new.
	recursos
		at: #tinta put: self tinta;
		at: #metal put: self metal;
		at: #relieve put: self relieve;
		at: #sombra put: self sombra;
		at: #pantalla put: self pantalla;
		at: #luz put: self luz;
		at: #marco put: (self pintorDeMarcosCon: recursos);
		at: #texto put: self pintorDeTexto.
	^ recursos
]

{ #category : 'drawing' }
AplicacionJuego class >> glifos [
	"Cada entero codifica los cinco píxeles de una fila, del bit 5 al bit 1."

	^ Glifos ifNil: [
		Glifos := Dictionary new.
		'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+' with: #(
			(14 17 17 31 17 17 17) (30 17 17 30 17 17 30)
			(15 16 16 16 16 16 15) (30 17 17 17 17 17 30)
			(31 16 16 30 16 16 31) (31 16 16 30 16 16 16)
			(15 16 16 23 17 17 15) (17 17 17 31 17 17 17)
			(31 4 4 4 4 4 31) (7 2 2 2 2 18 12)
			(17 18 20 24 20 18 17) (16 16 16 16 16 16 31)
			(17 27 21 21 17 17 17) (17 25 21 19 17 17 17)
			(14 17 17 17 17 17 14) (30 17 17 30 16 16 16)
			(14 17 17 17 21 18 13) (30 17 17 30 20 18 17)
			(15 16 16 14 1 1 30) (31 4 4 4 4 4 4)
			(17 17 17 17 17 17 14) (17 17 17 17 17 10 4)
			(17 17 17 21 21 27 17) (17 17 10 4 10 17 17)
			(17 17 10 4 4 4 4) (31 1 2 4 8 16 31)
			(14 17 19 21 25 17 14) (4 12 4 4 4 4 14)
			(14 17 1 2 4 8 31) (30 1 1 14 1 1 30)
			(2 6 10 18 31 2 2) (31 16 16 30 1 1 30)
			(14 16 16 30 17 17 14) (31 1 2 4 8 8 8)
			(14 17 17 14 17 17 14) (14 17 17 15 1 1 14)
			(0 4 4 31 4 4 0))
			do: [ :letra :filas | Glifos at: letra put: filas ].
		Glifos ]
]

{ #category : 'paleta' }
AplicacionJuego class >> luz [

	^ Color gray: 0.96
]

{ #category : 'paleta' }
AplicacionJuego class >> metal [

	^ Color gray: 0.68
]

{ #category : 'paleta' }
AplicacionJuego class >> pantalla [

	^ Color r: 0.23 g: 0.24 b: 0.25
]

{ #category : 'drawing' }
AplicacionJuego class >> pintorDeMarcosCon: unaPaleta [

	| sombra luz relieve tinta |
	sombra := unaPaleta at: #sombra.
	luz := unaPaleta at: #luz.
	relieve := unaPaleta at: #relieve.
	tinta := unaPaleta at: #tinta.
	^ [ :unRectangulo :unColor :hundido :canvas |
		| interior arriba abajo |
		arriba := hundido ifTrue: [ sombra ] ifFalse: [ luz ].
		abajo := hundido ifTrue: [ relieve ] ifFalse: [ sombra ].
		interior := unRectangulo insetBy: 3.
		canvas fillRectangle: unRectangulo color: tinta.
		canvas fillRectangle: interior color: abajo.
		canvas fillRectangle: (interior origin extent: interior width @ 4) color: arriba.
		canvas fillRectangle: (interior origin extent: 4 @ interior height) color: arriba.
		canvas fillRectangle: (interior insetBy: 4) color: unColor ]
]

{ #category : 'drawing' }
AplicacionJuego class >> pintorDeTexto [

	| glifos |
	glifos := self glifos.
	^ [ :texto :unRectangulo :escala :unColor :canvas |
		| medida origen |
		medida := ((texto size * 6 - 1) * escala) @ (7 * escala).
		origen := unRectangulo origin + ((unRectangulo extent - medida) // 2).
		texto doWithIndex: [ :letra :columna |
			| filas |
			filas := glifos at: letra ifAbsent: [ #(0 0 0 0 0 0 0) ].
			filas doWithIndex: [ :fila :y |
				1 to: 5 do: [ :x |
					(fila bitAt: 6 - x) = 1 ifTrue: [
						canvas fillRectangle: ((origen + ((((columna - 1) * 6 + x - 1) * escala)
							@ ((y - 1) * escala))) extent: escala @ escala) color: unColor ] ] ] ] ]
]

{ #category : 'paleta' }
AplicacionJuego class >> relieve [

	^ Color gray: 0.83
]

{ #category : 'paleta' }
AplicacionJuego class >> sombra [

	^ Color gray: 0.43
]

{ #category : 'paleta' }
AplicacionJuego class >> tinta [

	^ Color r: 0.09 g: 0.09 b: 0.13
]

{ #category : 'open/close' }
AplicacionJuego >> abrir [

	self world ifNil: [
		coordinador prepararSiguientePartida.
		self openInWorld ].
	^ self
]

{ #category : 'ventana' }
AplicacionJuego >> activeTitleFillStyle [

	^ Color transparent
]

{ #category : 'open/close' }
AplicacionJuego >> cerrar [

	^ self delete
]

{ #category : 'initialization' }
AplicacionJuego >> construirInterfaz [

	| contenedor tablero mitad marcoCentrado |
	contenedor := Morph new
		color: Color transparent;
		layoutPolicy: ProportionalLayout new;
		yourself.
	tablero := Morph new color: Color transparent; extent: 656 @ 360; yourself.
	coordinador montarInterfazEn: tablero.
	mitad := tablero extent // 2.
	marcoCentrado := LayoutFrame new
		leftFraction: 0.5 offset: mitad x negated;
		rightFraction: 0.5 offset: mitad x;
		topFraction: 0.5 offset: mitad y negated;
		bottomFraction: 0.5 offset: mitad y;
		yourself.
	contenedor addMorph: tablero fullFrame: marcoCentrado.
	self addMorph: contenedor frame: (0 @ 0 corner: 1 @ 1).
	self minimumExtent: 680 @ 401.
	self extent: 680 @ 401
]

{ #category : 'open/close' }
AplicacionJuego >> delete [

	coordinador ifNotNil: [ coordinador cerrar ].
	^ super delete
]

{ #category : 'drawing' }
AplicacionJuego >> drawOn: canvas [

	| titulo |
	estilo ifNil: [ ^ super drawOn: canvas ].
	(estilo at: #marco) value: self bounds value: (estilo at: #metal) value: false value: canvas.
	titulo := (self position + (0 @ 3)) extent: self width @ self labelHeight.
	(estilo at: #texto) valueWithArguments: {
		self labelString. titulo. 2. (estilo at: #tinta). canvas }
]

{ #category : 'ventana' }
AplicacionJuego >> inactiveTitleFillStyle [

	^ self activeTitleFillStyle
]

{ #category : 'initialization' }
AplicacionJuego >> initialize [

	super initialize.
	self setLabel: 'DINO GOOGLE'.
	coordinador := CoordinadorPartida new.
	estilo := self class estilo.
	coordinador configurarEstilo: estilo.
	self construirInterfaz
]

{ #category : 'ventana' }
AplicacionJuego >> initializeLabelArea [

	super initializeLabelArea.
	self basicLabel hide
]

{ #category : 'ventana' }
AplicacionJuego >> labelHeight [

	^ super labelHeight max: 30
]

{ #category : 'ventana' }
AplicacionJuego >> preferredCornerStyle [

	^ #square
]

{ #category : 'ventana' }
AplicacionJuego >> wantsRoundedCorners [

	^ false
]
