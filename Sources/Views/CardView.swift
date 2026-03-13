import SwiftUI

struct CardView: View {
    let card: Card
    let isFaceUp: Bool
    
    // Animation states
    @State private var isAnimating = false
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    
    // Animation configuration
    var animationType: CardAnimation = .none
    
    enum CardAnimation {
        case none
        case deal
        case play
        case win
        case flip
    }
    
    // Map card to image number
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
    
    var body: some View {
        ZStack {
            if isFaceUp {
                Image("\(imageNumber)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                // Card back with design
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
                    
                    // Decorative pattern
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .padding(4)
                    
                    // Center design
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
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        CardView(card: Card(suit: .oros, rank: .uno), isFaceUp: true)
        CardView(card: Card(suit: .espadas, rank: .rey), isFaceUp: true)
        CardView(card: Card(suit: .bastos, rank: .sota), isFaceUp: false)
    }
}
