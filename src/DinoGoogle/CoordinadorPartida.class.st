Class {
	#name : 'CoordinadorPartida',
	#superclass : 'Object',
	#instVars : [
		'escenario',
		'controles',
		'reloj',
		'resultadoGuardado'
	],
	#classVars : [
		'Resultados'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'resultados' }
CoordinadorPartida class >> registrarResultado: unResultado [

	| tabla anterior |
	tabla := self resultados.
	"Un mismo nick es un mismo jugador: solo se conserva su mejor resultado.
	'Guest' es anonimo: cada partida de Guest es una fila aparte."
	anterior := unResultado first = 'Guest'
		ifTrue: [ nil ]
		ifFalse: [
			tabla
				detect: [ :each | each first asLowercase = unResultado first asLowercase ]
				ifNone: [ nil ] ].
	anterior ifNotNil: [
		(unResultado third > anterior third or: [
			 unResultado third = anterior third and: [
				 unResultado second > anterior second ] ])
			ifFalse: [ ^ self ].
		tabla remove: anterior ].
	tabla add: unResultado.
	tabla sort: [ :a :b |
		a third = b third
			ifTrue: [ a second >= b second ]
			ifFalse: [ a third > b third ] ].
	tabla size > 5 ifTrue: [ tabla removeLast ]
]

{ #category : 'resultados' }
CoordinadorPartida class >> resultados [

	^ Resultados ifNil: [ Resultados := OrderedCollection new ]
]

{ #category : 'partida' }
CoordinadorPartida >> actualizar: segundos [

	escenario avanzar: segundos.
	self detenerSiTerminoLaPartida.
	self actualizarControles
]

{ #category : 'privado' }
CoordinadorPartida >> actualizarControles [

	controles mostrarPuntaje: escenario puntaje estado: escenario estado
]

{ #category : 'partida' }
CoordinadorPartida >> cerrar [

	reloj detener
]

{ #category : 'inicializacion' }
CoordinadorPartida >> configurarEscenario: unEscenario controles: unosControles reloj: unReloj [

	escenario := unEscenario.
	controles := unosControles.
	reloj := unReloj
]

{ #category : 'privado' }
CoordinadorPartida >> detenerSiTerminoLaPartida [

	escenario estaEnCurso ifFalse: [ reloj detener ]
]

{ #category : 'resultados' }
CoordinadorPartida >> guardarResultado: unNick [

	(escenario estado = #finalizada and: [ resultadoGuardado ~= true ])
		ifFalse: [ ^ self ].
	resultadoGuardado := true.
	self class registrarResultado: {
		unNick ifEmpty: [ 'Guest' ].
		escenario tiempoTranscurrido.
		escenario puntaje }
]

{ #category : 'partida' }
CoordinadorPartida >> iniciarPartida [

	escenario estado = #enEspera ifFalse: [ ^ self ].
	resultadoGuardado := false.
	escenario iniciarJuego.
	self actualizarControles.
	escenario tomarFoco.
	reloj iniciar
]

{ #category : 'inicializacion' }
CoordinadorPartida >> initialize [

	super initialize.
	self configurarEscenario: SistemaEscenario new controles: SistemaControles new reloj: SistemaReloj new.
	escenario configurarJuego: Juego new panel: PanelEscenario new.
	controles configurarCoordinador: self panel: PanelControles new.
	reloj configurarCoordinador: self.
	controles mostrarResultados: self class resultados.
	self actualizarControles
]

{ #category : 'interfaz' }
CoordinadorPartida >> montarInterfazEn: unContenedor [

	| posicion |
	posicion := unContenedor position + (8 @ 8).
	escenario montarEn: unContenedor posicion: posicion.
	controles montarEn: unContenedor posicion: posicion.
	reloj montarEn: unContenedor posicion: posicion
]

{ #category : 'partida' }
CoordinadorPartida >> prepararSiguientePartida [

	reloj detener.
	escenario prepararJuego.
	controles mostrarResultados: self class resultados.
	self actualizarControles
]

{ #category : 'partida' }
CoordinadorPartida >> reiniciarPartida [

	reloj detener.
	resultadoGuardado := false.
	escenario reiniciarJuego.
	self actualizarControles.
	escenario tomarFoco.
	reloj iniciar
]

{ #category : 'partida' }
CoordinadorPartida >> salir [

	self prepararSiguientePartida
]

{ #category : 'inicializacion' }
CoordinadorPartida >> configurarEstilo: unEstilo [

	escenario configurarEstilo: unEstilo.
	controles configurarEstilo: unEstilo
]
