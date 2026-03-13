import Foundation

struct GameLogic {
    
    // Check if a card can be played (must follow suit if possible)
    static func canPlay(card: Card, hand: [Card], leadSuit: Suit?, trumpSuit: Suit?) -> Bool {
        // If there's no lead suit, any card can be played
        guard let lead = leadSuit else { return true }
        
        // Check if player has cards of lead suit
        let hasLeadSuit = hand.contains { $0.suit == lead }
        
        // If has lead suit, must play it (unless trumped)
        if hasLeadSuit && card.suit != lead {
            // Can only play non-lead suit if being trumped
            let hasTrump = hand.contains { $0.suit == trumpSuit }
            if hasTrump && card.suit == trumpSuit {
                return true // Trumping is allowed
            }
            return false // Must follow suit
        }
        
        return true
    }
    
    // Determine winner of a trick
    static func winner(of trick: [Card], leadSuit: Suit, trumpSuit: Suit?) -> Int {
        guard !trick.isEmpty else { return 0 }
        
        var winnerIndex = 0
        var highestTrumpValue = -1
        var highestLeadValue = -1
        
        for (index, card) in trick.enumerated() {
            let cardValue = card.rank.rawValue
            
            if card.suit == trumpSuit {
                // Trump card
                if cardValue > highestTrumpValue {
                    highestTrumpValue = cardValue
                    winnerIndex = index
                }
            } else if card.suit == leadSuit {
                // Lead suit card
                if cardValue > highestLeadValue && highestTrumpValue == -1 {
                    highestLeadValue = cardValue
                    winnerIndex = index
                }
            }
        }
        
        return winnerIndex
    }
    
    // Calculate points in a trick
    static func points(in trick: [Card]) -> Int {
        return trick.reduce(0) { $0 + $1.rank.points }
    }
    
    // Get all valid moves for a player
    static func validMoves(hand: [Card], leadSuit: Suit?, trumpSuit: Suit?) -> [Card] {
        if leadSuit == nil {
            return hand // Can play any card
        }
        
        let hasLead = hand.contains { $0.suit == leadSuit }
        let hasTrump = hand.contains { $0.suit == trumpSuit }
        
        if hasLead {
            // Must follow lead suit
            return hand.filter { $0.suit == leadSuit }
        } else if hasTrump {
            // Can only play trump
            return hand.filter { $0.suit == trumpSuit }
        } else {
            // Can play anything
            return hand
        }
    }
}
