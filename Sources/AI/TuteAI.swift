import Foundation

struct TuteAI {
    
    enum Difficulty: Int, CaseIterable {
        case easy = 0
        case medium = 1
        case hard = 2
        case expert = 3
        
        var name: String {
            switch self {
            case .easy: return "Fácil"
            case .medium: return "Medio"
            case .hard: return "Difícil"
            case .expert: return "Experto"
            }
        }
    }
    
    private static var playedCards: [Card] = []
    
    static func resetPlayedCards() {
        playedCards = []
    }
    
    static func recordPlayedCard(_ card: Card) {
        playedCards.append(card)
    }
    
    static func selectCard(
        hand: [Card],
        leadSuit: Suit?,
        trumpSuit: Suit?,
        trick: [Card],
        difficulty: Difficulty = .medium,
        gamePhase: Game.GamePhase = .playing
    ) -> Card? {
        
        // Record played cards for counting
        for card in trick {
            recordPlayedCard(card)
        }
        
        let validMoves = GameLogic.validMoves(hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit)
        guard !validMoves.isEmpty else { return nil }
        
        switch difficulty {
        case .easy:
            return randomMove(validMoves)
        case .medium:
            return mediumStrategy(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick)
        case .hard:
            return hardStrategy(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick)
        case .expert:
            return expertStrategy(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick, gamePhase: gamePhase)
        }
    }
    
    private static func randomMove(_ moves: [Card]) -> Card {
        return moves.randomElement()!
    }
    
    private static func mediumStrategy(
        validMoves: [Card],
        hand: [Card],
        leadSuit: Suit?,
        trumpSuit: Suit?,
        trick: [Card]
    ) -> Card {
        
        // If leading (first to play)
        if leadSuit == nil {
            return playBestLeadingCard(validMoves: validMoves, hand: hand, trumpSuit: trumpSuit)
        }
        
        // If following
        if !trick.isEmpty {
            return playBestFollowingCard(validMoves: validMoves, hand: hand, leadSuit: leadSuit!, trumpSuit: trumpSuit, trick: trick)
        }
        
        return validMoves.randomElement()!
    }
    
    private static func hardStrategy(
        validMoves: [Card],
        hand: [Card],
        leadSuit: Suit?,
        trumpSuit: Suit?,
        trick: [Card]
    ) -> Card {
        
        let cardCount = hand.count
        
        // Count cards remaining in each suit
        let remainingCounts = countRemainingCards(hand: hand)
        
        // Early game (many cards left) - preserve high cards
        if cardCount > 7 {
            let lowCards = validMoves.filter { $0.rank.rawValue <= 4 }
            if !lowCards.isEmpty {
                return lowCards.randomElement()!
            }
        }
        
        // Mid game
        if cardCount > 3 && cardCount <= 7 {
            // Check if partner is winning
            if isPartnerWinning(trick: trick, leadSuit: leadSuit!) {
                // Save high cards, play low
                return validMoves.sorted { $0.rank.rawValue < $1.rank.rawValue }.first!
            }
        }
        
        // Late game (few cards left) - play to win
        if cardCount <= 3 {
            return playToWin(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick)
        }
        
        return mediumStrategy(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick)
    }
    
    private static func expertStrategy(
        validMoves: [Card],
        hand: [Card],
        leadSuit: Suit?,
        trumpSuit: Suit?,
        trick: [Card],
        gamePhase: Game.GamePhase
    ) -> Card {
        
        let cardCount = hand.count
        
        // Check for "tute" (4 points worth cards) situation
        if let tuteCard = findTuteOpportunity(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit) {
            return tuteCard
        }
        
        // Defense: if opponent is close to winning
        if isOpponentWinningSoon(hand: hand, trumpSuit: trumpSuit) {
            return playDefensive(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit)
        }
        
        // Attack: if we are close to winning
        if canWinGame(hand: hand, trumpSuit: trumpSuit) {
            return playAggressive(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick)
        }
        
        // Count cards to know what's left
        let remainingCounts = countRemainingCards(hand: hand)
        
        // If opponent has no trump, and we have high trump -> punish
        if let trump = trumpSuit, let lead = leadSuit {
            if !trick.contains(where: { $0.suit == trump }) && !hand.contains(where: { $0.suit == trump && $0.rank.rawValue >= 7 }) {
                // Opponent might be out of trump
                let leadSuitCards = hand.filter { $0.suit == lead }
                if let highLead = leadSuitCards.max(by: { $0.rank.rawValue < $1.rank.rawValue }) {
                    return highLead
                }
            }
        }
        
        return hardStrategy(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick)
    }
    
    // MARK: - Helper Functions
    
    private static func playBestLeadingCard(validMoves: [Card], hand: [Card], trumpSuit: Suit?) -> Card {
        // Save trumps for later if possible
        if let trump = trumpSuit {
            let nonTrumps = validMoves.filter { $0.suit != trump }
            if !nonTrumps.isEmpty {
                // Play medium card from non-trumps
                let sorted = nonTrumps.sorted { $0.rank.rawValue < $1.rank.rawValue }
                return sorted[min(sorted.count / 2, sorted.count - 1)]
            }
            // Only have trumps, play lowest
            return validMoves.sorted { $0.rank.rawValue < $1.rank.rawValue }.first!
        }
        
        // No trump known, play medium card
        let sorted = validMoves.sorted { $0.rank.rawValue < $1.rank.rawValue }
        return sorted[min(sorted.count / 2, sorted.count - 1)]
    }
    
    private static func playBestFollowingCard(validMoves: [Card], hand: [Card], leadSuit: Suit, trumpSuit: Suit?, trick: [Card]) -> Card {
        
        let trickWinner = GameLogic.winner(of: trick, leadSuit: leadSuit, trumpSuit: trumpSuit)
        let trickHighCard = trick[trickWinner]
        
        // If leader is winning with high card, try to beat
        let canBeatLeader = validMoves.contains { card in
            if card.suit == trumpSuit && trickHighCard.suit != trumpSuit {
                return true
            }
            if card.suit == leadSuit && trickHighCard.suit == leadSuit {
                return card.rank.rawValue > trickHighCard.rank.rawValue
            }
            return false
        }
        
        if canBeatLeader {
            // Find lowest card that can win
            let winners = validMoves.filter { card in
                if card.suit == trumpSuit && trickHighCard.suit != trumpSuit {
                    return true
                }
                if card.suit == leadSuit && trickHighCard.suit == leadSuit {
                    return card.rank.rawValue > trickHighCard.rank.rawValue
                }
                return false
            }
            return winners.sorted { $0.rank.rawValue < $1.rank.rawValue }.first!
        }
        
        // Can't win, play lowest
        return validMoves.sorted { $0.rank.rawValue < $1.rank.rawValue }.first!
    }
    
    private static func playToWin(validMoves: [Card], hand: [Card], leadSuit: Suit?, trumpSuit: Suit?, trick: [Card]) -> Card {
        
        guard let lead = leadSuit else {
            // Leading, play highest
            return validMoves.sorted { $0.rank.rawValue > $1.rank.rawValue }.first!
        }
        
        // Try to win
        let sorted = validMoves.sorted { $0.rank.rawValue > $1.rank.rawValue }
        for card in sorted {
            if canWin(card: card, leadSuit: lead, trumpSuit: trumpSuit, trick: trick) {
                return card
            }
        }
        
        // Can't win, play lowest
        return validMoves.sorted { $0.rank.rawValue < $1.rank.rawValue }.first!
    }
    
    private static func canWin(card: Card, leadSuit: Suit, trumpSuit: Suit?, trick: [Card]) -> Bool {
        var highestTrump = -1
        var highestLead = -1
        
        for trickCard in trick {
            if trickCard.suit == trumpSuit {
                highestTrump = max(highestTrump, trickCard.rank.rawValue)
            } else if trickCard.suit == leadSuit {
                highestLead = max(highestLead, trickCard.rank.rawValue)
            }
        }
        
        if card.suit == trumpSuit {
            return card.rank.rawValue > highestTrump
        } else if card.suit == leadSuit {
            return highestTrump == -1 && card.rank.rawValue > highestLead
        }
        return false
    }
    
    private static func countRemainingCards(hand: [Card]) -> [Suit: Int] {
        var counts: [Suit: Int] = [:]
        for suit in Suit.allCases {
            counts[suit] = 40 - playedCards.filter { $0.suit == suit }.count - hand.filter { $0.suit == suit }.count
        }
        return counts
    }
    
    private static func isPartnerWinning(trick: [Card], leadSuit: Suit) -> Bool {
        // Assuming player 0 and 2 are partners
        // If trick winner is index 0 or 2, partner is winning
        let winner = GameLogic.winner(of: trick, leadSuit: leadSuit, trumpSuit: nil)
        return winner == 0 || winner == 2
    }
    
    private static func findTuteOpportunity(validMoves: [Card], hand: [Card], leadSuit: Suit?, trumpSuit: Suit?) -> Card? {
        // Look for opportunities to win with high-value cards
        let highValueCards = validMoves.filter { $0.rank.points >= 3 }
        return highValueCards.max(by: { $0.rank.points < $1.rank.points })
    }
    
    private static func isOpponentWinningSoon(hand: [Card], trumpSuit: Suit?) -> Bool {
        // Simple heuristic: opponent has many cards left
        return hand.count <= 3
    }
    
    private static func canWinGame(hand: [Card], trumpSuit: Suit?) -> Bool {
        let highCards = hand.filter { $0.rank.points >= 10 }
        return highCards.count >= 2
    }
    
    private static func playDefensive(validMoves: [Card], hand: [Card], leadSuit: Suit?, trumpSuit: Suit?) -> Card {
        // Play lowest cards to save high ones
        return validMoves.sorted { $0.rank.rawValue < $1.rank.rawValue }.first!
    }
    
    private static func playAggressive(validMoves: [Card], hand: [Card], leadSuit: Suit?, trumpSuit: Suit?, trick: [Card]) -> Card {
        // Play to win every trick
        return playToWin(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick)
    }
}
