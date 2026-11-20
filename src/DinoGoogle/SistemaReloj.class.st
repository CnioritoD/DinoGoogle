Class {
    #name : 'SistemaReloj',
    #superclass : 'Morph',
    #instVars : [
        'coordinador',
        'ultimoTiempo'
    ],
    #category : 'DinoGoogle-Modelo',
    #package : 'DinoGoogle',
    #tag : 'Modelo'
}

"Iniciar la clase"
{ #category : 'initialization' }
SistemaReloj >> initialize [
    super initialize.
    coordinador := nil.
    ultimoTiempo := nil.
    self extent: 1 @ 1.
    self color: Color transparent
]


"Config del coordinador"
{ #category : 'accessing' }
SistemaReloj >> configurarCoordinador: unCoordinador [
    "Guardar la referencia al coordinador."
    coordinador := unCoordinador
]

"Frecuencia de actualización del reloj"
{ #category : 'stepping' }
SistemaReloj >> stepTime [
    "En milisegundos, cambien a lo que mejor queda."
    ^ 20
]


"Reloj"
{ #category : 'stepping' }
SistemaReloj >> iniciar [
    ultimoTiempo := Time millisecondClockValue.
    self startStepping
]

"stop el reloj"
{ #category : 'stepping' }
SistemaReloj >> detener [
    self stopStepping.
    ultimoTiempo := nil
]


"Actualizar el tiempo"
{ #category : 'stepping' }
SistemaReloj >> step [
    | ahora segundos |

    "Comprueba que existan"
    coordinador ifNil: [ ^ self ].
    ultimoTiempo ifNil: [ ^ self ].
    "Instante actual en milisegundos."
    ahora := Time millisecondClockValue.
    segundos := (ahora - ultimoTiempo) / 1000.0.
    ultimoTiempo := ahora.
    "Comunica al coordinador cuánto tiempo transcurrió."
    coordinador actualizar: segundos
]