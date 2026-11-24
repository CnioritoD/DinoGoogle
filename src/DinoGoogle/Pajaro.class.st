"
Obstáculo volador que aporta el estado de sus alas para la animación del escenario.
"
Class {
	#name : 'Pajaro',
	#superclass : 'Obstaculo',
	#category : 'DinoGoogle-Modelo',
	#package : 'DinoGoogle',
	#tag : 'Modelo'
}

{ #category : 'acceso' }
Pajaro >> alaArriba [
	"Las alas se alternan segun lo que avanzo el pajaro: aletea mientras vuela."

	^ (posicion x / 18) floor even
]

{ #category : 'movimiento' }
Pajaro >> avanzar: segundos velocidad: unaVelocidad [
	"Vuela mas rapido de lo que se desplaza el suelo."

	super avanzar: segundos velocidad: unaVelocidad * 1.2
]

{ #category : 'testing' }
Pajaro >> esPajaro [

	^ true
]
