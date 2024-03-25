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
                    CardView(card)
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

struct MemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(viewModel: EmojiMemoryGame())
    }
}
