import Foundation

enum Suit: String, CaseIterable, Codable {
    case oros = "oros"
    case copas = "copas"
    case espadas = "espadas"
    case bastos = "bastos"
    
    var symbol: String {
        switch self {
        case .oros: return "🪙"
        case .copas: return "🍷"
        case .espadas: return "⚔️"
        case .bastos: return "🪵"
        }
    }
}

enum Rank: Int, CaseIterable, Codable {
    case uno = 1
    case dos = 2
    case tres = 3
    case cuatro = 4
    case cinco = 5
    case seis = 6
    case siete = 7
    case sota = 8
    case caballo = 9
    case rey = 10
    
    var symbol: String {
        switch self {
        case .uno: return "A"
        case .dos: return "2"
        case .tres: return "3"
        case .cuatro: return "4"
        case .cinco: return "5"
        case .seis: return "6"
        case .siete: return "7"
        case .sota: return "J"
        case .caballo: return "Q"
        case .rey: return "K"
        }
    }
    
    var points: Int {
        switch self {
        case .uno: return 11
        case .tres: return 10
        case .rey: return 4
        case .caballo: return 3
        case .sota: return 2
        default: return 0
        }
    }
}

struct Card: Identifiable, Codable, Equatable {
    let id: UUID
    let suit: Suit
    let rank: Rank
    
    init(suit: Suit, rank: Rank) {
        self.id = UUID()
        self.suit = suit
        self.rank = rank
    }
    
    var isTrump: Bool {
        rank == .siete
    }
    
    var displayName: String {
        "\(rank.symbol) \(suit.symbol)"
    }
}
