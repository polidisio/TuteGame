import SwiftUI

struct GameView: View {
    @Binding var game: Game
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Header - Round info
            HStack {
                Text("Ronda \(game.roundNumber)")
                    .font(.headline)
                
                Spacer()
                
                if let trump = game.trumpSuit {
                    Text("Triunfo: \(trump.symbol)")
                        .font(.subheadline)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    VStack {
                        Text("Equipo 1")
                        Text("\(game.team1Score)")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    VStack {
                        Text("Equipo 2")
                        Text("\(game.team2Score)")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            
            // Game area
            VStack {
                // CPU players (top)
                HStack(spacing: 20) {
                    // CPU 2
                    VStack {
                        Text(game.players[2].name)
                            .font(.caption)
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.green)
                                .frame(width: 30, height: 40)
                            Text("\(game.players[2].hand.count)")
                                .foregroundColor(.white)
                                .font(.caption2)
                        }
                    }
                    
                    Spacer()
                    
                    // CPU 3
                    VStack {
                        Text(game.players[3].name)
                            .font(.caption)
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.green)
                                .frame(width: 30, height: 40)
                            Text("\(game.players[3].hand.count)")
                                .foregroundColor(.white)
                                .font(.caption2)
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                // Table / Trick area
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemGreen).opacity(0.3))
                        .frame(height: 150)
                    
                    if game.currentTrick.isEmpty {
                        Text("Jugada actual")
                            .foregroundColor(.secondary)
                    } else {
                        HStack(spacing: 10) {
                            ForEach(game.currentTrick) { card in
                                CardView(card: card, isFaceUp: true)
                                    .frame(width: 50, height: 70)
                            }
                        }
                    }
                }
                .padding()
                
                // CPU 1
                HStack {
                    VStack {
                        Text(game.players[1].name)
                            .font(.caption)
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.green)
                                .frame(width: 30, height: 40)
                            Text("\(game.players[1].hand.count)")
                                .foregroundColor(.white)
                                .font(.caption2)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 40)
            }
            
            // Your hand
            VStack(spacing: 10) {
                Text("Tu mano")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: -30) {
                        ForEach(game.players[0].hand) { card in
                            CardView(card: card, isFaceUp: true)
                                .onTapGesture {
                                    // Play card
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 100)
            }
            .padding()
            .background(Color(.systemGray6))
        }
    }
}
