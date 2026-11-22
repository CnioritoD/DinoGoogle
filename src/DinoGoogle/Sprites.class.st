Class {
	#name : 'Sprites',
	#superclass : 'Object',
	#classVars : [
		'Cache',
		'Carpeta'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'configuracion' }
Sprites class >> cache [

	^ Cache ifNil: [ Cache := Dictionary new ]
]

{ #category : 'configuracion' }
Sprites class >> carpeta [
	"Carpeta donde estan los PNG. Si no se configuro ninguna, se usa la carpeta 'assets' del
	 repositorio de Iceberg (la que esta junto a 'src')."

	^ Carpeta ifNil: [ self carpetaPorDefecto ]
]

{ #category : 'configuracion' }
Sprites class >> carpeta: unaRuta [
	"Para usar otra carpeta. Ejemplo: Sprites carpeta: 'C:\Users\yo\Desktop\DinoGoogle\assets'"

	Carpeta := unaRuta asFileReference.
	self limpiarCache
]

{ #category : 'configuracion' }
Sprites class >> carpetaPorDefecto [

	^ [ (IceRepository registry detect: [ :each | each name beginsWith: 'DinoGoogle' ])
		location / 'assets' ]
		on: Error
		do: [ :error | FileLocator imageDirectory / 'assets' ]
]

{ #category : 'imagenes' }
Sprites class >> dinosaurioDe: unPersonaje [
	"Imagen del dinosaurio segun este de pie o agachado, o nil si no hay archivo
	 (en ese caso el panel lo dibuja por codigo)."

	^ self
		imagenNombrada: (unPersonaje estaAgachado
			ifTrue: [ 'dino-agachado.png' ]
			ifFalse: [ 'dino-pie.png' ])
		tamanio: unPersonaje tamanio
]

{ #category : 'imagenes' }
Sprites class >> imagenNombrada: unNombre tamanio: unTamanio [
	"Devuelve el Form del archivo (ajustado a unTamanio), o nil si no existe o no se pudo leer.
	 Se lee una sola vez y queda guardado; si cambiás un PNG, ejecutá Sprites limpiarCache."

	^ self cache at: unNombre ifAbsent: [
		self cache at: unNombre put: (self leer: unNombre tamanio: unTamanio) ]
]

{ #category : 'configuracion' }
Sprites class >> leer: unNombre tamanio: unTamanio [

	| archivo form |
	archivo := (self carpeta / unNombre) asFileReference.
	archivo exists ifFalse: [ ^ nil ].
	form := [ archivo binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ] ]
		on: Error
		do: [ :error |
			Transcript show: 'Sprites: no pude leer ', unNombre; cr.
			nil ].
	form ifNil: [ ^ nil ].
	^ form extent = unTamanio
		ifTrue: [ form ]
		ifFalse: [ form scaledToSize: unTamanio ]
]

{ #category : 'configuracion' }
Sprites class >> limpiarCache [

	Cache := nil
]
