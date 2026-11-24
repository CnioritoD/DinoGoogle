Class {
	#name : 'Personaje',
	#superclass : 'Object',
	#instVars : [
		'posicion',
		'tamanio',
		'velocidadVertical',
		'gravedad',
		'impulsoSalto',
		'alturaSuelo',
		'agachado',
		'tamanioDePie',
		'tamanioAgachado'
	],
	#category : 'DinoGoogle-Modelo',
	#package : 'DinoGoogle',
	#tag : 'Modelo'
}

{ #category : 'privado' }
Personaje >> aterrizarSiCorresponde [

	self estaEnSuelo ifTrue: [
		posicion := posicion x @ (alturaSuelo - tamanio y).
		velocidadVertical := 0 ]
]

{ #category : 'movimiento' }
Personaje >> agacharse [
	"Solo se puede agachar estando en el suelo."

	(agachado or: [ self estaEnSuelo not ]) ifTrue: [ ^ self ].
	agachado := true.
	tamanio := tamanioAgachado.
	posicion := posicion x @ (alturaSuelo - tamanio y)
]

{ #category : 'movimiento' }
Personaje >> avanzar: segundos [

	self estaEnSuelo ifTrue: [ ^ self ].
	posicion := posicion + (0 @ ((velocidadVertical * segundos) + (gravedad * segundos squared / 2))).
	velocidadVertical := velocidadVertical + (gravedad * segundos).
	self aterrizarSiCorresponde
]

{ #category : 'acceso' }
Personaje >> estaAgachado [

	^ agachado
]

{ #category : 'privado' }
Personaje >> estaEnSuelo [

	^ posicion y + tamanio y >= alturaSuelo and: [ velocidadVertical >= 0 ]
]

{ #category : 'inicializacion' }
Personaje >> initialize [

	super initialize.
	tamanioDePie := 36 @ 42.
	tamanioAgachado := 58 @ 24.
	agachado := false.
	tamanio := tamanioDePie.
	gravedad := 1600.
	impulsoSalto := 545.
	self reiniciarEn: 86 @ 0 suelo: 226
]

{ #category : 'acceso' }
Personaje >> tiempoSobreAltura: unaAltura [
	"Segundos que dura un salto por encima de esa altura (medida desde el suelo).
	 Sale de resolver impulso * t - gravedad * t^2 / 2 = altura."

	^ ((impulsoSalto squared - (2 * gravedad * unaAltura)) max: 0) sqrt / (gravedad / 2)
]

{ #category : 'acceso' }
Personaje >> limites [

	^ posicion extent: tamanio
]

{ #category : 'movimiento' }
Personaje >> pararse [

	agachado ifFalse: [ ^ self ].
	agachado := false.
	tamanio := tamanioDePie.
	posicion := posicion x @ (alturaSuelo - tamanio y)
]

{ #category : 'inicializacion' }
Personaje >> reiniciarEn: unaPosicion suelo: unNumero [

	alturaSuelo := unNumero.
	agachado := false.
	tamanio := tamanioDePie.
	posicion := unaPosicion x @ (alturaSuelo - tamanio y).
	velocidadVertical := 0
]

{ #category : 'movimiento' }
Personaje >> saltar [

	self estaEnSuelo ifTrue: [
		self pararse.
		velocidadVertical := impulsoSalto negated ]
]

{ #category : 'acceso' }
Personaje >> tamanio [

	^ tamanio
]
