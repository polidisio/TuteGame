import SwiftUI

struct CardView: View {
    let card: Card
    let isFaceUp: Bool
    
    // Map card to image name
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
    
    var body: some View {
        ZStack {
            if isFaceUp {
                // Try to load image, fallback to symbols
                Image(uiImage: UIImage(named: imageName) ?? createCardImage())
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
                    
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .padding(4)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.white.opacity(0.15))
                        .font(.system(size: 30))
                }
            }
        }
        .frame(width: 70, height: 100)
        .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
    }
    
    // Create fallback image with symbols
    private func createCardImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 140, height: 200))
        return renderer.image { context in
            // Background
            UIColor.white.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 140, height: 200))
            
            // Border
            UIColor.black.setStroke()
            let border = UIBezierPath(roundedRect: CGRect(x: 2, y: 2, width: 136, height: 196), cornerRadius: 8)
            border.stroke()
            
            // Color based on suit
            let color: UIColor
            switch card.suit {
            case .oros, .copas:
                color = .red
            case .espadas, .bastos:
                color = .black
            }
            
            // Draw rank
            let rankText = card.rank.symbol
            let font = UIFont.systemFont(ofSize: 24, weight: .bold)
            let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
            
            // Top left
            rankText.draw(at: CGPoint(x: 8, y: 8), withAttributes: attrs)
            
            // Bottom right (rotated)
            context.cgContext.saveGState()
            context.cgContext.translateBy(x: 140, y: 200)
            context.cgContext.rotate(by: .pi)
            rankText.draw(at: CGPoint(x: 8, y: 8), withAttributes: attrs)
            context.cgContext.restoreGState()
            
            // Center suit symbol
            let suitSymbol: String
            switch card.suit {
            case .oros: suitSymbol = "🪙"
            case .copas: suitSymbol = "🍷"
            case .espadas: suitSymbol = "⚔️"
            case .bastos: suitSymbol = "🪵"
            }
            
            let suitFont = UIFont.systemFont(ofSize: 50)
            let suitAttrs: [NSAttributedString.Key: Any] = [.font: suitFont]
            let suitSize = suitSymbol.size(withAttributes: suitAttrs)
            let suitPoint = CGPoint(x: (140 - suitSize.width) / 2, y: (200 - suitSize.height) / 2)
            suitSymbol.draw(at: suitPoint, withAttributes: suitAttrs)
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
