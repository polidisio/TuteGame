import SwiftUI

struct CardView: View {
    let card: Card
    let isFaceUp: Bool
    
    @State private var isAnimating = false
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    
    var animationType: CardAnimation = .none
    
    enum CardAnimation {
        case none
        case deal
        case play
        case win
        case flip
    }
    
    private var imageNumber: Int {
        let suitOffset: Int
        switch card.suit {
        case .oros: suitOffset = 0
        case .copas: suitOffset = 10
        case .espadas: suitOffset = 20
        case .bastos: suitOffset = 30
        }
        
        let rankValue: Int
        switch card.rank {
        case .uno: rankValue = 1
        case .dos: rankValue = 2
        case .tres: rankValue = 3
        case .cuatro: rankValue = 4
        case .cinco: rankValue = 5
        case .seis: rankValue = 6
        case .siete: rankValue = 7
        case .sota: rankValue = 8
        case .caballo: rankValue = 9
        case .rey: rankValue = 10
        }
        
        return suitOffset + rankValue
    }
    
    private var suitColor: Color {
        switch card.suit {
        case .oros, .copas:
            return .red
        case .espadas, .bastos:
            return .black
        }
    }
    
    var body: some View {
        ZStack {
            if isFaceUp {
                fallbackCardView
            } else {
                cardBackView
            }
        }
        .frame(width: 70, height: 100)
        .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
        .scaleEffect(scale)
        .offset(offset)
        .rotationEffect(.degrees(isAnimating ? 0 : -90))
        .opacity(isAnimating ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
    
    private var fallbackCardView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(suitColor, lineWidth: 2)
                )
            
            VStack(spacing: 2) {
                Text(card.rank.symbol)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(suitColor)
                
                Text(card.suit.symbol)
                    .font(.system(size: 20))
            }
            
            VStack {
                HStack {
                    Text(card.rank.symbol)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(suitColor)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(card.rank.symbol)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(suitColor)
                        .rotationEffect(.degrees(180))
                }
            }
            .padding(4)
        }
    }
    
    private var cardBackView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.1, green: 0.1, blue: 0.4),
                            Color(red: 0.2, green: 0.2, blue: 0.5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                .padding(4)
            
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                .padding(15)
                .overlay(
                    Image(systemName: "star.fill")
                        .foregroundColor(.white.opacity(0.15))
                        .font(.system(size: 30))
                )
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
