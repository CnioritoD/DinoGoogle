Class {
	#name : 'Personaje',
	#superclass : 'Object',
	#instVars : [
		'posicion',
		'tamanio',
		'velocidadVertical',
		'gravedad',
		'impulsoSalto',
		'alturaSuelo'
	],
	#category : 'DinoGoogle-Modelo',
	#package : 'DinoGoogle',
	#tag : 'Modelo'
}

{ #category : 'privado' }
Personaje >> aterrizarSiCorresponde [

	self estaEnSuelo ifTrue: [
		posicion := posicion x @ (alturaSuelo - tamanio y).
		velocidadVertical := 0 ]
]

{ #category : 'movimiento' }
Personaje >> avanzar: segundos [

	self estaEnSuelo ifTrue: [ ^ self ].
	posicion := posicion + (0 @ ((velocidadVertical * segundos) + (gravedad * segundos squared / 2))).
	velocidadVertical := velocidadVertical + (gravedad * segundos).
	self aterrizarSiCorresponde
]

{ #category : 'privado' }
Personaje >> estaEnSuelo [

	^ posicion y + tamanio y >= alturaSuelo and: [ velocidadVertical >= 0 ]
]

{ #category : 'inicializacion' }
Personaje >> initialize [

	super initialize.
	tamanio := 36 @ 42.
	gravedad := 1600.
	impulsoSalto := 545.
	self reiniciarEn: 86 @ 0 suelo: 226
]

{ #category : 'acceso' }
Personaje >> limites [

	^ posicion extent: tamanio
]

{ #category : 'acceso' }
Personaje >> posicion [

	^ posicion
]

{ #category : 'inicializacion' }
Personaje >> reiniciarEn: unaPosicion suelo: unNumero [

	alturaSuelo := unNumero.
	posicion := unaPosicion x @ (alturaSuelo - tamanio y).
	velocidadVertical := 0
]

{ #category : 'movimiento' }
Personaje >> saltar [

	self estaEnSuelo ifTrue: [ velocidadVertical := impulsoSalto negated ]
]

{ #category : 'acceso' }
Personaje >> tamanio [

	^ tamanio
]
