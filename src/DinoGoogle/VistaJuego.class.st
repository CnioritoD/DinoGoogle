Class {
	#name : 'VistaJuego',
	#superclass : 'SystemWindow',
	#instVars : [
		'coordinador'
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
	contenedor := Morph new color: EstiloRetro pantalla; yourself.
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
	coordinador alSalir: [ self delete ].
	self construirInterfaz
]
