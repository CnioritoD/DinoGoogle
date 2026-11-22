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

{ #category : 'inicializacion' }
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

{ #category : 'reloj' }
SistemaReloj >> step [

	| ahora segundos |
	ultimoTiempo ifNil: [ ^ self ].
	ahora := Time millisecondClockValue.
	segundos := (Time milliseconds: ahora since: ultimoTiempo) / 1000.0.
	ultimoTiempo := ahora.
	coordinador actualizar: ((segundos max: 0) min: 0.10)
]

{ #category : 'reloj' }
SistemaReloj >> stepTime [

	^ 16
]

{ #category : 'reloj' }
SistemaReloj >> wantsSteps [

	^ ultimoTiempo notNil
]
