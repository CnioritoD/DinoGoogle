Class {
	#name : 'Obstaculo',
	#superclass : 'Object',
	#instVars : [
		'posicion',
		'tamanio',
		'contabilizado'
	],
	#category : 'DinoGoogle-Modelo',
	#package : 'DinoGoogle',
	#tag : 'Modelo'
}

{ #category : 'movimiento' }
Obstaculo >> avanzar: segundos velocidad: unaVelocidad [

	posicion := posicion - ((unaVelocidad * segundos) @ 0)
]

{ #category : 'testing' }
Obstaculo >> esPajaro [

	^ false
]

{ #category : 'acceso' }
Obstaculo >> estaContabilizado [

	^ contabilizado
]

{ #category : 'puntaje' }
Obstaculo >> estaFueraDelEscenario [

	^ self limites right <= 0
]

{ #category : 'puntaje' }
Obstaculo >> fueSuperadoPor: unPersonaje [

	^ self limites right <= unPersonaje limites left
]

{ #category : 'inicializacion' }
Obstaculo >> inicializarEn: unaPosicion tamanio: unTamanio [

	posicion := unaPosicion.
	tamanio := unTamanio.
	contabilizado := false
]

{ #category : 'acceso' }
Obstaculo >> limites [

	^ posicion extent: tamanio
]

{ #category : 'puntaje' }
Obstaculo >> marcarContabilizado [

	contabilizado := true
]

{ #category : 'acceso' }
Obstaculo >> posicion [

	^ posicion
]

{ #category : 'acceso' }
Obstaculo >> tamanio [

	^ tamanio
]
