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
EntradaEscenario >> configurarSistema: unSistema extension: unaExtension [

	sistema := unSistema.
	self color: Color transparent.
	self extent: unaExtension
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
EntradaEscenario >> esTeclaDeSalto: unEvento [

	^ unEvento keyValue = 32
		or: [ unEvento keyValue = Character arrowUp asciiValue
		or: [ unEvento key = KeyboardKey up
		or: [ unEvento keyCharacter = Character space
		or: [ unEvento keyCharacter = Character arrowUp ] ] ] ]
]

{ #category : 'eventos' }
EntradaEscenario >> keyDown: unEvento [

	sistema estaEnCurso ifFalse: [ ^ self ].
	(self esTeclaDeSalto: unEvento) ifTrue: [
		sistema ejecutarSalto.
		^ unEvento wasHandled: true ].
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

	(unEvento redButtonPressed or: [ unEvento whichButton = MouseButtonEvent redButton ]) ifTrue: [
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
