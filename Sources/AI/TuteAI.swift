import Foundation

struct TuteAI {
    
    // AI Strategy levels
    enum Difficulty {
        case easy    // Random valid move
        case medium // Basic strategy
        case hard   // Advanced strategy
    }
    
    // Main function to select best card
    static func selectCard(
        hand: [Card],
        leadSuit: Suit?,
        trumpSuit: Suit?,
        trick: [Card],
        difficulty: Difficulty = .medium
    ) -> Card? {
        let validMoves = GameLogic.validMoves(hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit)
        
        guard !validMoves.isEmpty else { return nil }
        
        switch difficulty {
        case .easy:
            return randomMove(validMoves)
        case .medium:
            return mediumStrategy(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick)
        case .hard:
            return hardStrategy(validMoves: validMoves, hand: hand, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick)
        }
    }
    
    // Easy: Random valid move
    private static func randomMove(_ moves: [Card]) -> Card {
        return moves.randomElement()!
    }
    
    // Medium: Basic strategy
    private static func mediumStrategy(
        validMoves: [Card],
        hand: [Card],
        leadSuit: Suit?,
        trumpSuit: Suit?,
        trick: [Card]
    ) -> Card {
        
        // If leading (first to play)
        if leadSuit == nil {
            // Play a medium card, not highest or lowest
            let sorted = validMoves.sorted { $0.rank.rawValue < $1.rank.rawValue }
            
            // If has trumps, save them
            if let trump = trumpSuit {
                let nonTrumps = validMoves.filter { $0.suit != trump }
                if !nonTrumps.isEmpty && sorted.count > 2 {
                    return nonTrumps[sorted.count / 2]
                }
            }
            
            // Play middle card
            return sorted[sorted.count / 2]
        }
        
        // If someone has already played in trick
        if !trick.isEmpty {
            let trickWinner = GameLogic.winner(of: trick, leadSuit: leadSuit!, trumpSuit: trumpSuit)
            
            // If leader is winning, try to beat them
            if trickWinner == 0 {
                // Find highest winning card
                let best = validMoves
                    .filter { canWin(card: $0, leadSuit: leadSuit, trumpSuit: trumpSuit, trick: trick) }
                    .sorted { $0.rank.rawValue < $1.rank.rawValue }
                
                if let winning = best.first {
                    return winning
                }
            }
            
            // If can't win, play lowest
            return validMoves.sorted { $0.rank.rawValue < $1.rank.rawValue }.first!
        }
        
        // Default: play random
        return validMoves.randomElement()!
    }
    
    // Hard: Advanced strategy
    private static func hardStrategy(
        validMoves: [Card],
        hand: [Card],
        leadSuit: Suit?,
        trumpSuit: Suit?,
        trick: [Card]
    ) -> Card {
        
        let cardCount = hand.count
        
        // Early game (many cards left)
        if cardCount > 7 {
            // Save high cards for end
            let lowCards = validMoves.filter { $0.rank.rawValue <= 4 }
            if !lowCards.isEmpty {
                return lowCards.randomElement()!
            }
        }
        
        // Late game (few cards left)
        if cardCount <= 3 {
            // Play highest card
            return validMoves.sorted { $0.rank.rawValue > $1.rank.rawValue }.first!
        }
        
        // Medium strategy for mid-game
        return mediumStrategy(
            validMoves: validMoves,
            hand: hand,
            leadSuit: leadSuit,
            trumpSuit: trumpSuit,
            trick: trick
        )
    }
    
    // Check if card can win the trick
    private static func canWin(card: Card, leadSuit: Suit?, trumpSuit: Suit?, trick: [Card]) -> Bool {
        guard let lead = leadSuit else { return true }
        
        // If playing trump and no trump in trick, can win
        if card.suit == trumpSuit {
            let hasTrumpInTrick = trick.contains { $0.suit == trumpSuit }
            if !hasTrumpInTrick {
                return true
            }
        }
        
        // If not trump and no trump in trick, can win
        if trumpSuit == nil || !trick.contains(where: { $0.suit == trumpSuit }) {
            if card.suit == lead {
                return true
            }
        }
        
        return false
    }
}
