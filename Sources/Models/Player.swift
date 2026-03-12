import Foundation

enum PlayerType: String, Codable {
    case human
    case cpu
}

struct Player: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: PlayerType
    var hand: [Card]
    var score: Int
    
    init(name: String, type: PlayerType) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.hand = []
        self.score = 0
    }
    
    var isHuman: Bool {
        type == .human
    }
    
    mutating func receiveCards(_ cards: [Card]) {
        hand.append(contentsOf: cards)
        hand.sort { $0.rank.rawValue > $1.rank.rawValue }
    }
    
    mutating func playCard(at index: Int) -> Card? {
        guard index >= 0 && index < hand.count else { return nil }
        return hand.remove(at: index)
    }
    
    mutating func addScore(_ points: Int) {
        score += points
    }
}
