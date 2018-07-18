//
//  ConcentrationModel.swift
//  Concentration
//
//  reated by Murad Kasim (mkasim@uni-sofia.bg) on 20/06/2018.
//  Copyright © 2018 company. All rights reserved.
//

import Foundation
import GameplayKit.GKRandomSource // Shuffle array

// Public API
struct Concentration
{
    // Create an instance of [class]/[struct]
    //var cards = Array<Card>()
    
    // Create an instance of [class]/[struct]
    // Alternative declaration:
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int?
    {
        get
        {
            // TEST
            let ch = "Hello".oneAndOnly // return: nil
            let zh = "H".oneAndOnly     // return: "H"
            
            // MARK: Closure
            return cards.indices.filter( { cards[$0].isFaceUp } ).oneAndOnly
            
//            var foundIndex: Int?
//            
//            for index in cards.indices
//            {
//                if cards[index].isFaceUp
//                {
//                    if foundIndex == nil
//                    {
//                        foundIndex = index
//                    }
//                    else
//                    {
//                        return nil
//                    }
//                }
//            }
//
//            return foundIndex
        }
        set(newValue)
        {
            for index in cards.indices
            {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    // MUTATING for the STRUCT
    mutating func chooseCard(at index: Int)
    {
        // ASSERTION
        assert(cards.indices.contains(index), "ASSERT FAILED: Concentration.chooseCard(at: \(index)): chosen index not in cards!")
        
        // DEBUG
        print("Index: \(index)")
        print("All cards indexes: \(cards)")
        
        if !cards[index].isMatched
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard,
                   matchIndex != index
            {
                // check if cards match
                if cards[matchIndex] == cards[index]
                {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                
                cards[index].isFaceUp = true
            }
            else
            {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
     
    // Init/Constructor
    init(numberOfPairsOfCards: Int)
    {
        // ASSERTION
        assert(numberOfPairsOfCards > 0, "ASSERT FAILED: Concentration.init(at: \(numberOfPairsOfCards)): numberOfPairsOfCards is less than 0!")
        
        for _ in 1...numberOfPairsOfCards
        {
            // let card = Card(identifier: identifier)
            // let matchingCard = card
        
            let card = Card()
            
            // [struct] is COPIED when it is passed
            //cards.append(card) // <- first  copy of card
            //cards.append(card) // <- second copy of card
            
            // Add arrays together:
            cards += [card, card]

            // DEBUG
            print("Array of cards:")
            NSLog("%@", cards);
            
            // Shuffle the cards
            cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
        }
    }
    
}

extension Collection
{
    var oneAndOnly: Element?
    {
        return count == 1 ? first : nil
    }
}
