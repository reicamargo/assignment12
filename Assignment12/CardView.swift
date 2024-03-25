//
//  CardView.swift
//  Assignment12
//
//  Created by Reinaldo Camargo on 25/03/24.
//

import SwiftUI

struct CardView: View, Animatable {
    typealias Card = MemoryGame<String>.Card
    
    let card: Card
    var isFaceUp: Bool {
        rotation < 90
    }
    
    init (_ card: Card) {
        self.card = card
        rotation = card.isFaceUp ? 0 : 180
    }
    
    var rotation: Double
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    var body: some View {
        ZStack {
            let rectangle = RoundedRectangle(cornerRadius: 12.0)
            Group {
                rectangle
                    .strokeBorder(lineWidth: 2)
                    .background(rectangle.fill(.white))
                    .overlay(cardContents)
                rectangle.fill()
                    .opacity(self.isFaceUp ? 0 : 1)
            }
            .opacity(self.isFaceUp || !card.isMatched ? 1 : 0)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
        
    }
    
    var cardContents: some View {
        Text(card.content).font(.largeTitle)
            .font(.system(size: 200))
            .minimumScaleFactor(0.01)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(duration: 1), value: card.isMatched)
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .easeInOut(duration: duration).repeatForever(autoreverses: false)
    }
}
