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
    private var cardsPreviouslySeenIds: [String]
    
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
        cardsPreviouslySeenIds = []
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
                        setScore(points: 2)
                    } else {
                        //not a match
                        isCardAlreadySeen(chosenCardId: cards[chosenIndex].id)
                        isCardAlreadySeen(chosenCardId: cards[potentialMatchIndex].id)
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
    
    mutating func isCardAlreadySeen(chosenCardId: String) {
        if !cardsPreviouslySeenIds.contains(chosenCardId) {
            cardsPreviouslySeenIds.append(chosenCardId)
        } else {
            setScore(points: -1)
        }
    }
    
    mutating func addCardAlreadySeen(chosenCardId: String) {
        if !cardsPreviouslySeenIds.contains(chosenCardId) {
            cardsPreviouslySeenIds.append(chosenCardId)
        }
    }
    
    mutating func setScore(points: Int) {
        score += points
    }
    
    struct Card: Identifiable, Equatable {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        var id: String
    }
}

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
