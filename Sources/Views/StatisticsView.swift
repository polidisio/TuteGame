import SwiftUI

struct StatisticsView: View {
    let stats: GameStatistics
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Win Rate Circle
                    winRateCircle
                    
                    // Main Stats Grid
                    mainStatsGrid
                    
                    // Performance Section
                    performanceSection
                    
                    // Streaks
                    streaksSection
                    
                    // Last Played
                    if let lastPlayed = stats.lastPlayedDate {
                        HStack {
                            Image(systemName: "clock")
                            Text("Última partida: \(lastPlayed.formatted(date: .abbreviated, time: .shortened))")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("📊 Estadísticas")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Win Rate Circle
    var winRateCircle: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: CGFloat(stats.winRate / 100))
                    .stroke(
                        winRateColor,
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: stats.winRate)
                
                VStack {
                    Text("\(Int(stats.winRate))%")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(winRateColor)
                    Text("Victorias")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 30) {
                VStack {
                    Text("\(stats.gamesWon)")
                        .font(.title2.bold())
                        .foregroundColor(.green)
                    Text("Ganadas")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                VStack {
                    Text("\(stats.gamesLost)")
                        .font(.title2.bold())
                        .foregroundColor(.red)
                    Text("Perdidas")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                VStack {
                    Text("\(stats.totalGamesPlayed)")
                        .font(.title2.bold())
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 10)
        }
    }
    
    var winRateColor: Color {
        if stats.winRate >= 70 { return .green }
        if stats.winRate >= 50 { return .orange }
        return .red
    }
    
    // MARK: - Main Stats Grid
    var mainStatsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            StatCard(
                title: "Puntos/Partida",
                value: String(format: "%.1f", stats.averagePointsPerGame),
                icon: "star.fill",
                color: .yellow
            )
            
            StatCard(
                title: "Bazas/Ronda",
                value: String(format: "%.1f", stats.averageTricksPerRound),
                icon: "square.stack.3d.up",
                color: .blue
            )
            
            StatCard(
                title: "Rondas Jugadas",
                value: "\(stats.totalRoundsPlayed)",
                icon: "repeat",
                color: .purple
            )
            
            StatCard(
                title: "Rondas Ganadas",
                value: "\(stats.roundsWon)",
                icon: "trophy.fill",
                color: .orange
            )
        }
    }
    
    // MARK: - Performance Section
    var performanceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Rendimiento")
                .font(.headline)
            
            VStack(spacing: 8) {
                PerformanceBar(
                    label: "Victorias",
                    value: stats.gamesWon,
                    total: stats.totalGamesPlayed,
                    color: .green
                )
                
                PerformanceBar(
                    label: "Derrotas",
                    value: stats.gamesLost,
                    total: stats.totalGamesPlayed,
                    color: .red
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Streaks
    var streaksSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Rachas")
                .font(.headline)
            
            HStack(spacing: 20) {
                VStack {
                    Image(systemName: "flame.fill")
                        .font(.title)
                        .foregroundColor(.orange)
                    Text("\(stats.longestWinStreak)")
                        .font(.title2.bold())
                    Text("Mejor racha")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                VStack {
                    Image(systemName: "flame")
                        .font(.title)
                        .foregroundColor(.orange.opacity(0.5))
                    Text("\(stats.currentWinStreak)")
                        .font(.title2.bold())
                    Text("Racha actual")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2.bold())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PerformanceBar: View {
    let label: String
    let value: Int
    let total: Int
    let color: Color
    
    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(value) / Double(total)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(label)
                    .font(.subheadline)
                Spacer()
                Text("\(value) (\(Int(percentage * 100))%)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    StatisticsView(stats: {
        var stats = GameStatistics()
        stats.totalGamesPlayed = 25
        stats.gamesWon = 15
        stats.gamesLost = 10
        stats.totalRoundsPlayed = 100
        stats.roundsWon = 55
        stats.totalTricksWon = 520
        stats.totalPointsEarned = 2450
        stats.longestWinStreak = 5
        stats.currentWinStreak = 3
        return stats
    }())
}
