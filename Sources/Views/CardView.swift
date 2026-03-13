import SwiftUI

struct CardView: View {
    let card: Card
    let isFaceUp: Bool
    
    // Map card to image number
    // 1-10: Oros (1=As, 2-7=numbers, 8=Sota, 9=Caballo, 10=Rey)
    // 11-20: Copas
    // 21-30: Espadas
    // 31-40: Bastos
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
                // Use the actual card image
                Image("\(imageNumber)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                // Card back image
                Image("back")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .frame(width: 70, height: 100)
        .shadow(radius: 2)
    }
}

#Preview {
    VStack(spacing: 20) {
        CardView(card: Card(suit: .oros, rank: .uno), isFaceUp: true)
        CardView(card: Card(suit: .espadas, rank: .rey), isFaceUp: true)
        CardView(card: Card(suit: .bastos, rank: .sota), isFaceUp: false)
    }
}
