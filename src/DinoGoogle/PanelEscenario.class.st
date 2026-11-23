Class {
	#name : 'PanelEscenario',
	#superclass : 'Morph',
	#instVars : [
		'estilo',
		'limitesPersonaje',
		'agachado',
		'obstaculos',
		'alturaSuelo',
		'puntos',
		'tiempoTranscurrido'
	],
	#classVars : [
		'CacheSprites',
		'CarpetaSprites',
		'FpsSprites'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'inicializacion' }
PanelEscenario >> configurarTamanio: unTamanio [

	self extent: unTamanio + (0 @ 78).
	self clipSubmorphs: true
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarCieloEn: canvas [

	| origen |
	origen := self position.
	canvas fillRectangle: ((origen + (7 @ 7)) extent: 626 @ 279) color: (Color gray: 0.87).
	"Sol, nubes y colinas en bloques de píxeles."
	canvas fillRectangle: ((origen + (521 @ 32)) extent: 38 @ 60) color: (estilo at: #luz).
	canvas fillRectangle: ((origen + (510 @ 43)) extent: 60 @ 38) color: (estilo at: #luz).
	#(54 261 415) do: [ :x |
		canvas fillRectangle: ((origen + (x @ 92)) extent: 68 @ 5) color: (estilo at: #relieve).
		canvas fillRectangle: ((origen + ((x + 12) @ 86)) extent: 34 @ 6) color: (estilo at: #relieve) ].
	#(27 202 390 531) do: [ :x |
		1 to: 4 do: [ :nivel |
			| escalon |
			escalon := nivel * 12.
			canvas fillRectangle: ((origen + ((x + escalon) @ (286 - (nivel * 9))))
				extent: (116 - (escalon * 2)) @ 9) color: (estilo at: #relieve) ] ]
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarIndicadoresEn: canvas [

	| puntaje tiempo |
	puntaje := (self position + (16 @ 300)) extent: 218 @ 34.
	tiempo := (self position + (406 @ 300)) extent: 218 @ 34.
	self dibujarMarco: puntaje fondo: (estilo at: #pantalla) hundido: true en: canvas.
	self dibujarMarco: tiempo fondo: (estilo at: #pantalla) hundido: true en: canvas.
	self dibujarTexto: 'PUNTOS ', puntos printString
		centradoEn: puntaje escala: 2 color: (estilo at: #luz) en: canvas.
	self dibujarTexto: 'TIEMPO ', tiempoTranscurrido floor printString, ' S'
		centradoEn: tiempo escala: 2 color: (estilo at: #luz) en: canvas
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarCactus: obstaculo en: canvas [

	| silueta cuerpo luz borde origen escala vertices |
	silueta := {
		8 @ 1. 12 @ 1. 13 @ 2. 13 @ 16. 16 @ 16. 16 @ 9.
		19 @ 9. 19 @ 18. 17 @ 20. 13 @ 20. 13 @ 27. 7 @ 27.
		7 @ 17. 3 @ 17. 1 @ 15. 1 @ 7. 4 @ 7. 4 @ 13.
		7 @ 13. 7 @ 2 }.
	cuerpo := (estilo at: #pantalla).
	luz := (estilo at: #metal).
	borde := (estilo at: #tinta).
	origen := self position + (0 @ 60) + (obstaculo at: #limites) origin rounded.
	escala := (obstaculo at: #limites) extent / (20 @ 28).
	vertices := silueta collect: [ :punto | origen + (punto * escala) rounded ].
	canvas drawPolygon: vertices color: cuerpo borderWidth: 2 borderColor: borde.
	canvas
		line: origen + ((9 @ 4) * escala) rounded
		to: origen + ((9 @ 24) * escala) rounded
		width: 1
		color: luz
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarObstaculosEn: canvas [

	obstaculos do: [ :obstaculo |
		(obstaculo at: #vuela)
			ifTrue: [ self dibujarPajaro: obstaculo en: canvas ]
			ifFalse: [ self dibujarCactus: obstaculo en: canvas ] ]
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarPajaro: pajaro en: canvas [
	"El dibujo ocupa la caja de 46 x 22 del pajaro; el ala sube y baja (aletea)."

	| origen cuerpo ala colorCuerpo colorAla borde |
	origen := self position + (0 @ 60) + (pajaro at: #limites) origin rounded.
	cuerpo := {
		0 @ 10. 11 @ 6. 17 @ 8. 31 @ 9. 45 @ 11. 31 @ 14. 18 @ 15. 11 @ 13 }.
	ala := (pajaro at: #alaArriba)
		ifTrue: [ { 19 @ 9. 25 @ 0. 34 @ 2. 30 @ 9 } ]
		ifFalse: [ { 19 @ 14. 25 @ 21. 34 @ 19. 30 @ 14 } ].
	colorCuerpo := (estilo at: #pantalla).
	colorAla := (estilo at: #metal).
	borde := (estilo at: #tinta).
	canvas drawPolygon: (cuerpo collect: [ :punto | origen + punto ])
		color: colorCuerpo borderWidth: 2 borderColor: borde.
	canvas drawPolygon: (ala collect: [ :punto | origen + punto ])
		color: colorAla borderWidth: 2 borderColor: borde.
	canvas fillRectangle: ((origen + (8 @ 8)) extent: 2 @ 2) color: Color white
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarPersonajeAgachadoEn: canvas [

	| origen silueta sombra |
	origen := self position + (0 @ 60) + limitesPersonaje origin rounded.
	silueta := {
		0 @ 8. 6 @ 6. 27 @ 6. 28 @ 2. 41 @ 2. 41 @ 8. 35 @ 8. 35 @ 11.
		40 @ 11. 40 @ 13. 30 @ 13. 30 @ 19. 27 @ 19. 27 @ 23. 22 @ 23.
		22 @ 18. 20 @ 18. 20 @ 22. 17 @ 22. 17 @ 23. 12 @ 23. 12 @ 16.
		5 @ 15. 2 @ 12 }.
	canvas drawPolygon: (silueta collect: [ :punto | origen + punto ])
		color: (estilo at: #pantalla)
		borderWidth: 2 borderColor: (estilo at: #tinta).
	sombra := (estilo at: #sombra).
	canvas fillRectangle: ((origen + (10 @ 10)) extent: 12 @ 3) color: sombra.
	canvas fillRectangle: ((origen + (29 @ 3)) extent: 8 @ 2)
		color: (estilo at: #metal).
	canvas fillRectangle: ((origen + (33 @ 4)) extent: 3 @ 3) color: Color black
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarPersonajeEn: canvas [

	| origen silueta sombra imagen |
	origen := self position + (0 @ 60) + limitesPersonaje origin rounded.
	"Si hay un PNG en la carpeta de sprites se usa; si no, se dibuja por codigo."
	imagen := self class dinosaurioAgachado: agachado
		tamanio: limitesPersonaje extent tiempo: tiempoTranscurrido.
	imagen ifNotNil: [ ^ canvas paintImage: imagen at: origen ].
	agachado ifTrue: [ ^ self dibujarPersonajeAgachadoEn: canvas ].
	silueta := {
		21 @ 1. 33 @ 1. 33 @ 3. 35 @ 3. 35 @ 13. 28 @ 13.
		28 @ 17. 34 @ 17. 34 @ 21. 27 @ 21. 27 @ 31. 24 @ 31.
		24 @ 37. 28 @ 37. 28 @ 41. 20 @ 41. 20 @ 34. 16 @ 34.
		16 @ 38. 19 @ 38. 19 @ 41. 12 @ 41. 12 @ 32. 8 @ 30.
		8 @ 27. 4 @ 27. 4 @ 23. 1 @ 23. 1 @ 15. 4 @ 15.
		4 @ 20. 9 @ 20. 9 @ 22. 13 @ 22. 13 @ 18. 17 @ 18.
		17 @ 13. 19 @ 13. 19 @ 3. 21 @ 3 }.
	canvas drawPolygon: (silueta collect: [ :punto | origen + punto ])
		color: (estilo at: #pantalla)
		borderWidth: 2 borderColor: (estilo at: #tinta).

	sombra := (estilo at: #sombra).
	canvas fillRectangle: ((origen + (12 @ 26)) extent: 11 @ 4) color: sombra.
	canvas fillRectangle: ((origen + (23 @ 3)) extent: 8 @ 2)
		color: (estilo at: #metal).
	canvas fillRectangle: ((origen + (25 @ 6)) extent: 3 @ 3) color: Color black.
	canvas fillRectangle: ((origen + (31 @ 11)) extent: 3 @ 1) color: sombra
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarSueloEn: canvas [

	| borde desplazamiento |
	borde := self position + (7 @ (alturaSuelo + 60)).
	canvas fillRectangle: (borde extent: (self width - 14) @ 4) color: (estilo at: #tinta).
	desplazamiento := (tiempoTranscurrido * 80) floor.
	0 to: 15 do: [ :i |
		| x |
		x := (i * 43 - desplazamiento) \\ 620.
		canvas fillRectangle: ((borde + (x @ 7)) extent: 6 @ 2) color: (estilo at: #sombra) ]
]

{ #category : 'dibujo' }
PanelEscenario >> drawOn: canvas [

	(limitesPersonaje isNil or: [ estilo isNil ]) ifTrue: [ ^ super drawOn: canvas ].
	canvas clipBy: self bounds during: [ :lienzo |
		self dibujarMarco: self bounds fondo: (estilo at: #metal) hundido: false en: lienzo.
		self dibujarCieloEn: lienzo.
		self dibujarSueloEn: lienzo.
		lienzo clipBy: (self bounds insetBy: 7) during: [ :escena |
			self dibujarPersonajeEn: escena.
			self dibujarObstaculosEn: escena ].
		self dibujarIndicadoresEn: lienzo ]
]

{ #category : 'configuracion' }
PanelEscenario class >> cacheSprites [

	^ CacheSprites ifNil: [ CacheSprites := Dictionary new ]
]

{ #category : 'configuracion' }
PanelEscenario class >> carpetaSprites [
	"Carpeta donde estan los PNG. Si no se configuro ninguna, se usa la carpeta 'assets' del
	 repositorio de Iceberg (la que esta junto a 'src')."

	^ CarpetaSprites ifNil: [ self carpetaSpritesPorDefecto ]
]

{ #category : 'configuracion' }
PanelEscenario class >> carpetaSprites: unaRuta [
	"Para usar otra carpeta. Ejemplo: PanelEscenario carpetaSprites: 'C:\Users\yo\Desktop\DinoGoogle\assets'"

	CarpetaSprites := unaRuta asFileReference.
	self limpiarCacheSprites
]

{ #category : 'configuracion' }
PanelEscenario class >> carpetaSpritesPorDefecto [

	^ [ (IceRepository registry detect: [ :each | each name beginsWith: 'DinoGoogle' ])
		location / 'assets' ]
		on: Error
		do: [ :error | FileLocator imageDirectory / 'assets' ]
]

{ #category : 'configuracion' }
PanelEscenario class >> limpiarCacheSprites [

	CacheSprites := nil
]

{ #category : 'configuracion' }
PanelEscenario class >> archivosDe: unNombre [
	"Si existe una carpeta con ese nombre, devuelve sus PNG ordenados por el numero que
	 tienen en el nombre (0, 1, 2...). Si no, devuelve el archivo <nombre>.png (o nada)."

	| carpetaDeCuadros unico |
	carpetaDeCuadros := (self carpetaSprites / unNombre) asFileReference.
	carpetaDeCuadros isDirectory ifTrue: [
		^ ((carpetaDeCuadros children select: [ :each | each extension asLowercase = 'png' ])
			asSortedCollection: [ :a :b | (self numeroDe: a) <= (self numeroDe: b) ]) asArray ].
	unico := (self carpetaSprites / (unNombre , '.png')) asFileReference.
	^ unico exists
		ifTrue: [ { unico } ]
		ifFalse: [ #() ]
]

{ #category : 'imagenes' }
PanelEscenario class >> cuadrosNombrados: unNombre tamanio: unTamanio [
	"Array con los cuadros de la animacion (uno solo si es una imagen fija), o nil si no hay
	 archivos. Se lee una sola vez; si cambiás un PNG, ejecutá PanelEscenario limpiarCacheSprites."

	^ self cacheSprites at: unNombre ifAbsent: [
		self cacheSprites at: unNombre put: (self leerCuadros: unNombre tamanio: unTamanio) ]
]

{ #category : 'imagenes' }
PanelEscenario class >> dinosaurioAgachado: estaAgachado tamanio: unTamanio tiempo: unosSegundos [
	"Cuadro que corresponde al estado del personaje (de pie o agachado) en ese momento del
	 juego, o nil si no hay archivos (el panel lo dibuja por codigo)."

	| cuadros |
	cuadros := self
		cuadrosNombrados: (estaAgachado
			ifTrue: [ 'dino-agachado' ]
			ifFalse: [ 'dino-pie' ])
		tamanio: unTamanio.
	cuadros ifNil: [ ^ nil ].
	^ cuadros at: ((unosSegundos * self framesPorSegundoSprites) floor \\ cuadros size) + 1
]

{ #category : 'configuracion' }
PanelEscenario class >> framesPorSegundoSprites [
	"Velocidad de las animaciones (los PNG no guardan cuanto dura cada cuadro)."

	^ FpsSprites ifNil: [ 8 ]
]

{ #category : 'configuracion' }
PanelEscenario class >> framesPorSegundoSprites: unNumero [

	FpsSprites := unNumero
]

{ #category : 'configuracion' }
PanelEscenario class >> leerArchivo: unArchivo tamanio: unTamanio [

	| form |
	form := [ unArchivo binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ] ]
		on: Error
		do: [ :error |
			Transcript show: 'PanelEscenario: no pude leer ', unArchivo basename; cr.
			nil ].
	form ifNil: [ ^ nil ].
	^ form extent = unTamanio
		ifTrue: [ self enGrises: form ]
		ifFalse: [ self enGrises: (form scaledToSize: unTamanio) ]
]

{ #category : 'configuracion' }
PanelEscenario class >> leerCuadros: unNombre tamanio: unTamanio [

	| cuadros |
	cuadros := (self archivosDe: unNombre)
		collect: [ :each | self leerArchivo: each tamanio: unTamanio ].
	cuadros := cuadros reject: [ :each | each isNil ].
	cuadros isEmpty ifTrue: [ ^ nil ].
	^ cuadros asArray
]

{ #category : 'configuracion' }
PanelEscenario class >> numeroDe: unArchivo [
	"Numero que aparece en el nombre del archivo (frame3.png -> 3)."

	^ (unArchivo basenameWithoutExtension select: [ :each | each isDigit ]) asInteger
		ifNil: [ 0 ]
]

{ #category : 'imagenes' }
PanelEscenario class >> enGrises: unaImagen [
	"Convierte los colores de cada cuadro una sola vez al cargarlo, conservando su transparencia."

	| resultado |
	resultado := Form extent: unaImagen extent depth: 32.
	0 to: unaImagen height - 1 do: [ :y |
		0 to: unaImagen width - 1 do: [ :x |
			| pixel nivel |
			pixel := unaImagen colorAt: x @ y.
			nivel := (pixel red * 0.299) + (pixel green * 0.587) + (pixel blue * 0.114).
			resultado colorAt: x @ y put: ((Color gray: nivel) alpha: pixel alpha) ] ].
	^ resultado
]

{ #category : 'inicializacion' }
PanelEscenario >> configurarEstilo: unEstilo [

	estilo := unEstilo
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarMarco: unRectangulo fondo: unColor hundido: hundido en: canvas [

	(estilo at: #marco) value: unRectangulo value: unColor value: hundido value: canvas
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarTexto: unTexto centradoEn: unRectangulo escala: escala color: unColor en: canvas [

	(estilo at: #texto) valueWithArguments: { unTexto. unRectangulo. escala. unColor. canvas }
]

{ #category : 'interfaz' }
PanelEscenario >> mostrarEstado: unEstado [

	limitesPersonaje := unEstado at: #personaje.
	agachado := unEstado at: #agachado.
	obstaculos := unEstado at: #obstaculos.
	alturaSuelo := unEstado at: #suelo.
	puntos := unEstado at: #puntos.
	tiempoTranscurrido := unEstado at: #tiempo.
	self changed
]
