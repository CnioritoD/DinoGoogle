Class {
	#name : 'PanelEscenario',
	#superclass : 'Morph',
	#instVars : [
		'sistema',
		'juego',
		'fuenteIndicadores'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'inicializacion' }
PanelEscenario >> configurarSistema: unSistema juego: unJuego [

	sistema := unSistema.
	juego := unJuego.
	fuenteIndicadores := LogicalFont familyName: 'Source Sans Pro' pointSize: 14.
	self extent: juego tamanioEscenario + (0 @ 78).
	self clipSubmorphs: true
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarCieloEn: canvas [

	| origen |
	origen := self position.
	canvas fillOval: ((origen + (499 @ 26)) extent: 65 @ 65)
		color: Color white borderWidth: 3 borderColor: Color black.
	canvas fillOval: ((origen + (420 @ 120)) extent: 35 @ 12)
		color: Color white borderWidth: 1 borderColor: Color black.
	canvas line: origen + (434 @ 110) to: origen + (441 @ 120) width: 1 color: Color black.
	canvas line: origen + (434 @ 110) to: origen + (430 @ 120) width: 1 color: Color black.
	canvas line: origen + (452 @ 124) to: origen + (465 @ 119) width: 1 color: Color black.
	canvas line: origen + (465 @ 119) to: origen + (454 @ 130) width: 1 color: Color black.
	canvas line: origen + (439 @ 142) to: origen + (430 @ 131) width: 1 color: Color black.
	canvas line: origen + (439 @ 142) to: origen + (445 @ 131) width: 1 color: Color black
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarIndicadoresEn: canvas [

	| tiempo puntaje |
	tiempo := 'Time: ', juego tiempoTranscurrido floor printString, ' s'.
	puntaje := 'Score: ', juego puntaje printString.
	canvas drawString: puntaje from: 1 to: puntaje size
		at: self position + (22 @ 302) font: fuenteIndicadores color: Color black.
	canvas drawString: tiempo from: 1 to: tiempo size
		at: self position + (512 @ 302) font: fuenteIndicadores color: Color black
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarCactus: obstaculo en: canvas [

	| silueta verde luz borde origen escala vertices |
	silueta := {
		8 @ 1. 12 @ 1. 13 @ 2. 13 @ 16. 16 @ 16. 16 @ 9.
		19 @ 9. 19 @ 18. 17 @ 20. 13 @ 20. 13 @ 27. 7 @ 27.
		7 @ 17. 3 @ 17. 1 @ 15. 1 @ 7. 4 @ 7. 4 @ 13.
		7 @ 13. 7 @ 2 }.
	verde := Color r: 0.24 g: 0.62 b: 0.34.
	luz := Color r: 0.43 g: 0.77 b: 0.46.
	borde := Color r: 0.1 g: 0.25 b: 0.17.
	origen := self position + (0 @ 60) + obstaculo posicion rounded.
	escala := obstaculo tamanio / (20 @ 28).
	vertices := silueta collect: [ :punto | origen + (punto * escala) rounded ].
	canvas drawPolygon: vertices color: verde borderWidth: 2 borderColor: borde.
	canvas
		line: origen + ((9 @ 4) * escala) rounded
		to: origen + ((9 @ 24) * escala) rounded
		width: 1
		color: luz
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarObstaculosEn: canvas [

	juego obstaculos do: [ :obstaculo |
		obstaculo esPajaro
			ifTrue: [ self dibujarPajaro: obstaculo en: canvas ]
			ifFalse: [ self dibujarCactus: obstaculo en: canvas ] ]
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarPajaro: pajaro en: canvas [
	"El dibujo ocupa la caja de 46 x 22 del pajaro; el ala sube y baja (aletea)."

	| origen cuerpo ala colorCuerpo colorAla borde |
	origen := self position + (0 @ 60) + pajaro posicion rounded.
	cuerpo := {
		0 @ 10. 11 @ 6. 17 @ 8. 31 @ 9. 45 @ 11. 31 @ 14. 18 @ 15. 11 @ 13 }.
	ala := pajaro alaArriba
		ifTrue: [ { 19 @ 9. 25 @ 0. 34 @ 2. 30 @ 9 } ]
		ifFalse: [ { 19 @ 14. 25 @ 21. 34 @ 19. 30 @ 14 } ].
	colorCuerpo := Color r: 0.45 g: 0.45 b: 0.5.
	colorAla := Color r: 0.68 g: 0.68 b: 0.74.
	borde := Color r: 0.12 g: 0.12 b: 0.16.
	canvas drawPolygon: (cuerpo collect: [ :punto | origen + punto ])
		color: colorCuerpo borderWidth: 2 borderColor: borde.
	canvas drawPolygon: (ala collect: [ :punto | origen + punto ])
		color: colorAla borderWidth: 2 borderColor: borde.
	canvas fillRectangle: ((origen + (8 @ 8)) extent: 2 @ 2) color: Color white
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarPersonajeAgachadoEn: canvas [

	| origen silueta sombra |
	origen := self position + (0 @ 60) + juego personaje posicion rounded.
	silueta := {
		0 @ 8. 6 @ 6. 27 @ 6. 28 @ 2. 41 @ 2. 41 @ 8. 35 @ 8. 35 @ 11.
		40 @ 11. 40 @ 13. 30 @ 13. 30 @ 19. 27 @ 19. 27 @ 23. 22 @ 23.
		22 @ 18. 20 @ 18. 20 @ 22. 17 @ 22. 17 @ 23. 12 @ 23. 12 @ 16.
		5 @ 15. 2 @ 12 }.
	canvas drawPolygon: (silueta collect: [ :punto | origen + punto ])
		color: (Color r: 0.55 g: 0.81 b: 0.26)
		borderWidth: 2 borderColor: (Color r: 0.12 g: 0.23 b: 0.15).
	sombra := Color r: 0.3 g: 0.55 b: 0.21.
	canvas fillRectangle: ((origen + (10 @ 10)) extent: 12 @ 3) color: sombra.
	canvas fillRectangle: ((origen + (29 @ 3)) extent: 8 @ 2)
		color: (Color r: 0.74 g: 0.92 b: 0.43).
	canvas fillRectangle: ((origen + (33 @ 4)) extent: 3 @ 3) color: Color black
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarPersonajeEn: canvas [

	| origen silueta sombra imagen |
	origen := self position + (0 @ 60) + juego personaje posicion rounded.
	"Si hay un PNG en la carpeta de sprites se usa; si no, se dibuja por codigo."
	imagen := Sprites dinosaurioDe: juego personaje.
	imagen ifNotNil: [ ^ canvas paintImage: imagen at: origen ].
	juego personaje estaAgachado ifTrue: [ ^ self dibujarPersonajeAgachadoEn: canvas ].
	silueta := {
		21 @ 1. 33 @ 1. 33 @ 3. 35 @ 3. 35 @ 13. 28 @ 13.
		28 @ 17. 34 @ 17. 34 @ 21. 27 @ 21. 27 @ 31. 24 @ 31.
		24 @ 37. 28 @ 37. 28 @ 41. 20 @ 41. 20 @ 34. 16 @ 34.
		16 @ 38. 19 @ 38. 19 @ 41. 12 @ 41. 12 @ 32. 8 @ 30.
		8 @ 27. 4 @ 27. 4 @ 23. 1 @ 23. 1 @ 15. 4 @ 15.
		4 @ 20. 9 @ 20. 9 @ 22. 13 @ 22. 13 @ 18. 17 @ 18.
		17 @ 13. 19 @ 13. 19 @ 3. 21 @ 3 }.
	canvas drawPolygon: (silueta collect: [ :punto | origen + punto ])
		color: (Color r: 0.55 g: 0.81 b: 0.26)
		borderWidth: 2 borderColor: (Color r: 0.12 g: 0.23 b: 0.15).

	sombra := Color r: 0.3 g: 0.55 b: 0.21.
	canvas fillRectangle: ((origen + (12 @ 26)) extent: 11 @ 4) color: sombra.
	canvas fillRectangle: ((origen + (23 @ 3)) extent: 8 @ 2)
		color: (Color r: 0.74 g: 0.92 b: 0.43).
	canvas fillRectangle: ((origen + (25 @ 6)) extent: 3 @ 3) color: Color black.
	canvas fillRectangle: ((origen + (31 @ 11)) extent: 3 @ 1) color: sombra
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarSueloEn: canvas [

	| borde |
	borde := self position + (4 @ (juego alturaSuelo + 60)).
	canvas fillRectangle: (borde extent: (self width - 8) @ 4) color: Color black
]

{ #category : 'dibujo' }
PanelEscenario >> drawOn: canvas [

	juego ifNil: [ ^ super drawOn: canvas ].
	canvas clipBy: self bounds during: [ :lienzo |
		lienzo drawRectangle: self bounds color: Color white borderWidth: 4 borderColor: Color black.
		self dibujarCieloEn: lienzo.
		self dibujarSueloEn: lienzo.
		self dibujarPersonajeEn: lienzo.
		self dibujarObstaculosEn: lienzo.
		self dibujarIndicadoresEn: lienzo ]
]

{ #category : 'eventos' }
PanelEscenario >> handlesKeyboard: unEvento [

	^ juego notNil and: [ juego estaEnCurso ]
]

{ #category : 'eventos' }
PanelEscenario >> handlesMouseDown: unEvento [

	^ juego notNil and: [ juego estaEnCurso ]
]

{ #category : 'eventos' }
PanelEscenario >> esFlechaAbajo: unEvento [

	^ unEvento keyCharacter = Character arrowDown
		or: [ unEvento keyValue = 31 or: [ unEvento key = KeyboardKey down ] ]
]

{ #category : 'eventos' }
PanelEscenario >> keyDown: unEvento [

	unEvento keyCharacter = Character space ifTrue: [
		sistema solicitarSalto.
		unEvento wasHandled: true ].
	(self esFlechaAbajo: unEvento) ifTrue: [
		sistema solicitarAgacharse.
		unEvento wasHandled: true ]
]

{ #category : 'eventos' }
PanelEscenario >> keyUp: unEvento [

	(self esFlechaAbajo: unEvento) ifTrue: [
		sistema solicitarPararse.
		unEvento wasHandled: true ]
]

{ #category : 'eventos' }
PanelEscenario >> mouseDown: unEvento [

	unEvento redButtonPressed ifTrue: [
		self tomarFoco.
		sistema solicitarSalto ]
]

{ #category : 'eventos' }
PanelEscenario >> tomarFoco [

	self world ifNotNil: [ :mundo | mundo activeHand newKeyboardFocus: self ]
]
