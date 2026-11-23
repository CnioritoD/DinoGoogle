Class {
	#name : 'Juego',
	#superclass : 'Object',
	#instVars : [
		'personaje',
		'obstaculos',
		'estado',
		'puntaje',
		'tiempoTranscurrido',
		'velocidadDesplazamiento',
		'intervaloObstaculos',
		'tiempoHastaObstaculo',
		'aleatorio',
		'generadorObstaculos',
		'tamanioEscenario',
		'alturaSuelo'
	],
	#category : 'DinoGoogle-Modelo',
	#package : 'DinoGoogle',
	#tag : 'Modelo'
}

{ #category : 'privado' }
Juego >> actualizarDificultad [

	velocidadDesplazamiento := (255 + (tiempoTranscurrido * 6)) min: 600.
	intervaloObstaculos := (1.55 - (tiempoTranscurrido * 0.02)) max: 0.8
]

{ #category : 'acceso' }
Juego >> alturaSuelo [

	^ alturaSuelo
]

{ #category : 'partida' }
Juego >> agacharse [

	self estaEnCurso ifTrue: [ personaje agacharse ]
]

{ #category : 'partida' }
Juego >> avanzar: segundos [

	| restante paso |
	restante := segundos.
	[ self estaEnCurso and: [ restante > 0 ] ] whileTrue: [
		paso := restante min: 0.01.
		self avanzarPaso: paso.
		restante := restante - paso ]
]

{ #category : 'privado' }
Juego >> avanzarPaso: segundos [

	tiempoTranscurrido := tiempoTranscurrido + segundos.
	self actualizarDificultad.
	self generarObstaculoSiCorresponde: segundos.
	personaje avanzar: segundos.
	self moverObstaculos: segundos.
	self hayColision ifTrue: [ ^ self finalizar ].
	self contabilizarObstaculosSuperados.
	self retirarObstaculosFueraDeEscena
]

{ #category : 'privado' }
Juego >> contabilizarObstaculosSuperados [

	obstaculos do: [ :obstaculo |
		(obstaculo estaContabilizado not and: [ obstaculo fueSuperadoPor: personaje ])
			ifTrue: [
				puntaje := puntaje + 1.
				obstaculo marcarContabilizado ] ]
]

{ #category : 'privado' }
Juego >> crearObstaculo [

	| grupo |
	grupo := generadorObstaculos
		generarAlTiempo: tiempoTranscurrido
		siPuedeSaltar: [ :ancho :altura | self sePuedeSaltarGrupoDeAncho: ancho altura: altura ].
	"Un grupo vale un punto. Solo se suma al pasar su último obstáculo."
	grupo allButLast do: [ :obstaculo | obstaculo marcarContabilizado ].
	obstaculos addAll: grupo
]

{ #category : 'privado' }
Juego >> finalizar [

	estado := #finalizada
]

{ #category : 'acceso' }
Juego >> estaEnCurso [

	^ estado = #enCurso
]

{ #category : 'acceso' }
Juego >> estado [

	^ estado
]

{ #category : 'privado' }
Juego >> generarObstaculoSiCorresponde: segundos [

	tiempoHastaObstaculo := tiempoHastaObstaculo - segundos.
	tiempoHastaObstaculo <= 0 ifTrue: [
		self crearObstaculo.
		tiempoHastaObstaculo := tiempoHastaObstaculo + intervaloObstaculos + (aleatorio next * 0.32) ]
]

{ #category : 'privado' }
Juego >> hayColision [

	^ obstaculos anySatisfy: [ :obstaculo |
		personaje limites intersects: obstaculo limites ]
]

{ #category : 'partida' }
Juego >> iniciar [

	estado = #enEspera ifTrue: [ estado := #enCurso ]
]

{ #category : 'inicializacion' }
Juego >> initialize [

	super initialize.
	tamanioEscenario := 640 @ 266.
	alturaSuelo := 226.
	personaje := Personaje new.
	obstaculos := OrderedCollection new.
	aleatorio := Random new.
	generadorObstaculos := GeneradorObstaculos new.
	generadorObstaculos configurarAleatorio: aleatorio ancho: tamanioEscenario x suelo: alturaSuelo.
	self reiniciar
]

{ #category : 'privado' }
Juego >> moverObstaculos: segundos [

	obstaculos do: [ :obstaculo |
		obstaculo avanzar: segundos velocidad: velocidadDesplazamiento ]
]

{ #category : 'acceso' }
Juego >> obstaculos [

	^ obstaculos
]

{ #category : 'acceso' }
Juego >> personaje [

	^ personaje
]

{ #category : 'acceso' }
Juego >> puntaje [

	^ puntaje
]

{ #category : 'partida' }
Juego >> reiniciar [

	obstaculos removeAll.
	estado := #enEspera.
	puntaje := 0.
	tiempoTranscurrido := 0.
	velocidadDesplazamiento := 255.
	intervaloObstaculos := 1.55.
	tiempoHastaObstaculo := 0.65.
	personaje reiniciarEn: 86 @ 0 suelo: alturaSuelo
]

{ #category : 'privado' }
Juego >> retirarObstaculosFueraDeEscena [

	obstaculos removeAllSuchThat: [ :obstaculo | obstaculo estaFueraDelEscenario ]
]

{ #category : 'partida' }
Juego >> pararse [

	personaje pararse
]

{ #category : 'privado' }
Juego >> sePuedeSaltarGrupoDeAncho: unAncho altura: unaAltura [
	"El grupo se puede saltar si el personaje pasa por encima de su altura el tiempo que
	 tarda en cruzarlo (ancho del grupo + ancho del personaje, a la velocidad actual).
	 Se deja un margen del 25% para que el salto no tenga que ser perfecto."

	^ (unAncho + personaje tamanio x) / velocidadDesplazamiento
		<= ((personaje tiempoSobreAltura: unaAltura) * 0.75)
]

{ #category : 'partida' }
Juego >> saltar [

	self estaEnCurso ifTrue: [ personaje saltar ]
]

{ #category : 'acceso' }
Juego >> tamanioEscenario [

	^ tamanioEscenario
]

{ #category : 'acceso' }
Juego >> tiempoTranscurrido [

	^ tiempoTranscurrido
]

{ #category : 'acceso' }
Juego >> estadoEscenario [

	^ {
		#personaje -> personaje limites.
		#agachado -> personaje estaAgachado.
		#obstaculos -> (obstaculos collect: [ :obstaculo |
			| vuela |
			vuela := obstaculo esPajaro.
			{
				#limites -> obstaculo limites.
				#vuela -> vuela.
				#alaArriba -> (vuela and: [ obstaculo alaArriba ])
			} asDictionary ]).
		#suelo -> alturaSuelo.
		#puntos -> puntaje.
		#tiempo -> tiempoTranscurrido
	} asDictionary
]
