Class {
	#name : 'EntradaEscenario',
	#superclass : 'Morph',
	#instVars : [
		'sistema'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'inicializacion' }
EntradaEscenario >> configurarSistema: unSistema panel: unPanel [

	sistema := unSistema.
	self color: Color transparent.
	self extent: unPanel extent.
	self addMorph: unPanel.
	unPanel position: self position
]

{ #category : 'eventos' }
EntradaEscenario >> handlesKeyboard: unEvento [

	^ sistema notNil and: [ sistema estaEnCurso ]
]

{ #category : 'eventos' }
EntradaEscenario >> handlesMouseDown: unEvento [

	^ sistema notNil and: [ sistema estaEnCurso ]
]

{ #category : 'eventos' }
EntradaEscenario >> esFlechaAbajo: unEvento [

	^ unEvento keyCharacter = Character arrowDown
		or: [ unEvento keyValue = 31 or: [ unEvento key = KeyboardKey down ] ]
]

{ #category : 'eventos' }
EntradaEscenario >> keyDown: unEvento [

	sistema estaEnCurso ifFalse: [ ^ self ].
	unEvento keyCharacter = Character space ifTrue: [
		sistema ejecutarSalto.
		unEvento wasHandled: true ].
	(self esFlechaAbajo: unEvento) ifTrue: [
		sistema ejecutarAgacharse.
		unEvento wasHandled: true ]
]

{ #category : 'eventos' }
EntradaEscenario >> keyUp: unEvento [

	sistema estaEnCurso ifFalse: [ ^ self ].
	(self esFlechaAbajo: unEvento) ifTrue: [
		sistema ejecutarPararse.
		unEvento wasHandled: true ]
]

{ #category : 'eventos' }
EntradaEscenario >> mouseDown: unEvento [

	unEvento redButtonPressed ifTrue: [
		self tomarFoco.
		sistema ejecutarSalto ]
]

{ #category : 'eventos' }
EntradaEscenario >> tomarFoco [

	self world ifNotNil: [ :mundo | mundo activeHand newKeyboardFocus: self ]
]

{ #category : 'interfaz' }
EntradaEscenario >> montarEn: unContenedor posicion: unaPosicion [

	unContenedor addMorph: self.
	self position: unaPosicion
]
