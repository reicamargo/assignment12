//
//  MemoryGame.swift
//  Assignment12
//
//  Created by Reinaldo Camargo on 12/03/24.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private (set) var score = 0
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { index in cards[index].isFaceUp}.only
        }
        set {
            cards.indices.forEach {
                cards[$0].isFaceUp = (newValue == $0)
            }
        }
    }
    
    init(numberOfPairOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<max(2,numberOfPairOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex)a"))
            cards.append(Card(content: content, id: "\(pairIndex)b"))
        }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(of: card) {
            if !cards[chosenIndex].isFaceUp || !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2
                    } else {
                        //not a match
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        
                        if cards[potentialMatchIndex].hasBeenSeen {
                            score -= 1
                        }
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Identifiable, Equatable {
        var isFaceUp = false {
            didSet {
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        var isMatched = false
        var hasBeenSeen = false
        let content: CardContent
        var id: String
    }
}

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
