import Foundation

struct Game {
    var players: [Player]
    var deck: Deck
    var currentPlayerIndex: Int
    var trumpSuit: Suit?
    var currentTrick: [(playerIndex: Int, card: Card)]
    var trickStarter: Int
    var roundNumber: Int
    var team1Score: Int
    var team2Score: Int
    var scoresHistory: [(team1: Int, team2: Int)]
    
    // Game state
    var gamePhase: GamePhase
    var lastTrickWinner: Int?
    var message: String?
    
    enum GamePhase {
        case waitingToStart
        case playing
        case trickComplete
        case roundComplete
    }
    
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
        scoresHistory = []
        gamePhase = .waitingToStart
        lastTrickWinner = nil
        message = nil
    }
    
    var currentPlayer: Player {
        players[currentPlayerIndex]
    }
    
    var leadSuit: Suit? {
        guard let firstCard = currentTrick.first else { return nil }
        return firstCard.card.suit
    }
    
    mutating func startNewRound() {
        // Clear previous state
        for i in 0..<4 {
            players[i].hand = []
            players[i].score = 0
        }
        
        deck.createDeck()
        deck.shuffle()
        
        // Deal 10 cards to each player
        for i in 0..<4 {
            let cards = deck.deal(count: 10)
            players[i].receiveCards(cards)
        }
        
        // Determine trump suit (last card from deck)
        if let trumpCard = deck.draw() {
            trumpSuit = trumpCard.suit
            // Put trump card back to last player (they see it)
            players[3].hand.append(trumpCard)
        }
        
        currentTrick = []
        trickStarter = 0
        currentPlayerIndex = 0
        gamePhase = .playing
        message = "Ronda \(roundNumber) - Triunfo: \(trumpSuit?.symbol ?? "")"
    }
    
    mutating func playCard(card: Card, by playerIndex: Int) -> Bool {
        // Verify it's valid move
        if !isValidMove(card: card, by: playerIndex) {
            return false
        }
        
        // Remove card from player
        if let cardIndex = players[playerIndex].hand.firstIndex(where: { $0.id == card.id }) {
            _ = players[playerIndex].playCard(at: cardIndex)
        }
        
        // Add to trick
        currentTrick.append((playerIndex: playerIndex, card: card))
        
        // Check if trick is complete
        if currentTrick.count == 4 {
            gamePhase = .trickComplete
            resolveTrick()
        } else {
            // Move to next player
            currentPlayerIndex = (currentPlayerIndex + 1) % 4
        }
        
        return true
    }
    
    mutating func resolveTrick() {
        let leadSuit = currentTrick[0].card.suit
        
        // Find winner
        var winnerIndex = 0
        var highestTrumpValue = -1
        var highestLeadValue = -1
        
        for (index, trickCard) in currentTrick.enumerated() {
            let cardValue = trickCard.card.rank.rawValue
            
            if trickCard.card.suit == trumpSuit {
                if cardValue > highestTrumpValue {
                    highestTrumpValue = cardValue
                    winnerIndex = index
                }
            } else if trickCard.card.suit == leadSuit {
                if cardValue > highestLeadValue && highestTrumpValue == -1 {
                    highestLeadValue = cardValue
                    winnerIndex = index
                }
            }
        }
        
        let actualWinner = currentTrick[winnerIndex].playerIndex
        lastTrickWinner = actualWinner
        
        // Calculate points
        let points = currentTrick.reduce(0) { $0 + $1.card.rank.points }
        
        // Add to winner's team
        if actualWinner % 2 == 0 { // Team 1 (players 0 and 2)
            players[actualWinner].score += points
        } else { // Team 2 (players 1 and 3)
            players[actualWinner].score += points
        }
        
        message = "¡Baza para \(players[actualWinner].name)! +\(points) puntos"
        
        // Prepare for next trick
        currentTrick = []
        currentPlayerIndex = actualWinner
        trickStarter = actualWinner
        
        // Check if round is complete (all cards played)
        if players[0].hand.isEmpty {
            gamePhase = .roundComplete
            finishRound()
        } else {
            gamePhase = .playing
        }
    }
    
    mutating func finishRound() {
        // Add round scores to total
        let team1RoundScore = players[0].score + players[2].score
        let team2RoundScore = players[1].score + players[3].score
        
        team1Score += team1RoundScore
        team2Score += team2RoundScore
        
        scoresHistory.append((team1: team1RoundScore, team2: team2RoundScore))
        
        message = "Fin de ronda - Equipo 1: \(team1RoundScore) | Equipo 2: \(team2RoundScore)"
        
        // Check if game is over (first to 100 or similar)
        if team1Score >= 100 || team2Score >= 100 {
            message = team1Score > team2Score ? "¡GANASTE! 🎉" : "¡GANÓ CPU! 🤖"
        } else {
            // Start new round
            roundNumber += 1
            message = "Nueva ronda \(roundNumber)"
        }
    }
    
    func isValidMove(card: Card, by playerIndex: Int) -> Bool {
        // Human can play any card when leading
        if currentTrick.isEmpty {
            return true
        }
        
        let lead = currentTrick[0].card.suit
        let hand = players[playerIndex].hand
        
        // Check if has lead suit
        let hasLead = hand.contains { $0.suit == lead }
        let hasTrump = trumpSuit != nil && hand.contains { $0.suit == trumpSuit }
        
        // Must follow lead suit if possible
        if hasLead {
            return card.suit == lead
        }
        
        // If no lead suit, can play trump or any other
        return true
    }
    
    mutating func cpuPlay() {
        guard currentPlayer.type == .cpu else { return }
        
        let difficulty: TuteAI.Difficulty = .medium
        
        // Get valid cards
        let validCards = getValidCards()
        
        guard !validCards.isEmpty else { return }
        
        // Let AI choose
        if let selectedCard = TuteAI.selectCard(
            hand: players[currentPlayerIndex].hand,
            leadSuit: leadSuit,
            trumpSuit: trumpSuit,
            trick: currentTrick.map { $0.card },
            difficulty: difficulty
        ) {
            _ = playCard(card: selectedCard, by: currentPlayerIndex)
        }
    }
    
    func getValidCards() -> [Card] {
        return GameLogic.validMoves(
            hand: players[currentPlayerIndex].hand,
            leadSuit: leadSuit,
            trumpSuit: trumpSuit
        )
    }
}
