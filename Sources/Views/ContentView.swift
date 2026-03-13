import SwiftUI

struct ContentView: View {
    @State private var gameStarted = false
    @State private var game = Game()
    @State private var showStatistics = false
    @State private var showSettings = false
    @State private var stats = GameStatistics()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // Title
                VStack(spacing: 10) {
                    Text("🃏")
                        .font(.system(size: 50))
                    
                    Text("Tute")
                        .font(.system(size: 60, weight: .bold))
                    
                    Text("Juego de Cartas Español")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Menu buttons
                VStack(spacing: 15) {
                    Button(action: {
                        SettingsManager.shared.triggerHaptic(.light)
                        game.startNewRound()
                        gameStarted = true
                    }) {
                        Label("Nueva Partida", systemImage: "play.fill")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            SettingsManager.shared.triggerHaptic(.light)
                            showStatistics = true
                        }) {
                            Label("Estadísticas", systemImage: "chart.bar.fill")
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            SettingsManager.shared.triggerHaptic(.light)
                            showSettings = true
                        }) {
                            Label("Ajustes", systemImage: "gear")
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Button(action: {
                        SettingsManager.shared.triggerHaptic(.light)
                        // Show rules
                    }) {
                        Label("Reglas del Juego", systemImage: "questionmark.circle")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Credits
                VStack(spacing: 5) {
                    Text("v1.0 - TuteGame")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        // Sound indicator
                        HStack(spacing: 3) {
                            Image(systemName: SettingsManager.shared.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            Text(SettingsManager.shared.soundEnabled ? "ON" : "OFF")
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        
                        // Difficulty indicator
                        Text("🤖 \(SettingsManager.shared.difficultyName)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .navigationDestination(isPresented: $gameStarted) {
                GameView(game: $game)
            }
            .sheet(isPresented: $showStatistics) {
                StatisticsView(stats: stats)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .onAppear {
                loadStatistics()
                SettingsManager.shared.playMusic()
            }
        }
    }
    
    func loadStatistics() {
        if let data = UserDefaults.standard.data(forKey: "gameStats"),
           let savedStats = try? JSONDecoder().decode(GameStatistics.self, from: data) {
            stats = savedStats
        }
    }
}

#Preview {
    ContentView()
}
