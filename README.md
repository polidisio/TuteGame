# TuteGame 🃏

Juego de cartas Tute español para iOS. mult-iplayer local (2-4 jugadores) con IA.

## Descripción

- **Tipo:** App iOS (SwiftUI)
- **Modelo:** Pago único ($2.99)
- **Jugadores:** 2-4 (local)
- **IA:** Oponente automático

## Reglas del Juego

- Baraja española de 40 cartas
- 4 palos: Oros, Copas, Espadas, Bastos
- Cartas por palo: 1-7, Sota, Caballo, Rey
- Triunfos: El 7 del palo elegido + todas las cartas del mismo palo

## Puntuación

| Carta | Puntos |
|-------|--------|
| 1 (As) | 11 |
| 3 | 10 |
| Rey | 4 |
| Caballo | 3 |
| Sota | 2 |
| 7, 6, 5, 4, 2 | 0 |

## Estructura

```
TuteGame/
├── Sources/
│   ├── App/
│   │   └── TuteGameApp.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── GameView.swift
│   │   ├── HandView.swift
│   │   ├── CardView.swift
│   │   └── ScoreView.swift
│   ├── Models/
│   │   ├── Card.swift
│   │   ├── Player.swift
│   │   ├── Game.swift
│   │   └── Deck.swift
│   ├── AI/
│   │   └── TuteAI.swift
│   └── Utilities/
│       ├── GameLogic.swift
│       └── ScoreManager.swift
└── Resources/
    ├── Assets.xcassets/
    └── Info.plist
```

## Dependencias

- No requiere dependencias externas
- SwiftUI puro

## Estimación

- MVP: 2-3 semanas
- Multijugador: 1 semana
- IA avanzada: 1 semana
- Total: ~1 mes

## Notas

- Juego clásico español
- Ideal para familia/amigos
- Diferenciador: IA inteligente, UI bonita
