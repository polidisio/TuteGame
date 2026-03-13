import Foundation

struct GameStatistics: Codable {
    var totalGamesPlayed: Int = 0
    var gamesWon: Int = 0
    var gamesLost: Int = 0
    
    var totalRoundsPlayed: Int = 0
    var roundsWon: Int = 0
    
    var totalTricksWon: Int = 0
    var totalPointsEarned: Int = 0
    
    var winsByRound: [Int: Int] = [:] // Round number -> wins
    var pointsByRound: [Int: Int] = [:] // Round number -> points
    
    var longestWinStreak: Int = 0
    var currentWinStreak: Int = 0
    
    var lastPlayedDate: Date?
    
    var winRate: Double {
        guard totalGamesPlayed > 0 else { return 0 }
        return Double(gamesWon) / Double(totalGamesPlayed) * 100
    }
    
    var averagePointsPerGame: Double {
        guard totalGamesPlayed > 0 else { return 0 }
        return Double(totalPointsEarned) / Double(totalGamesPlayed)
    }
    
    var averageTricksPerRound: Double {
        guard totalRoundsPlayed > 0 else { return 0 }
        return Double(totalTricksWon) / Double(totalRoundsPlayed)
    }
    
    mutating func recordGameWon(points: Int) {
        totalGamesPlayed += 1
        gamesWon += 1
        totalPointsEarned += points
        currentWinStreak += 1
        longestWinStreak = max(longestWinStreak, currentWinStreak)
        lastPlayedDate = Date()
    }
    
    mutating func recordGameLost(points: Int) {
        totalGamesPlayed += 1
        gamesLost += 1
        totalPointsEarned += points
        currentWinStreak = 0
        lastPlayedDate = Date()
    }
    
    mutating func recordRound(tricksWon: Int, points: Int) {
        totalRoundsPlayed += 1
        roundsWon += tricksWon > 5 ? 1 : 0
        totalTricksWon += tricksWon
    }
    
    mutating func reset() {
        totalGamesPlayed = 0
        gamesWon = 0
        gamesLost = 0
        totalRoundsPlayed = 0
        roundsWon = 0
        totalTricksWon = 0
        totalPointsEarned = 0
        winsByRound = [:]
        pointsByRound = [:]
        longestWinStreak = 0
        currentWinStreak = 0
        lastPlayedDate = nil
    }
}
