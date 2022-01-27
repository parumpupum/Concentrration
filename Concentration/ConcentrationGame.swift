//
//  ConcentrationGame.swift
//  Concentration
//
//  Created by Kirill Hobyan on 21.09.21.
//

import Foundation
import UIKit

class ConcentrationGame{
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int){
        if !cards[index].isMatched{
            if let matchingIndex = indexOfOneAndOnlyFaceUpCard, matchingIndex != index{
                if cards[matchingIndex] == cards[index]{
                    cards[matchingIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    func countOfCards(of: [Card]) -> Int{
        var count = 0
        for card in cards{
            if card.isMatched == false { count += 1 }
        }
        return count
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "ConcentrationGame.init(\(numberOfPairsOfCards): must have at least one pair of cards)")
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
        }
        var shuffledCards = [Card]()
        while (cards.count != 0){
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            shuffledCards.append(cards.remove(at: randomIndex))
        }
        cards = shuffledCards
    }
    
}

extension Collection {
    
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
    
}
