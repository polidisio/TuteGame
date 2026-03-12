import SwiftUI

struct ContentView: View {
    @State private var gameStarted = false
    @State private var game = Game()
    
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
                Text("v1.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationDestination(isPresented: $gameStarted) {
                GameView(game: $game)
            }
        }
    }
}

#Preview {
    ContentView()
}
