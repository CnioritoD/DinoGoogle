Class {
	#name : 'Sprites',
	#superclass : 'Object',
	#classVars : [
		'Cache',
		'Carpeta',
		'Fps'
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

{ #category : 'configuracion' }
Sprites class >> limpiarCache [

	Cache := nil
]

{ #category : 'configuracion' }
Sprites class >> archivosDe: unNombre [
	"Si existe una carpeta con ese nombre, devuelve sus PNG ordenados por el numero que
	 tienen en el nombre (0, 1, 2...). Si no, devuelve el archivo <nombre>.png (o nada)."

	| carpetaDeCuadros unico |
	carpetaDeCuadros := (self carpeta / unNombre) asFileReference.
	carpetaDeCuadros isDirectory ifTrue: [
		^ ((carpetaDeCuadros children select: [ :each | each extension asLowercase = 'png' ])
			asSortedCollection: [ :a :b | (self numeroDe: a) <= (self numeroDe: b) ]) asArray ].
	unico := (self carpeta / (unNombre , '.png')) asFileReference.
	^ unico exists
		ifTrue: [ { unico } ]
		ifFalse: [ #() ]
]

{ #category : 'imagenes' }
Sprites class >> cuadrosNombrados: unNombre tamanio: unTamanio [
	"Array con los cuadros de la animacion (uno solo si es una imagen fija), o nil si no hay
	 archivos. Se lee una sola vez; si cambiás un PNG, ejecutá Sprites limpiarCache."

	^ self cache at: unNombre ifAbsent: [
		self cache at: unNombre put: (self leerCuadros: unNombre tamanio: unTamanio) ]
]

{ #category : 'imagenes' }
Sprites class >> dinosaurioDe: unPersonaje tiempo: unosSegundos [
	"Cuadro que corresponde al estado del personaje (de pie o agachado) en ese momento del
	 juego, o nil si no hay archivos (el panel lo dibuja por codigo)."

	| cuadros |
	cuadros := self
		cuadrosNombrados: (unPersonaje estaAgachado
			ifTrue: [ 'dino-agachado' ]
			ifFalse: [ 'dino-pie' ])
		tamanio: unPersonaje tamanio.
	cuadros ifNil: [ ^ nil ].
	^ cuadros at: ((unosSegundos * self framesPorSegundo) floor \\ cuadros size) + 1
]

{ #category : 'configuracion' }
Sprites class >> framesPorSegundo [
	"Velocidad de las animaciones (los PNG no guardan cuanto dura cada cuadro)."

	^ Fps ifNil: [ 8 ]
]

{ #category : 'configuracion' }
Sprites class >> framesPorSegundo: unNumero [

	Fps := unNumero
]

{ #category : 'configuracion' }
Sprites class >> leerArchivo: unArchivo tamanio: unTamanio [

	| form |
	form := [ unArchivo binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ] ]
		on: Error
		do: [ :error |
			Transcript show: 'Sprites: no pude leer ', unArchivo basename; cr.
			nil ].
	form ifNil: [ ^ nil ].
	^ form extent = unTamanio
		ifTrue: [ form ]
		ifFalse: [ form scaledToSize: unTamanio ]
]

{ #category : 'configuracion' }
Sprites class >> leerCuadros: unNombre tamanio: unTamanio [

	| cuadros |
	cuadros := (self archivosDe: unNombre)
		collect: [ :each | self leerArchivo: each tamanio: unTamanio ].
	cuadros := cuadros reject: [ :each | each isNil ].
	cuadros isEmpty ifTrue: [ ^ nil ].
	^ cuadros asArray
]

{ #category : 'configuracion' }
Sprites class >> numeroDe: unArchivo [
	"Numero que aparece en el nombre del archivo (frame3.png -> 3)."

	^ (unArchivo basenameWithoutExtension select: [ :each | each isDigit ]) asInteger
		ifNil: [ 0 ]
]
