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
		'alturaSuelo',
		'monedas',
		'tiempoHastaMoneda'
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

{ #category : 'partida' }
Juego >> agacharse [

	self estaEnCurso ifTrue: [ personaje agacharse ]
]

{ #category : 'acceso' }
Juego >> alturaSuelo [

	^ alturaSuelo
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
	self generarMonedaSiCorresponde: segundos.
	self moverMonedas: segundos.
	self recogerMonedas.
	self retirarMonedasFueraDeEscena.
	self hayColision ifTrue: [ ^ self finalizar ].
	self contabilizarObstaculosSuperados.
	self retirarObstaculosFueraDeEscena
]

{ #category : 'privado' }
Juego >> cantidadDeCactusEnGrupo [
	"Los primeros segundos solo salen cactus sueltos; despues aparecen grupos de 2 y de 3."

	| azar |
	tiempoTranscurrido < 10 ifTrue: [ ^ 1 ].
	azar := aleatorio next.
	azar < 0.45 ifTrue: [ ^ 1 ].
	azar < 0.8 ifTrue: [ ^ 2 ].
	^ 3
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
Juego >> crearGrupoDeCactus [
	"Crea 1, 2 o 3 cactus pegados, todos de la misma altura o de alturas distintas.
	 Si a la velocidad actual el salto no alcanzaria para pasar por encima del grupo
	 entero, se le van quitando cactus hasta que se pueda saltar."

	| cantidad mismaAltura altoComun anchos altos separaciones x obstaculo |
	cantidad := self cantidadDeCactusEnGrupo.
	mismaAltura := aleatorio next < 0.5.
	altoComun := 25 + (aleatorio nextInteger: 20).
	anchos := (1 to: cantidad) collect: [ :i | 20 + (aleatorio nextInteger: 10) ].
	altos := (1 to: cantidad) collect: [ :i |
		mismaAltura
			ifTrue: [ altoComun ]
			ifFalse: [ 25 + (aleatorio nextInteger: 20) ] ].
	separaciones := (1 to: cantidad) collect: [ :i | 3 + (aleatorio nextInteger: 5) ].
	[ cantidad > 1 and: [
		(self
			sePuedeSaltarGrupoDeAncho: ((anchos first: cantidad) inject: 0 into: [ :a :b | a + b ])
				+ ((separaciones first: cantidad - 1) inject: 0 into: [ :a :b | a + b ])
			altura: ((altos first: cantidad) inject: 0 into: [ :a :b | a max: b ])) not ] ]
		whileTrue: [ cantidad := cantidad - 1 ].
	x := tamanioEscenario x.
	1 to: cantidad do: [ :i |
		obstaculo := Obstaculo new.
		obstaculo
			inicializarEn: x @ (alturaSuelo - (altos at: i))
			tamanio: (anchos at: i) @ (altos at: i).
		"Un grupo vale un solo punto: solo el ultimo cactus se contabiliza."
		i < cantidad ifTrue: [ obstaculo marcarContabilizado ].
		obstaculos add: obstaculo.
		x := x + (anchos at: i) + (separaciones at: i) ]
]

{ #category : 'privado' }
Juego >> crearObstaculo [
	"Pasados los primeros segundos, a veces aparece un pajaro en lugar de un cactus."

	(tiempoTranscurrido > 15 and: [ aleatorio next < 0.3 ])
		ifTrue: [ self crearPajaro ]
		ifFalse: [ self crearGrupoDeCactus ]
]

{ #category : 'privado' }
Juego >> crearPajaro [
	"Vuela a una de tres alturas (medida desde el suelo hasta la base del pajaro):
	 8  -> a la altura de las piernas: hay que saltarlo.
	 30 -> a la altura de la cabeza: se esquiva agachado o saltando.
	 70 -> alto: pasa por encima del dinosaurio parado; hay que NO saltar."

	| alturaVuelo pajaro |
	alturaVuelo := #(8 30 70) at: (aleatorio nextInteger: 3).
	pajaro := Pajaro new.
	pajaro inicializarEn: tamanioEscenario x @ (alturaSuelo - alturaVuelo - 22) tamanio: 46 @ 22.
	obstaculos add: pajaro
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
		#monedas -> (monedas collect: [ :moneda | moneda limites ]).
		#suelo -> alturaSuelo.
		#puntos -> puntaje.
		#tiempo -> tiempoTranscurrido
	} asDictionary
]

{ #category : 'privado' }
Juego >> finalizar [

	estado := #finalizada
]

{ #category : 'privado' }
Juego >> generarMonedaSiCorresponde: segundos [
    | moneda posicionMoneda |
    tiempoHastaMoneda := tiempoHastaMoneda - segundos.
    tiempoHastaMoneda > 0 ifTrue: [ ^ self ].

    posicionMoneda := tamanioEscenario x @
        (alturaSuelo - (40 + ((aleatorio nextInteger: 3) * 30))).

    moneda := Moneda new.
    moneda inicializarEn: posicionMoneda tamanio: 14 @ 14.

    (obstaculos noneSatisfy: [ :each |
        each limites intersects: moneda limites ])
        ifTrue: [ monedas add: moneda ].

    tiempoHastaMoneda := 3 + (aleatorio next * 3)
]

{ #category : 'privado' }
Juego >> generarObstaculoSiCorresponde: segundos [

	tiempoHastaObstaculo := tiempoHastaObstaculo - segundos.
	tiempoHastaObstaculo > 0 ifTrue: [ ^ self ].

	self crearObstaculo.
	tiempoHastaObstaculo := tiempoHastaObstaculo + intervaloObstaculos + (aleatorio next * 0.32)
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
	monedas := OrderedCollection new.
	aleatorio := Random new.
	self reiniciar
]

{ #category : 'privado' }
Juego >> moverMonedas: segundos [
    monedas do: [ :moneda |
        moneda avanzar: segundos velocidad: velocidadDesplazamiento ]
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

{ #category : 'partida' }
Juego >> pararse [

	personaje pararse
]

{ #category : 'acceso' }
Juego >> personaje [

	^ personaje
]

{ #category : 'acceso' }
Juego >> puntaje [

	^ puntaje
]

{ #category : 'privado' }
Juego >> recogerMonedas [
    monedas removeAllSuchThat: [ :moneda |
        (personaje limites intersects: moneda limites)
            ifTrue: [ puntaje := puntaje + 1. true ]
            ifFalse: [ false ] ]
]

{ #category : 'partida' }
Juego >> reiniciar [

	obstaculos removeAll.
	monedas removeAll.
	estado := #enEspera.
	puntaje := 0.
	tiempoTranscurrido := 0.
	velocidadDesplazamiento := 255.
	intervaloObstaculos := 1.55.
	tiempoHastaObstaculo := 0.65.
	tiempoHastaMoneda := 3.
	personaje reiniciarEn: 86 @ 0 suelo: alturaSuelo
]

{ #category : 'privado' }
Juego >> retirarMonedasFueraDeEscena [
    monedas removeAllSuchThat: [ :moneda |
        moneda estaFueraDelEscenario ]
]

{ #category : 'privado' }
Juego >> retirarObstaculosFueraDeEscena [

	obstaculos removeAllSuchThat: [ :obstaculo | obstaculo estaFueraDelEscenario ]
]

{ #category : 'partida' }
Juego >> saltar [

	self estaEnCurso ifTrue: [ personaje saltar ]
]

{ #category : 'privado' }
Juego >> sePuedeSaltarGrupoDeAncho: unAncho altura: unaAltura [
	"El grupo se puede saltar si el personaje pasa por encima de su altura el tiempo que
	 tarda en cruzarlo (ancho del grupo + ancho del personaje, a la velocidad actual).
	 Se deja un margen del 25% para que el salto no tenga que ser perfecto."

	^ (unAncho + personaje tamanio x) / velocidadDesplazamiento
		<= ((personaje tiempoSobreAltura: unaAltura) * 0.75)
]

{ #category : 'acceso' }
Juego >> tamanioEscenario [

	^ tamanioEscenario
]

{ #category : 'acceso' }
Juego >> tiempoTranscurrido [

	^ tiempoTranscurrido
]
