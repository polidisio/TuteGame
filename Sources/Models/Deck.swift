import Foundation

struct Deck {
    private(set) var cards: [Card] = []
    
    init() {
        createDeck()
    }
    
    mutating func createDeck() {
        cards = []
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                cards.append(Card(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func deal(count: Int) -> [Card] {
        guard cards.count >= count else { return [] }
        return Array(cards.removeFirst(count))
    }
    
    mutating func draw() -> Card? {
        cards.popLast()
    }
    
    var isEmpty: Bool {
        cards.isEmpty
    }
    
    var count: Int {
        cards.count
    }
}
