//
//  EmojiMemoryGame.swift
//  Assignment12
//
//  Created by Reinaldo Camargo on 12/03/24.
//

import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    private static var themes: [Theme] = [
        Theme(name: "Halloween", emojis: ["👻", "💩", "☠️", "👹","👁"], numberOfPairs: 5, color: "yellow"),
        Theme(name: "Feelings", emojis: ["😊","😂","😭","🤬","🥰"], numberOfPairs: 6, color: "red"),
        Theme(name: "Sickness", emojis: ["🤢","🤮","🤧","😷","🤒","🤕"], numberOfPairs: 7, color: "blue"),
        Theme(name: "Fruits", emojis: ["🍎","🍌","🥥","🍍"], numberOfPairs: 4, color: "orange"),
        Theme(name: "Weather", emojis: ["☀️","🌤","☁️","⛈"], numberOfPairs: 4, color: "pink"),
        Theme(name: "Food", emojis: ["🍤","🍕","🍜","🍣"], numberOfPairs: 4, color: "black")
    ]
    
    init() {
        theme = EmojiMemoryGame.themes.randomElement()!
        //theme.emojis.shuffle()
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
        model.shuffle()
    }
    
    private (set) var theme: Theme
    
    @Published private var model: MemoryGame<String>
    
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairOfCards: theme.numberOfPairs) { pairIndex in
            if (theme.emojis.indices.contains(pairIndex)) {
                return theme.emojis[pairIndex]
            } else {
                return theme.emojis[Int.random(in: 0..<theme.emojis.count)]
            }
            
        }
    }
    
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame() {
        theme = EmojiMemoryGame.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
        model.shuffle()
    }
    
    var score: Int {
        return model.score
    }
    
    func returnSystemColor() -> Color {
        switch (theme.color) {
            case "yellow": return .yellow
            case "blue": return .blue
            case "red": return .red
            case "pink": return .pink
            case "orange": return .orange
            case "black": return .black
            default: return .white
        }
    }
}
