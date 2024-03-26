//
//  ContentView.swift
//  Assignment12
//
//  Created by Reinaldo Camargo on 12/03/24.
//

import SwiftUI

struct MemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            titleGame
            ScrollView {
                cards
            }
            HStack {
                VStack{
                    themeView
                    score
                }
                Spacer()
                NewGameButton
            }
        }
        .padding()
    }
    
    private var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85))]) {
            if !viewModel.cards.isEmpty {
                ForEach(viewModel.cards) { card in
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0)
                        .padding(4)
                        .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                        .onTapGesture {
                            choose(card: card)
                        }
                }
            }
        }
        .foregroundColor(viewModel.returnSystemColor())
    }
    
    private func choose(card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lasScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    @State private var lasScoreChange = (0, causedByCardId: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lasScoreChange
        return card.id == id ? amount : 0
    }
    
    private var titleGame: some View {
        return Text("Memorize!!")
            .font(.largeTitle)
    }
    
    private var themeView: some View {
        Text("Theme: \(viewModel.theme.name)")
            .font(.largeTitle)
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .font(.largeTitle)
            .animation(nil)
    }
    
    private var NewGameButton: some View {
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

struct MemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(viewModel: EmojiMemoryGame())
    }
}
