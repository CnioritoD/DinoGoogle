Class {
	#name : 'SistemaControles',
	#superclass : 'Object',
	#instVars : [
		'coordinador',
		'panel'
	],
	#category : 'DinoGoogle-Interfaz',
	#package : 'DinoGoogle',
	#tag : 'Interfaz'
}

{ #category : 'inicializacion' }
SistemaControles >> configurarCoordinador: unCoordinador panel: unPanel [

	coordinador := unCoordinador.
	panel := unPanel.
	panel configurarSistema: self
]

{ #category : 'interfaz' }
SistemaControles >> montarEn: unContenedor posicion: unaPosicion [

	unContenedor addMorph: panel.
	panel position: unaPosicion
]

{ #category : 'interfaz' }
SistemaControles >> mostrarPuntaje: unPuntaje estado: unEstado [

	panel mostrarPuntaje: unPuntaje estado: unEstado
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

	coordinador guardarResultado: panel nick.
	coordinador prepararSiguientePartida
]

{ #category : 'acciones' }
SistemaControles >> solicitarSalida [

	coordinador guardarResultado: panel nick.
	coordinador salir
]
