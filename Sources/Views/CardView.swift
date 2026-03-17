import SwiftUI

struct CardView: View {
    let card: Card
    let isFaceUp: Bool
    
    @State private var isAnimating = false
    @State private var scale: CGFloat = 1.0
    
    private var imageName: String {
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
        
        return "\(suitOffset + rankValue)"
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
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(4)
            
            VStack {
                HStack {
                    Text(card.rank.symbol)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(suitColor)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(card.rank.symbol)
                        .font(.system(size: 8, weight: .bold))
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
                .fill(Color.blue.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
            
            Image("back")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(8)
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
