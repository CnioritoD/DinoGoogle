"Conecta el modelo Juego con el panel del escenario y convierte las acciones del jugador en mensajes al modelo."
Class {
	#name : 'SistemaEscenario',
	#superclass : 'Object',
	#instVars : [
		'juego',
		'panel',
		'entrada'
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

{ #category : 'initialization' }
SistemaEscenario >> configurarEstilo: unEstilo [

	panel configurarEstilo: unEstilo
]

{ #category : 'initialization' }
SistemaEscenario >> configurarJuego: unJuego panel: unPanel [

	juego := unJuego.
	panel := unPanel.
	panel configurarTamanio: juego tamanioEscenario.
	entrada := EntradaEscenario new.
	entrada configurarSistema: self extension: panel extent.
	self refrescarPanel
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

	unContenedor addMorph: panel.
	panel position: unaPosicion.
	entrada montarEn: unContenedor posicion: unaPosicion
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

	panel mostrarEstado: juego estadoEscenario
]

{ #category : 'partida' }
SistemaEscenario >> reiniciarJuego [

	juego reiniciar.
	self iniciarJuego
]

{ #category : 'acceso' }
SistemaEscenario >> tiempoTranscurrido [

	^ juego tiempoTranscurrido
]

{ #category : 'interfaz' }
SistemaEscenario >> tomarFoco [

	entrada tomarFoco
]
