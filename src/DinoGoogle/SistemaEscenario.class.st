Class {
	#name : 'SistemaEscenario',
	#superclass : 'Morph',
	#instVars : [
		'coordinador',
		'juego',
		'panel'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'partida' }
SistemaEscenario >> avanzar: segundos [

	juego avanzar: segundos.
	self refrescarPanel
]

{ #category : 'inicializacion' }
SistemaEscenario >> configurarCoordinador: unCoordinador juego: unJuego panel: unPanel [

	coordinador := unCoordinador.
	juego := unJuego.
	panel := unPanel.
	panel configurarJuego: juego.
	self color: Color transparent.
	self extent: panel extent.
	self addMorph: panel.
	panel position: self position
]

{ #category : 'partida' }
SistemaEscenario >> ejecutarAgacharse [

	juego agacharse.
	self refrescarPanel
]

{ #category : 'partida' }
SistemaEscenario >> ejecutarPararse [

	juego pararse.
	self refrescarPanel
]

{ #category : 'partida' }
SistemaEscenario >> ejecutarSalto [

	juego saltar.
	self refrescarPanel
]

{ #category : 'acceso' }
SistemaEscenario >> estaEnCurso [

	^ juego estaEnCurso
]

{ #category : 'acceso' }
SistemaEscenario >> estado [

	^ juego estado
]

{ #category : 'partida' }
SistemaEscenario >> iniciarJuego [

	juego iniciar.
	self refrescarPanel
]

{ #category : 'interfaz' }
SistemaEscenario >> montarEn: unContenedor posicion: unaPosicion [

	unContenedor addMorph: self.
	self position: unaPosicion
]

{ #category : 'acceso' }
SistemaEscenario >> panel [

	^ panel
]

{ #category : 'partida' }
SistemaEscenario >> prepararJuego [

	juego reiniciar.
	self refrescarPanel
]

{ #category : 'acceso' }
SistemaEscenario >> puntaje [

	^ juego puntaje
]

{ #category : 'interfaz' }
SistemaEscenario >> refrescarPanel [

	panel changed
]

{ #category : 'partida' }
SistemaEscenario >> reiniciarJuego [

	juego reiniciar.
	self iniciarJuego
]

{ #category : 'partida' }
SistemaEscenario >> solicitarAgacharse [

	coordinador solicitarAgacharse
]

{ #category : 'partida' }
SistemaEscenario >> solicitarPararse [

	coordinador solicitarPararse
]

{ #category : 'partida' }
SistemaEscenario >> solicitarSalto [

	coordinador solicitarSalto
]

{ #category : 'acceso' }
SistemaEscenario >> tiempoTranscurrido [

	^ juego tiempoTranscurrido
]

{ #category : 'inicializacion' }
SistemaEscenario >> configurarEstilo: unEstilo [

	panel configurarEstilo: unEstilo
]

{ #category : 'eventos' }
SistemaEscenario >> handlesKeyboard: unEvento [

	^ juego notNil and: [ juego estaEnCurso ]
]

{ #category : 'eventos' }
SistemaEscenario >> handlesMouseDown: unEvento [

	^ juego notNil and: [ juego estaEnCurso ]
]

{ #category : 'eventos' }
SistemaEscenario >> esFlechaAbajo: unEvento [

	^ unEvento keyCharacter = Character arrowDown
		or: [ unEvento keyValue = 31 or: [ unEvento key = KeyboardKey down ] ]
]

{ #category : 'eventos' }
SistemaEscenario >> keyDown: unEvento [

	self estaEnCurso ifFalse: [ ^ self ].
	unEvento keyCharacter = Character space ifTrue: [
		self solicitarSalto.
		unEvento wasHandled: true ].
	(self esFlechaAbajo: unEvento) ifTrue: [
		self solicitarAgacharse.
		unEvento wasHandled: true ]
]

{ #category : 'eventos' }
SistemaEscenario >> keyUp: unEvento [

	self estaEnCurso ifFalse: [ ^ self ].
	(self esFlechaAbajo: unEvento) ifTrue: [
		self solicitarPararse.
		unEvento wasHandled: true ]
]

{ #category : 'eventos' }
SistemaEscenario >> mouseDown: unEvento [

	unEvento redButtonPressed ifTrue: [
		self tomarFoco.
		self solicitarSalto ]
]

{ #category : 'eventos' }
SistemaEscenario >> tomarFoco [

	self world ifNotNil: [ :mundo | mundo activeHand newKeyboardFocus: self ]
]
