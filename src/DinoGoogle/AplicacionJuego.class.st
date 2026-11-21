Class {
	#name : 'AplicacionJuego',
	#superclass : 'Object',
	#instVars : [
		'vista'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'aplicacion' }
AplicacionJuego >> abrir [

	(vista isNil or: [ vista world isNil ]) ifTrue: [ vista := VistaJuego new ].
	^ vista abrir
]

{ #category : 'aplicacion' }
AplicacionJuego >> cerrar [

	vista ifNotNil: [
		vista delete.
		vista := nil ]
]
