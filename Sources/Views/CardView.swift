import SwiftUI

struct CardView: View {
    let card: Card
    let isFaceUp: Bool
    
    var body: some View {
        ZStack {
            if isFaceUp {
                // Card back (design)
                RoundedRectangle(cornerRadius: 8)
                    .fill(cardColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                // Card content
                VStack {
                    HStack {
                        Text(card.rank.symbol)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(textColor)
                        Spacer()
                    }
                    Spacer()
                    Text(card.suit.symbol)
                        .font(.system(size: 30))
                    Spacer()
                    HStack {
                        Spacer()
                        Text(card.rank.symbol)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(textColor)
                            .rotationEffect(.degrees(180))
                    }
                }
                .padding(8)
            } else {
                // Card back
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            .padding(2)
                    )
            }
        }
        .frame(width: 70, height: 100)
        .shadow(radius: 2)
    }
    
    var cardColor: Color {
        switch card.suit {
        case .oros:
            return .yellow.opacity(0.3)
        case .copas:
            return .red.opacity(0.3)
        case .espadas:
            return .gray.opacity(0.3)
        case .bastos:
            return .green.opacity(0.3)
        }
    }
    
    var textColor: Color {
        switch card.suit {
        case .oros, .copas:
            return .red
        case .espadas, .bastos:
            return .black
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CardView(card: Card(suit: .oros, rank: .uno), isFaceUp: true)
        CardView(card: Card(suit: .espadas, rank: .rey), isFaceUp: true)
        CardView(card: Card(suit: .bastos, rank: .sota), isFaceUp: false)
    }
}
