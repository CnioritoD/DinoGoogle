Class {
	#name : 'BotonRetro',
	#superclass : 'SimpleButtonMorph',
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'dibujo' }
BotonRetro >> drawOn: canvas [

	| presionado area |
	presionado := oldColor notNil and: [ self fillStyle ~= oldColor ].
	EstiloRetro marco: self bounds fondo: EstiloRetro relieve hundido: presionado en: canvas.
	area := presionado
		ifTrue: [ self bounds translateBy: 1 @ 1 ]
		ifFalse: [ self bounds ].
	EstiloRetro texto: self label centradoEn: area escala: 2 color: EstiloRetro tinta en: canvas
]

{ #category : 'inicializacion' }
BotonRetro >> label: unTexto font: unaFuente [

	super label: unTexto font: unaFuente.
	label hide
]
