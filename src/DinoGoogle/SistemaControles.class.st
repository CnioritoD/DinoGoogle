Class {
	#name : 'SistemaControles',
	#superclass : 'Object',
	#instVars : [
		'coordinador',
		'panel',
		'entrada'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'inicializacion' }
SistemaControles >> configurarCoordinador: unCoordinador panel: unPanel [

	coordinador := unCoordinador.
	panel := unPanel.
	entrada := EntradaControles new.
	entrada
		configurarSistema: self
		extension: panel extent
		limitesCuadroFinal: panel limitesCuadroFinalLocales
]

{ #category : 'inicializacion' }
SistemaControles >> configurarEstilo: unEstilo [

	panel configurarEstilo: unEstilo.
	entrada configurarEstilo: unEstilo
]

{ #category : 'interfaz' }
SistemaControles >> montarEn: unContenedor posicion: unaPosicion [

	unContenedor addMorph: panel.
	panel position: unaPosicion.
	entrada montarEn: unContenedor posicion: unaPosicion
]

{ #category : 'interfaz' }
SistemaControles >> mostrarPuntaje: unPuntaje estado: unEstado [

	panel mostrarPuntaje: unPuntaje estado: unEstado.
	panel visible: unEstado ~= #enCurso.
	entrada mostrarEstado: unEstado
]

{ #category : 'interfaz' }
SistemaControles >> mostrarResultados: unaColeccion [

	panel mostrarResultados: unaColeccion
]

{ #category : 'interfaz' }
SistemaControles >> panel [

	^ panel
]

{ #category : 'acciones' }
SistemaControles >> solicitarInicio [

	coordinador iniciarPartida
]

{ #category : 'acciones' }
SistemaControles >> solicitarReinicio [

	coordinador guardarResultado: entrada nick.
	coordinador reiniciarPartida
]

{ #category : 'acciones' }
SistemaControles >> solicitarSalida [

	coordinador guardarResultado: entrada nick.
	coordinador salir
]
