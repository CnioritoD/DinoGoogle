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

{ #category : 'inicializacion' }
Obstaculo >> inicializarEn: unaPosicion tamanio: unTamanio [

	posicion := unaPosicion.
	tamanio := unTamanio.
	contabilizado := false
]

{ #category : 'movimiento' }
Obstaculo >> avanzar: segundos velocidad: unaVelocidad [

	posicion := posicion - ((unaVelocidad * segundos) @ 0)
]

{ #category : 'acceso' }
Obstaculo >> posicion [

	^ posicion
]

{ #category : 'acceso' }
Obstaculo >> tamanio [

	^ tamanio
]

{ #category : 'acceso' }
Obstaculo >> limites [

	^ posicion extent: tamanio
]

{ #category : 'acceso' }
Obstaculo >> estaContabilizado [

	^ contabilizado
]

{ #category : 'puntaje' }
Obstaculo >> fueSuperadoPor: unPersonaje [

	^ self limites right <= unPersonaje limites left
]

{ #category : 'puntaje' }
Obstaculo >> estaFueraDelEscenario [

	^ self limites right <= 0
]

{ #category : 'puntaje' }
Obstaculo >> marcarContabilizado [

	contabilizado := true
]
