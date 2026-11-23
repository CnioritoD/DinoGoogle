Class {
	#name : 'VistaJuego',
	#superclass : 'SystemWindow',
	#instVars : [
		'coordinador'
	],
	#classVars : [
		'Glifos'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'ventana' }
VistaJuego >> abrir [

	self world ifNil: [ self openInWorld ].
	^ self
]

{ #category : 'inicializacion' }
VistaJuego >> construirInterfaz [

	| contenedor |
	contenedor := Morph new color: self class pantalla; yourself.
	coordinador montarInterfazEn: contenedor.
	self addMorph: contenedor frame: (0 @ 0 corner: 1 @ 1).
	self minimumExtent: 680 @ 401.
	self extent: 680 @ 401
]

{ #category : 'ventana' }
VistaJuego >> delete [

	coordinador ifNotNil: [ coordinador cerrar ].
	^ super delete
]

{ #category : 'inicializacion' }
VistaJuego >> initialize [

	super initialize.
	self setLabel: 'DINO GOOGLE'.
	coordinador := CoordinadorPartida new.
	coordinador configurarEstilo: self class estilo.
	coordinador alSalir: [ self delete ].
	self construirInterfaz
]

{ #category : 'paleta' }
VistaJuego class >> tinta [

	^ Color r: 0.09 g: 0.09 b: 0.13
]

{ #category : 'paleta' }
VistaJuego class >> metal [

	^ Color gray: 0.68
]

{ #category : 'paleta' }
VistaJuego class >> relieve [

	^ Color gray: 0.83
]

{ #category : 'paleta' }
VistaJuego class >> sombra [

	^ Color gray: 0.43
]

{ #category : 'paleta' }
VistaJuego class >> pantalla [

	^ Color r: 0.23 g: 0.24 b: 0.25
]

{ #category : 'paleta' }
VistaJuego class >> luz [

	^ Color gray: 0.96
]

{ #category : 'dibujo' }
VistaJuego class >> pintorDeMarcosCon: unaPaleta [

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

{ #category : 'dibujo' }
VistaJuego class >> pintorDeTexto [

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

{ #category : 'dibujo' }
VistaJuego class >> glifos [
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
VistaJuego class >> estilo [

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
