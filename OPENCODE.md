# Contexto: TuteGame

## Objetivo
Crear un juego de cartas Tute español para iOS con SwiftUI.

## Stack
- **Framework:** SwiftUI
- **iOS:** 16.0+
- **PM:** XcodeGen
- **Dependencies:** Ninguna (puro SwiftUI)

## Estructura del Proyecto
```
TuteGame/
├── Sources/
│   ├── App/TuteGameApp.swift        ← Entry point
│   ├── Views/
│   │   ├── ContentView.swift        ← Pantalla principal
│   │   ├── GameView.swift          ← Vista del juego
│   │   ├── HandView.swift          ← Mano del jugador
│   │   ├── CardView.swift          ← Carta individual
│   │   └── ScoreView.swift         ← Marcador
│   ├── Models/
│   │   ├── Card.swift              ← Modelo carta
│   │   ├── Player.swift            ← Modelo jugador
│   │   ├── Game.swift              ← Estado del juego
│   │   └── Deck.swift              ← Baraja
│   ├── AI/
│   │   └── TuteAI.swift            ← Lógica IA
│   └── Utilities/
│       ├── GameLogic.swift          ← Reglas del juego
│       └── ScoreManager.swift       ← Puntuación
└── Resources/
```

## Estado Actual
- ⏳ Por crear estructura básica

## Reglas del Tute
- Baraja española 40 cartas
- 4 palos: Oros, Copas, Espadas, Bastos
- Cartas: 1-7, Sota, Caballo, Rey
- Triunfos: 7 del palo + todas las cartas de ese palo

## Puntuación
- As (1): 11 puntos
- Tres: 10 puntos
- Rey: 4 puntos
- Caballo: 3 puntos
- Sota: 2 puntos
- Resto: 0 puntos

## Siguientes Pasos
1. Crear modelos Card, Player, Deck
2. Implementar barajeo y reparto
3. Crear CardView con assets
4. Implementar GameView
5. Añadir lógica de bazas
6. Implementar IA básica
7. Añadir puntuación

## Notas
- Modelo: Pago único ($2.99)
- Multijugador local (2-4)
- IA para jugar solo
