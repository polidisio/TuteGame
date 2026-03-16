import SwiftUI

struct CardView: View {
    let card: Card
    let isFaceUp: Bool
    
    @State private var isAnimating = false
    @State private var scale: CGFloat = 1.0
    
    var animationType: CardAnimation = .none
    
    enum CardAnimation {
        case none
        case deal
        case play
        case win
        case flip
    }
    
    private var suitColor: Color {
        switch card.suit {
        case .oros, .copas:
            return .red
        case .espadas, .bastos:
            return .black
        }
    }
    
    private var suitSymbol: String {
        switch card.suit {
        case .oros: return "dollarsign.circle.fill"
        case .copas: return "heart.fill"
        case .espadas: return "leaf.fill"
        case .bastos: return "line.3.horizontal.decrease.circle.fill"
        }
    }
    
    var body: some View {
        ZStack {
            if isFaceUp {
                cardFrontView
            } else {
                cardBackView
            }
        }
        .frame(width: 70, height: 100)
        .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
        .scaleEffect(scale)
        .rotationEffect(.degrees(isAnimating ? 0 : -90))
        .opacity(isAnimating ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
    
    private var cardFrontView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(card.rank.symbol)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(suitColor)
                        Image(systemName: suitSymbol)
                            .font(.system(size: 10))
                            .foregroundColor(suitColor)
                    }
                    Spacer()
                }
                .padding(.leading, 4)
                .padding(.top, 4)
                
                Spacer()
                
                Image(systemName: suitSymbol)
                    .font(.system(size: 28))
                    .foregroundColor(suitColor.opacity(0.3))
                
                Spacer()
                
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Image(systemName: suitSymbol)
                            .font(.system(size: 10))
                            .foregroundColor(suitColor)
                        Text(card.rank.symbol)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(suitColor)
                    }
                }
                .padding(.trailing, 4)
                .padding(.bottom, 4)
            }
        }
    }
    
    private var cardBackView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.8),
                            Color.blue.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
            
            VStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.3))
                
                Text("TUTE")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 10) {
            CardView(card: Card(suit: .oros, rank: .uno), isFaceUp: true)
            CardView(card: Card(suit: .copas, rank: .tres), isFaceUp: true)
            CardView(card: Card(suit: .espadas, rank: .rey), isFaceUp: true)
            CardView(card: Card(suit: .bastos, rank: .sota), isFaceUp: true)
        }
        CardView(card: Card(suit: .oros, rank: .siete), isFaceUp: false)
    }
    .padding()
    .background(Color.green.opacity(0.3))
}
