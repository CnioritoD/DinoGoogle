"
Mide el tiempo entre pasos de Morphic y avisa al coordinador cuánto debe avanzar la partida.
"
Class {
	#name : 'SistemaReloj',
	#superclass : 'Morph',
	#instVars : [
		'coordinador',
		'ultimoTiempo'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'initialization' }
SistemaReloj >> configurarCoordinador: unCoordinador [

	coordinador := unCoordinador.
	self extent: 0 @ 0
]

{ #category : 'reloj' }
SistemaReloj >> detener [

	self stopStepping.
	ultimoTiempo := nil
]

{ #category : 'reloj' }
SistemaReloj >> iniciar [

	self detener.
	ultimoTiempo := Time millisecondClockValue.
	self startStepping
]

{ #category : 'interfaz' }
SistemaReloj >> montarEn: unContenedor posicion: unaPosicion [

	unContenedor addMorph: self.
	self position: unaPosicion
]

{ #category : 'stepping and presenter' }
SistemaReloj >> step [

	| ahora segundos |
	ultimoTiempo ifNil: [ ^ self ].
	ahora := Time millisecondClockValue.
	segundos := (Time milliseconds: ahora since: ultimoTiempo) / 1000.0.
	ultimoTiempo := ahora.
	coordinador actualizar: ((segundos max: 0) min: 0.10)
]

{ #category : 'stepping and presenter' }
SistemaReloj >> stepTime [

	^ 16
]

{ #category : 'stepping and presenter' }
SistemaReloj >> wantsSteps [

	^ ultimoTiempo notNil
]
