import SwiftUI

struct ContentView: View {
    @State private var gameStarted = false
    @State private var game = Game()
    @State private var showStatistics = false
    @State private var stats = GameStatistics()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // Title
                Text("🃏 Tute")
                    .font(.system(size: 60, weight: .bold))
                
                Text("Juego de Cartas Español")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Menu buttons
                VStack(spacing: 15) {
                    Button(action: {
                        SoundManager.shared.haptic(.light)
                        game.startNewRound()
                        gameStarted = true
                    }) {
                        Label("Nueva Partida", systemImage: "play.fill")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: {
                        SoundManager.shared.haptic(.light)
                        showStatistics = true
                    }) {
                        Label("Estadísticas", systemImage: "chart.bar.fill")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        // Settings
                    }) {
                        Label("Configuración", systemImage: "gear")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        // Rules
                    }) {
                        Label("Reglas", systemImage: "questionmark.circle")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Credits
                Text("v1.0 - TuteGame")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationDestination(isPresented: $gameStarted) {
                GameView(game: $game)
            }
            .sheet(isPresented: $showStatistics) {
                StatisticsView(stats: stats)
            }
            .onAppear {
                loadStatistics()
            }
        }
    }
    
    func loadStatistics() {
        // Load from UserDefaults or file
        if let data = UserDefaults.standard.data(forKey: "gameStats"),
           let savedStats = try? JSONDecoder().decode(GameStatistics.self, from: data) {
            stats = savedStats
        }
    }
}

#Preview {
    ContentView()
}
