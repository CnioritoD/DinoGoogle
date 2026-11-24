"Recibe los eventos de teclado y mouse del escenario y traduce los controles a acciones de SistemaEscenario."
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

{ #category : 'initialization' }
EntradaEscenario >> configurarSistema: unSistema extension: unaExtension [

	sistema := unSistema.
	self color: Color transparent.
	self extent: unaExtension
]

{ #category : 'event handling' }
EntradaEscenario >> esFlechaAbajo: unEvento [

	^ unEvento keyCharacter = Character arrowDown
		or: [ unEvento keyValue = 31 or: [ unEvento key = KeyboardKey down ] ]
]

{ #category : 'event handling' }
EntradaEscenario >> esTeclaDeSalto: unEvento [

	^ unEvento keyValue = 32
		or: [ unEvento keyValue = Character arrowUp asciiValue
		or: [ unEvento key = KeyboardKey up
		or: [ unEvento keyCharacter = Character space
		or: [ unEvento keyCharacter = Character arrowUp ] ] ] ]
]

{ #category : 'event handling' }
EntradaEscenario >> handlesKeyboard: unEvento [

	^ sistema notNil and: [ sistema estaEnCurso ]
]

{ #category : 'event handling' }
EntradaEscenario >> handlesMouseDown: unEvento [

	^ sistema notNil and: [ sistema estaEnCurso ]
]

{ #category : 'event handling' }
EntradaEscenario >> keyDown: unEvento [

	sistema estaEnCurso ifFalse: [ ^ self ].
	(self esTeclaDeSalto: unEvento) ifTrue: [
		sistema ejecutarSalto.
		^ unEvento wasHandled: true ].
	(self esFlechaAbajo: unEvento) ifFalse: [ ^ self ].
	sistema ejecutarAgacharse.
	unEvento wasHandled: true
]

{ #category : 'event handling' }
EntradaEscenario >> keyUp: unEvento [

	sistema estaEnCurso ifFalse: [ ^ self ].
	(self esFlechaAbajo: unEvento) ifFalse: [ ^ self ].
	sistema ejecutarPararse.
	unEvento wasHandled: true
]

{ #category : 'interfaz' }
EntradaEscenario >> montarEn: unContenedor posicion: unaPosicion [

	unContenedor addMorph: self.
	self position: unaPosicion
]

{ #category : 'event handling' }
EntradaEscenario >> mouseDown: unEvento [

	(unEvento redButtonPressed or: [ unEvento whichButton = MouseButtonEvent redButton ])
		ifFalse: [ ^ self ].
	self tomarFoco.
	sistema ejecutarSalto
]

{ #category : 'event handling' }
EntradaEscenario >> tomarFoco [

	self world ifNotNil: [ :mundo | mundo activeHand newKeyboardFocus: self ]
]
