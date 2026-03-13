import SwiftUI

struct GameView: View {
    @Binding var game: Game
    @State private var selectedCard: Card?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Header
            headerView
            
            // Game table
            gameTable
            
            // Your hand
            playerHand
            
            Spacer()
        }
        .onAppear {
            // Start CPU turn if needed
            checkCPUTurn()
        }
        .alert("Mensaje", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Header
    var headerView: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Ronda \(game.roundNumber)")
                    .font(.headline)
                
                Spacer()
                
                if let trump = game.trumpSuit {
                    Text("Triunfo: \(trump.symbol)")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                // Scores
                HStack(spacing: 20) {
                    VStack {
                        Text("Equipo 1")
                            .font(.caption2)
                        Text("\(game.team1Score)")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    VStack {
                        Text("Equipo 2")
                            .font(.caption2)
                        Text("\(game.team2Score)")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            
            // Message
            if let msg = game.message {
                Text(msg)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Game Table
    var gameTable: some View {
        ZStack {
            // Green felt background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.green.opacity(0.3))
                .frame(height: 180)
            
            VStack {
                // CPU 2 and 3 (top)
                HStack(spacing: 40) {
                    // CPU 2 (left)
                    playerCardStack(player: game.players[2], position: .top)
                    
                    Spacer()
                    
                    // CPU 3 (right)
                    playerCardStack(player: game.players[3], position: .top)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Trick area (center)
                if !game.currentTrick.isEmpty {
                    HStack(spacing: 15) {
                        ForEach(game.currentTrick, id: \.playerIndex) { trickCard in
                            VStack {
                                CardView(card: trickCard.card, isFaceUp: true)
                                    .frame(width: 50, height: 70)
                                Text(game.players[trickCard.playerIndex].name)
                                    .font(.caption2)
                            }
                        }
                    }
                } else {
                    Text("Toca una carta para jugar")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // CPU 1 (bottom left)
                HStack {
                    playerCardStack(player: game.players[1], position: .bottom)
                    Spacer()
                }
                .padding(.horizontal, 40)
            }
            .padding()
        }
        .padding()
    }
    
    func playerCardStack(player: Player, position: PlayerPosition) -> some View {
        VStack(spacing: 2) {
            Text(player.name)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            ZStack {
                // Card backs
                ForEach(0..<min(player.hand.count, 3), id: \.self) { i in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue.opacity(0.8))
                        .frame(width: 30, height: 40)
                        .offset(y: CGFloat(i * 2))
                }
                
                // Count badge
                if player.hand.count > 0 {
                    Text("\(player.hand.count)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Circle().fill(Color.blue))
                }
            }
        }
    }
    
    enum PlayerPosition {
        case top, bottom
    }
    
    // MARK: - Player Hand
    var playerHand: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Tu mano")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if game.currentPlayerIndex == 0 {
                    Text("Tu turno")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -40) {
                    ForEach(game.players[0].hand) { card in
                        CardView(card: card, isFaceUp: true)
                            .frame(width: 70, height: 100)
                            .onTapGesture {
                                playCard(card)
                            }
                            .opacity(isValidMove(card) ? 1 : 0.5)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 110)
            .background(Color(.systemGray6))
        }
    }
    
    // MARK: - Game Logic
    
    func isValidMove(_ card: Card) -> Bool {
        return game.isValidMove(card: card, by: 0)
    }
    
    func playCard(_ card: Card) {
        // Check if it's player's turn
        guard game.currentPlayerIndex == 0 else {
            alertMessage = "Espera tu turno"
            showingAlert = true
            return
        }
        
        // Check if valid move
        guard isValidMove(card) else {
            alertMessage = "Debes seguir el palo"
            showingAlert = true
            return
        }
        
        // Play the card
        _ = game.playCard(card: card, by: 0)
        
        // Check for message
        if let msg = game.message {
            alertMessage = msg
            showingAlert = true
        }
        
        // CPU plays after human
        checkCPUTurn()
    }
    
    func checkCPUTurn() {
        // Delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            while game.currentPlayer.type == .cpu && game.gamePhase == .playing {
                game.cpuPlay()
                
                if let msg = game.message {
                    alertMessage = msg
                    showingAlert = true
                }
                
                // Small delay between CPU moves
                Thread.sleep(forTimeInterval: 0.8)
            }
        }
    }
}
