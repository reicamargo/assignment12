//
//  ContentView.swift
//  Assignment12
//
//  Created by Reinaldo Camargo on 12/03/24.
//

import SwiftUI

struct MemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            titleGame
            ScrollView {
                cards
            }
            HStack {
                VStack{
                    Text("Theme: \(viewModel.theme.name)")
                        .font(.caption)
                    Text("Score: \(viewModel.score)")
                        .font(.caption)
                }
                Spacer()
                NewGameButton
            }
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85))]) {
            if !viewModel.cards.isEmpty {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 2)) {
                                viewModel.choose(card)
                            }
                        }
                }
            }
        }
        .foregroundColor(viewModel.returnSystemColor())
    }
    
    var titleGame: some View {
        return Text("Memorize!!")
            .font(.largeTitle)
    }
    
    var NewGameButton: some View {
        return Button(action: {
            withAnimation {
                viewModel.newGame()
            }
        }, label: {
            VStack {
            Image(systemName: "rectangle.stack.badge.plus.fill")
            Text("New Game")
                    .font(.footnote)
            }
        })
    }
}

struct CardView : View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        let rectangle = RoundedRectangle(cornerRadius: 12.0)
        ZStack {
            Group {
                rectangle.fill(.white)
                rectangle.strokeBorder(lineWidth: 2)
                Text(card.content).font(.largeTitle)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    .animation(.spin(duration: 1), value: card.isMatched)
                rectangle.fill().opacity(card.isFaceUp ? 0 : 1)
            }
        }
        .rotation3DEffect(.degrees(card.isFaceUp ? 0 : 180), axis: (0,1,0))
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .easeInOut(duration: duration).repeatForever(autoreverses: false)
    }
}

struct MemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(viewModel: EmojiMemoryGame())
    }
}
