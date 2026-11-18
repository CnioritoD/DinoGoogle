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
		'tamanioEscenario',
		'alturaSuelo'
	],
	#category : 'DinoGoogle-Modelo',
	#package : 'DinoGoogle',
	#tag : 'Modelo'
}

{ #category : 'inicializacion' }
Juego >> initialize [

	super initialize.
	tamanioEscenario := 640 @ 266.
	alturaSuelo := 226.
	personaje := Personaje new.
	obstaculos := OrderedCollection new.
	aleatorio := Random new.
	self reiniciar
]

{ #category : 'partida' }
Juego >> iniciar [

	estado = #enEspera ifTrue: [ estado := #enCurso ]
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

{ #category : 'partida' }
Juego >> saltar [

	self estaEnCurso ifTrue: [ personaje saltar ]
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

{ #category : 'acceso' }
Juego >> estaEnCurso [

	^ estado = #enCurso
]

{ #category : 'acceso' }
Juego >> estado [

	^ estado
]

{ #category : 'acceso' }
Juego >> puntaje [

	^ puntaje
]

{ #category : 'acceso' }
Juego >> personaje [

	^ personaje
]

{ #category : 'acceso' }
Juego >> obstaculos [

	^ obstaculos
]

{ #category : 'acceso' }
Juego >> tamanioEscenario [

	^ tamanioEscenario
]

{ #category : 'acceso' }
Juego >> alturaSuelo [

	^ alturaSuelo
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
Juego >> actualizarDificultad [

	velocidadDesplazamiento := (255 + (tiempoTranscurrido * 3)) min: 460.
	intervaloObstaculos := (1.55 - (tiempoTranscurrido * 0.012)) max: 0.95
]

{ #category : 'privado' }
Juego >> generarObstaculoSiCorresponde: segundos [

	tiempoHastaObstaculo := tiempoHastaObstaculo - segundos.
	tiempoHastaObstaculo <= 0 ifTrue: [
		self crearObstaculo.
		tiempoHastaObstaculo := tiempoHastaObstaculo + intervaloObstaculos + (aleatorio next * 0.32) ]
]

{ #category : 'privado' }
Juego >> crearObstaculo [

	| ancho alto obstaculo |
	ancho := 22 + (aleatorio nextInteger: 15).
	alto := 25 + (aleatorio nextInteger: 20).
	obstaculo := Obstaculo new.
	obstaculo inicializarEn: tamanioEscenario x @ (alturaSuelo - alto) tamanio: ancho @ alto.
	obstaculos add: obstaculo
]

{ #category : 'privado' }
Juego >> moverObstaculos: segundos [

	obstaculos do: [ :obstaculo |
		obstaculo avanzar: segundos velocidad: velocidadDesplazamiento ]
]

{ #category : 'privado' }
Juego >> hayColision [

	^ obstaculos anySatisfy: [ :obstaculo |
		personaje limites intersects: obstaculo limites ]
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
Juego >> retirarObstaculosFueraDeEscena [

	obstaculos removeAllSuchThat: [ :obstaculo | obstaculo estaFueraDelEscenario ]
]

{ #category : 'privado' }
Juego >> finalizar [

	estado := #finalizada
]
