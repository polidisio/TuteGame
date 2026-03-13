import SwiftUI

struct GameView: View {
    @Binding var game: Game
    @State private var selectedCard: Card?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var cardAnimation = false
    
    var body: some View {
        VStack(spacing: 20) {
            headerView
            gameTable
            playerHand
            Spacer()
        }
        .onAppear {
            checkCPUTurn()
        }
        .alert("Mensaje", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    var headerView: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Ronda \(game.roundNumber)")
                    .font(.headline)
                
                Spacer()
                
                trumpIndicator
                
                Spacer()
                
                scoresView
            }
            .padding()
            .background(Color(.systemGray6))
            
            if let msg = game.message {
                Text(msg)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: game.message)
    }
    
    var trumpIndicator: some View {
        HStack(spacing: 4) {
            if let trump = game.trumpSuit {
                Text("Triunfo:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(trump.symbol)
                    .font(.title2)
                Text(trump.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    var scoresView: some View {
        HStack(spacing: 20) {
            teamScoreView(team: 1, score: game.team1Score, isWinning: game.team1Score > game.team2Score)
            teamScoreView(team: 2, score: game.team2Score, isWinning: game.team2Score > game.team1Score)
        }
    }
    
    func teamScoreView(team: Int, score: Int, isWinning: Bool) -> some View {
        VStack(spacing: 2) {
            Text("E\(team)")
                .font(.caption2)
            Text("\(score)")
                .font(.title3)
                .fontWeight(isWinning ? .bold : .regular)
                .foregroundColor(team == 1 ? .blue : .red)
        }
    }
    
    var gameTable: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.4),
                            Color.green.opacity(0.1)
                        ]),
                        center: .center,
                        startRadius: 50,
                        endRadius: 150
                    )
                )
                .frame(height: 200)
            
            VStack {
                HStack(spacing: 60) {
                    playerCardStack(player: game.players[2], position: .top)
                    Spacer()
                    playerCardStack(player: game.players[3], position: .top)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                trickArea
                
                Spacer()
                
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
    
    var trickArea: some View {
        ZStack {
            if !game.currentTrick.isEmpty {
                HStack(spacing: 20) {
                    ForEach(game.currentTrick, id: \.playerIndex) { trickCard in
                        VStack(spacing: 4) {
                            CardView(card: trickCard.card, isFaceUp: true)
                                .frame(width: 55, height: 80)
                                .scaleEffect(isWinningCard(trickCard.card) ? 1.1 : 1.0)
                                .shadow(color: isWinningCard(trickCard.card) ? .yellow : .clear, radius: 5)
                            
                            Text(game.players[trickCard.playerIndex].name)
                                .font(.caption2)
                                .foregroundColor(isWinningCard(trickCard.card) ? .yellow : .secondary)
                        }
                        .animation(.spring(response: 0.3), value: game.currentTrick.count)
                    }
                }
            } else {
                VStack(spacing: 4) {
                    Image(systemName: "hand.point.up")
                        .font(.title2)
                        .foregroundColor(.secondary.opacity(0.5))
                    Text(game.currentPlayerIndex == 0 ? "Tu turno" : "\(game.currentPlayer.name) juega")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    func isWinningCard(_ card: Card) -> Bool {
        guard game.currentTrick.count == 4, let lead = game.currentTrick.first?.card.suit else {
            return false
        }
        
        let winner = GameLogic.winner(of: game.currentTrick.map { $0.card }, leadSuit: lead, trumpSuit: game.trumpSuit)
        return game.currentTrick[winner].card.id == card.id
    }
    
    func playerCardStack(player: Player, position: PlayerPosition) -> some View {
        VStack(spacing: 4) {
            if game.currentPlayerIndex == game.players.firstIndex(where: { $0.id == player.id }) {
                Image(systemName: "arrow.down")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
            
            Text(player.name)
                .font(.caption2)
                .foregroundColor(game.currentPlayerIndex == game.players.firstIndex(where: { $0.id == player.id }) ? .yellow : .secondary)
            
            ZStack {
                ForEach(0..<min(player.hand.count, 3), id: \.self) { i in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue.opacity(0.8), .blue.opacity(0.5)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 30, height: 42)
                        .offset(y: CGFloat(i * 2))
                }
                
                if player.hand.count > 0 {
                    Text("\(player.hand.count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(Color.blue))
                }
            }
            
            if !player.hand.isEmpty {
                Text("+\(player.score)")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
        }
    }
    
    enum PlayerPosition {
        case top, bottom
    }
    
    var playerHand: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Tu mano")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { i in
                        Circle()
                            .fill(i == game.currentPlayerIndex ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -35) {
                    ForEach(game.players[0].hand) { card in
                        CardView(card: card, isFaceUp: true)
                            .frame(width: 65, height: 95)
                            .onTapGesture {
                                playCard(card)
                            }
                            .opacity(isValidMove(card) ? 1 : 0.4)
                            .scaleEffect(isValidMove(card) ? 1.0 : 0.9)
                            .animation(.spring(response: 0.3), value: selectedCard)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 110)
            .background(Color(.systemGray6))
        }
    }
    
    func isValidMove(_ card: Card) -> Bool {
        return game.isValidMove(card: card, by: 0)
    }
    
    func playCard(_ card: Card) {
        guard game.currentPlayerIndex == 0 else {
            alertMessage = "Espera tu turno"
            showingAlert = true
            return
        }
        
        guard isValidMove(card) else {
            alertMessage = "Debes seguir el palo"
            showingAlert = true
            return
        }
        
        selectedCard = card
        withAnimation(.spring(response: 0.3)) {
            cardAnimation = true
        }
        
        _ = game.playCard(card: card, by: 0)
        
        if let msg = game.message {
            alertMessage = msg
            showingAlert = true
        }
        
        checkCPUTurn()
    }
    
    func checkCPUTurn() {
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            while game.currentPlayer.type == .cpu && game.gamePhase == .playing {
                game.cpuPlay()
                
                if let msg = game.message {
                    alertMessage = msg
                    showingAlert = true
                }
                
                try? await Task.sleep(nanoseconds: 800_000_000)
            }
        }
    }
}
