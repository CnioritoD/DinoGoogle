Class {
	#name : 'EstiloRetro',
	#superclass : 'Object',
	#classVars : [
		'Glifos'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'paleta' }
EstiloRetro class >> tinta [

	^ Color r: 0.09 g: 0.09 b: 0.13
]

{ #category : 'paleta' }
EstiloRetro class >> metal [

	^ Color gray: 0.68
]

{ #category : 'paleta' }
EstiloRetro class >> relieve [

	^ Color gray: 0.83
]

{ #category : 'paleta' }
EstiloRetro class >> sombra [

	^ Color gray: 0.43
]

{ #category : 'paleta' }
EstiloRetro class >> pantalla [

	^ Color r: 0.23 g: 0.24 b: 0.25
]

{ #category : 'paleta' }
EstiloRetro class >> luz [

	^ Color gray: 0.96
]

{ #category : 'dibujo' }
EstiloRetro class >> marco: unRectangulo fondo: unColor hundido: hundido en: canvas [

	| interior arriba abajo |
	arriba := hundido ifTrue: [ self sombra ] ifFalse: [ self luz ].
	abajo := hundido ifTrue: [ self relieve ] ifFalse: [ self sombra ].
	interior := unRectangulo insetBy: 3.
	canvas fillRectangle: unRectangulo color: self tinta.
	canvas fillRectangle: interior color: abajo.
	canvas fillRectangle: (interior origin extent: interior width @ 4) color: arriba.
	canvas fillRectangle: (interior origin extent: 4 @ interior height) color: arriba.
	canvas fillRectangle: (interior insetBy: 4) color: unColor
]

{ #category : 'dibujo' }
EstiloRetro class >> texto: texto centradoEn: unRectangulo escala: escala color: unColor en: canvas [

	| medida origen |
	medida := ((texto size * 6 - 1) * escala) @ (7 * escala).
	origen := unRectangulo origin + ((unRectangulo extent - medida) // 2).
	texto doWithIndex: [ :letra :columna |
		| filas |
		filas := self glifos at: letra ifAbsent: [ #(0 0 0 0 0 0 0) ].
		filas doWithIndex: [ :fila :y |
			1 to: 5 do: [ :x |
				(fila bitAt: 6 - x) = 1 ifTrue: [
					canvas fillRectangle: ((origen + ((((columna - 1) * 6 + x - 1) * escala)
						@ ((y - 1) * escala))) extent: escala @ escala) color: unColor ] ] ] ]
]

{ #category : 'dibujo' }
EstiloRetro class >> glifos [
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
