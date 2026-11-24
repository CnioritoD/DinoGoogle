"
Dibuja el personaje, los obstáculos, las monedas y los indicadores. Carga y guarda en caché los cuadros de los sprites.
"
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
		'tiempoTranscurrido',
		'monedas'
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

{ #category : 'imagenes' }
PanelEscenario class >> criaturaDeSerieAgachada: estaAgachada [

	| clave |
	clave := estaAgachada ifTrue: [ #criaturaAgachada ] ifFalse: [ #criaturaDePie ].
	^ self cacheSprites at: clave ifAbsentPut: [
		self dibujarCriaturaCon: (estaAgachada
			ifTrue: [ self pixelesCriaturaAgachada ]
			ifFalse: [ self pixelesCriaturaDePie ]) ]
]

{ #category : 'imagenes' }
PanelEscenario class >> cuadrosNombrados: unNombre tamanio: unTamanio [
	"Array con los cuadros de la animacion (uno solo si es una imagen fija), o nil si no hay
	 archivos. Se lee una sola vez; si cambiás un PNG, ejecutá PanelEscenario limpiarCacheSprites."

	^ self cacheSprites at: unNombre ifAbsentPut: [
		self leerCuadros: unNombre tamanio: unTamanio ]
]

{ #category : 'imagenes' }
PanelEscenario class >> dibujarCriaturaCon: filas [

	| lienzo colores |
	lienzo := FormCanvas extent: (filas first size @ filas size) * 2.
	colores := Dictionary newFrom: {
		$D -> (Color fromHexString: '20342B').
		$S -> (Color fromHexString: '365947').
		$G -> (Color fromHexString: '5D9461').
		$L -> (Color fromHexString: 'A0C878').
		$E -> (Color fromHexString: 'F3EACB').
		$O -> (Color fromHexString: 'D7A65F') }.
	filas doWithIndex: [ :fila :y |
		fila doWithIndex: [ :pixel :x |
			colores at: pixel ifPresent: [ :color |
				lienzo fillRectangle: (((x - 1) @ (y - 1) * 2) extent: 2 @ 2) color: color ] ] ].
	^ lienzo form
]

{ #category : 'imagenes' }
PanelEscenario class >> dinosaurioAgachado: estaAgachado tamanio: unTamanio tiempo: unosSegundos [
	"Cuadro que corresponde al estado del personaje (de pie o agachado) en ese momento del
	 juego. Los PNG opcionales reemplazan el dibujo de serie."

	| cuadros |
	cuadros := self
		cuadrosNombrados: (estaAgachado
			ifTrue: [ 'criatura-agachada' ]
			ifFalse: [ 'criatura-pie' ])
		tamanio: unTamanio.
	cuadros ifNil: [ ^ self criaturaDeSerieAgachada: estaAgachado ].
	^ cuadros at: ((unosSegundos * self framesPorSegundoSprites) floor \\ cuadros size) + 1
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
			Transcript nextPutAll: 'PanelEscenario: no pude leer '; nextPutAll: unArchivo basename; cr.
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
PanelEscenario class >> limpiarCacheSprites [

	CacheSprites := nil
]

{ #category : 'configuracion' }
PanelEscenario class >> numeroDe: unArchivo [
	"Numero que aparece en el nombre del archivo (frame3.png -> 3)."

	^ (unArchivo basenameWithoutExtension select: [ :each | each isDigit ]) asInteger
		ifNil: [ 0 ]
]

{ #category : 'imagenes' }
PanelEscenario class >> pixelesCriaturaAgachada [

	^ #(
		'................DDD...DDD....'
		'................DOD...DOD....'
		'...............DDDDDDDDDDD...'
		'......DDDDDDDDDDLLLLLLLLGD...'
		'......DGLLLLLLLGLLLLLLLLGD...'
		'...DDDDGGGGGGGGGGGGGEEEEGD...'
		'DDDDGGGGGLLLLLGGGGGGEEEDGD...'
		'DGGGGGGSSSSSSSSSSSGGEEEDGDD..'
		'DDDDDDDSSSSSSSSSSSGGEEEEGGD..'
		'......DDDDDDDDDDSSGGGGGGOGD..'
		'.......DOOD.DOODDDDGDDDDDDD..'
		'.......DDDD.DDDD..DDD........' )
]

{ #category : 'imagenes' }
PanelEscenario class >> pixelesCriaturaDePie [

	^ #(
		'......DDD...DDD...'
		'......DOD...DOD...'
		'.....DDDDDDDDDDD..'
		'.....DLLLLLLLLGD..'
		'.....DLLLLLLLLGD..'
		'.....DGGGGEEEEGD..'
		'.....DGGGGEEEDGD..'
		'.....DSSGGEEEDGDD.'
		'.....DSSGGEEEEGGD.'
		'.....DSSGLLLLLLGD.'
		'.....DSSGGGGOOODD.'
		'...DDDDDDDDDDDDD..'
		'.DDDGGGLLLLLGD....'
		'.GGGGGGLLLLLGD....'
		'.DDDSSSSGGGGSD....'
		'.DDDSSSSSSSSSD....'
		'...DSSSSSSSSSD....'
		'...DGGDDDDGGDD....'
		'...DGGD..DGGD.....'
		'...DOOD..DOOD.....'
		'...DDDD..DDDD.....' )
]

{ #category : 'initialization' }
PanelEscenario >> configurarEstilo: unEstilo [

	estilo := unEstilo
]

{ #category : 'initialization' }
PanelEscenario >> configurarTamanio: unTamanio [

	self extent: unTamanio + (0 @ 78).
	self clipSubmorphs: true
]

{ #category : 'drawing' }
PanelEscenario >> dibujarCactus: obstaculo en: canvas [

	| limites origen ancho alto izquierda derecha brazo unionIzquierda unionDerecha puntaDerecha vertices |
	limites := obstaculo at: #limites.
	origen := self position + (0 @ 60) + limites origin rounded.
	ancho := limites width rounded - 2.
	alto := limites height rounded - 1.
	izquierda := ancho // 3.
	derecha := ancho - izquierda.
	brazo := (ancho // 5) max: 4.
	unionIzquierda := alto * 5 // 8.
	unionDerecha := alto // 2.
	puntaDerecha := (alto // 4 + 1) min: (unionDerecha - brazo - 3).
	"Cada brazo conserva su grosor en píxeles aunque cambie el tamaño del obstáculo."
	vertices := {
		(izquierda + 2) @ 1. (derecha - 2) @ 1. derecha @ 3.
		derecha @ (unionDerecha - brazo). (ancho - brazo) @ (unionDerecha - brazo).
		(ancho - brazo) @ puntaDerecha. (ancho - 1) @ puntaDerecha.
		ancho @ (puntaDerecha + 1). ancho @ (unionDerecha - 2).
		(ancho - 2) @ unionDerecha. derecha @ unionDerecha. derecha @ alto.
		izquierda @ alto. izquierda @ unionIzquierda. 3 @ unionIzquierda.
		1 @ (unionIzquierda - 2). 1 @ (alto // 3 + 1). 2 @ (alto // 3).
		(1 + brazo) @ (alto // 3). (1 + brazo) @ (unionIzquierda - brazo).
		izquierda @ (unionIzquierda - brazo). izquierda @ 3 }.
	canvas drawPolygon: (vertices collect: [ :punto | origen + punto ])
		color: (Color fromHexString: '4E7F59') borderWidth: 1
		borderColor: (Color fromHexString: '233E35').
	canvas fillRectangle: ((origen + ((izquierda + 2) @ 4)) extent: 2 @ (alto - 6))
		color: (Color fromHexString: '91B67E').
	canvas fillRectangle: ((origen + ((derecha - 2) @ 4)) extent: 1 @ (alto - 5))
		color: (Color fromHexString: '37634B')
]

{ #category : 'drawing' }
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

{ #category : 'drawing' }
PanelEscenario >> dibujarIndicador: unTexto centradoEn: unRectangulo en: canvas [

	(estilo at: #texto) valueWithArguments: { unTexto. unRectangulo. 2. (estilo at: #luz). canvas }
]

{ #category : 'drawing' }
PanelEscenario >> dibujarIndicadoresEn: canvas [

	| puntaje tiempo |
	puntaje := (self position + (16 @ 300)) extent: 218 @ 34.
	tiempo := (self position + (406 @ 300)) extent: 218 @ 34.
	self dibujarMarco: puntaje fondo: (estilo at: #pantalla) hundido: true en: canvas.
	self dibujarMarco: tiempo fondo: (estilo at: #pantalla) hundido: true en: canvas.
	self dibujarIndicador: 'PUNTOS ', puntos printString
		centradoEn: puntaje en: canvas.
	self dibujarIndicador: 'TIEMPO ', tiempoTranscurrido floor printString, ' S'
		centradoEn: tiempo en: canvas
]

{ #category : 'drawing' }
PanelEscenario >> dibujarMarco: unRectangulo fondo: unColor hundido: hundido en: canvas [

	(estilo at: #marco) value: unRectangulo value: unColor value: hundido value: canvas
]

{ #category : 'drawing' }
PanelEscenario >> dibujarMonedasEn: canvas [
    monedas do: [ :limites |
        | origen |
        origen := self position + (0 @ 60) + limites origin rounded.

        canvas fillRectangle: ((origen + (3 @ 0)) extent: 8 @ 14)
            color: (Color fromHexString: 'F5C542').
        canvas fillRectangle: ((origen + (0 @ 3)) extent: 14 @ 8)
            color: (Color fromHexString: 'F5C542').
        canvas fillRectangle: ((origen + (5 @ 3)) extent: 3 @ 8)
            color: Color white
    ]
]

{ #category : 'drawing' }
PanelEscenario >> dibujarObstaculosEn: canvas [

	obstaculos do: [ :obstaculo |
		(obstaculo at: #vuela)
			ifTrue: [ self dibujarPajaro: obstaculo en: canvas ]
			ifFalse: [ self dibujarCactus: obstaculo en: canvas ] ]
]

{ #category : 'drawing' }
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

{ #category : 'drawing' }
PanelEscenario >> dibujarPersonajeEn: canvas [

	| origen imagen |
	origen := self position + (0 @ 60) + limitesPersonaje origin rounded.
	imagen := self class dinosaurioAgachado: agachado
		tamanio: limitesPersonaje extent tiempo: tiempoTranscurrido.
	canvas paintImage: imagen at: origen
]

{ #category : 'drawing' }
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

{ #category : 'drawing' }
PanelEscenario >> drawOn: canvas [

	(limitesPersonaje isNil or: [ estilo isNil ]) ifTrue: [ ^ super drawOn: canvas ].
	canvas clipBy: self bounds during: [ :lienzo |
		self dibujarMarco: self bounds fondo: (estilo at: #metal) hundido: false en: lienzo.
		self dibujarCieloEn: lienzo.
		self dibujarSueloEn: lienzo.
		lienzo clipBy: (self bounds insetBy: 7) during: [ :escena |
			self dibujarPersonajeEn: escena.
			self dibujarObstaculosEn: escena.
			self dibujarMonedasEn: escena ].
		self dibujarIndicadoresEn: lienzo ]
]

{ #category : 'interfaz' }
PanelEscenario >> mostrarEstado: unEstado [

	limitesPersonaje := unEstado at: #personaje.
	agachado := unEstado at: #agachado.
	obstaculos := unEstado at: #obstaculos.
	monedas := unEstado at: #monedas.
	alturaSuelo := unEstado at: #suelo.
	puntos := unEstado at: #puntos.
	tiempoTranscurrido := unEstado at: #tiempo.
	self changed
]
