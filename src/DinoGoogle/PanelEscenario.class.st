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
PanelEscenario >> dibujarObstaculosEn: canvas [

	| silueta verde luz borde |
	silueta := {
		8 @ 1. 12 @ 1. 13 @ 2. 13 @ 16. 16 @ 16. 16 @ 9.
		19 @ 9. 19 @ 18. 17 @ 20. 13 @ 20. 13 @ 27. 7 @ 27.
		7 @ 17. 3 @ 17. 1 @ 15. 1 @ 7. 4 @ 7. 4 @ 13.
		7 @ 13. 7 @ 2 }.
	verde := Color r: 0.24 g: 0.62 b: 0.34.
	luz := Color r: 0.43 g: 0.77 b: 0.46.
	borde := Color r: 0.1 g: 0.25 b: 0.17.
	juego obstaculos do: [ :obstaculo |
		| origen escala vertices |
		origen := self position + (0 @ 60) + obstaculo posicion rounded.
		escala := obstaculo tamanio / (20 @ 28).
		vertices := silueta collect: [ :punto | origen + (punto * escala) rounded ].
		canvas drawPolygon: vertices color: verde borderWidth: 2 borderColor: borde.
		canvas
			line: origen + ((9 @ 4) * escala) rounded
			to: origen + ((9 @ 24) * escala) rounded
			width: 1
			color: luz ]
]

{ #category : 'dibujo' }
PanelEscenario >> dibujarPersonajeEn: canvas [

	| origen silueta sombra |
	origen := self position + (0 @ 60) + juego personaje posicion rounded.
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
PanelEscenario >> keyDown: unEvento [

	unEvento keyCharacter = Character space ifTrue: [
		sistema solicitarSalto.
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
