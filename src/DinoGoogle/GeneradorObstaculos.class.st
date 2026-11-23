Class {
	#name : 'GeneradorObstaculos',
	#superclass : 'Object',
	#instVars : [
		'aleatorio',
		'anchoEscenario',
		'alturaSuelo'
	],
	#category : 'DinoGoogle-Modelo',
	#package : 'DinoGoogle',
	#tag : 'Modelo'
}

{ #category : 'inicializacion' }
GeneradorObstaculos >> configurarAleatorio: unAleatorio ancho: unAncho suelo: unaAltura [

	aleatorio := unAleatorio.
	anchoEscenario := unAncho.
	alturaSuelo := unaAltura
]

{ #category : 'generacion' }
GeneradorObstaculos >> generarAlTiempo: unosSegundos siPuedeSaltar: puedeSaltar [

	(unosSegundos > 15 and: [ aleatorio next < 0.3 ])
		ifTrue: [ ^ { self crearPajaro } ].
	^ self crearGrupoDeCactusAlTiempo: unosSegundos siPuedeSaltar: puedeSaltar
]

{ #category : 'privado' }
GeneradorObstaculos >> cantidadDeCactusAlTiempo: unosSegundos [
	"Los primeros segundos solo salen cactus sueltos; despues aparecen grupos de 2 y de 3."

	| azar |
	unosSegundos < 10 ifTrue: [ ^ 1 ].
	azar := aleatorio next.
	azar < 0.45 ifTrue: [ ^ 1 ].
	azar < 0.8 ifTrue: [ ^ 2 ].
	^ 3
]

{ #category : 'privado' }
GeneradorObstaculos >> crearGrupoDeCactusAlTiempo: unosSegundos siPuedeSaltar: puedeSaltar [
	"Crea 1, 2 o 3 cactus pegados, todos de la misma altura o de alturas distintas.
	 Si a la velocidad actual el salto no alcanzaria para pasar por encima del grupo
	 entero, se le van quitando cactus hasta que se pueda saltar."

	| cantidad mismaAltura altoComun anchos altos separaciones x obstaculo grupo |
	cantidad := self cantidadDeCactusAlTiempo: unosSegundos.
	mismaAltura := aleatorio next < 0.5.
	altoComun := 25 + (aleatorio nextInteger: 20).
	anchos := (1 to: cantidad) collect: [ :i | 20 + (aleatorio nextInteger: 10) ].
	altos := (1 to: cantidad) collect: [ :i |
		mismaAltura
			ifTrue: [ altoComun ]
			ifFalse: [ 25 + (aleatorio nextInteger: 20) ] ].
	separaciones := (1 to: cantidad) collect: [ :i | 3 + (aleatorio nextInteger: 5) ].
	[ cantidad > 1 and: [
		(puedeSaltar
			value: ((anchos first: cantidad) inject: 0 into: [ :a :b | a + b ])
				+ ((separaciones first: cantidad - 1) inject: 0 into: [ :a :b | a + b ])
			value: ((altos first: cantidad) inject: 0 into: [ :a :b | a max: b ])) not ] ]
		whileTrue: [ cantidad := cantidad - 1 ].
	x := anchoEscenario.
	grupo := OrderedCollection new: cantidad.
	1 to: cantidad do: [ :i |
		obstaculo := Obstaculo new.
		obstaculo
			inicializarEn: x @ (alturaSuelo - (altos at: i))
			tamanio: (anchos at: i) @ (altos at: i).
		grupo add: obstaculo.
		x := x + (anchos at: i) + (separaciones at: i) ].
	^ grupo
]

{ #category : 'privado' }
GeneradorObstaculos >> crearPajaro [
	"Vuela a una de tres alturas (medida desde el suelo hasta la base del pajaro):
	 8  -> a la altura de las piernas: hay que saltarlo.
	 30 -> a la altura de la cabeza: se esquiva agachado o saltando.
	 70 -> alto: pasa por encima del dinosaurio parado; hay que NO saltar."

	| alturaVuelo pajaro |
	alturaVuelo := #(8 30 70) at: (aleatorio nextInteger: 3).
	pajaro := Pajaro new.
	pajaro inicializarEn: anchoEscenario @ (alturaSuelo - alturaVuelo - 22) tamanio: 46 @ 22.
	^ pajaro
]
