import Foundation

struct Game: Codable {
    var players: [Player]
    var deck: Deck
    var currentPlayerIndex: Int
    var trumpSuit: Suit?
    var currentTrick: [Card]
    var trickStarter: Int
    var roundNumber: Int
    var team1Score: Int
    var team2Score: Int
    
    init() {
        players = [
            Player(name: "Tú", type: .human),
            Player(name: "CPU 1", type: .cpu),
            Player(name: "CPU 2", type: .cpu),
            Player(name: "CPU 3", type: .cpu)
        ]
        deck = Deck()
        currentPlayerIndex = 0
        trumpSuit = nil
        currentTrick = []
        trickStarter = 0
        roundNumber = 1
        team1Score = 0
        team2Score = 0
    }
    
    var currentPlayer: Player {
        players[currentPlayerIndex]
    }
    
    mutating func startNewRound() {
        deck.createDeck()
        deck.shuffle()
        
        // Deal 10 cards to each player
        for i in 0..<4 {
            let cards = deck.deal(count: 10)
            players[i].receiveCards(cards)
        }
        
        // Determine trump suit (last card)
        if let trumpCard = deck.draw() {
            trumpSuit = trumpCard.suit
        }
        
        currentTrick = []
        trickStarter = 0
    }
    
    mutating func playCard(card: Card, by playerIndex: Int) {
        if let playerIndexInPlayers = players.firstIndex(where: { $0.id == players[playerIndex].id }) {
            if let cardIndex = players[playerIndexInPlayers].hand.firstIndex(where: { $0.id == card.id }) {
                _ = players[playerIndexInPlayers].playCard(at: cardIndex)
            }
        }
        currentTrick.append(card)
    }
    
    mutating func nextPlayer() {
        currentPlayerIndex = (currentPlayerIndex + 1) % 4
    }
}
