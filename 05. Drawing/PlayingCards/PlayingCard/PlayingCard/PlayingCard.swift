//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Developer on 18/07/2018.
//  Copyright © 2018 development. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible
{
    var suit: Suit
    var rank: Rank
    var description: String
    {
        return  "\(rank)\(suit)"
    }
    
    enum Suit: String, CustomStringConvertible
    {
        case spades = "♠️"
        case diamonds = "♦️"
        case hearts = "♥️"
        case clubs = "♣️"
        
        static var all = [Suit.spades, Suit.hearts, Suit.diamonds, Suit.clubs]
    }
    
    enum Rank: CustomStringConvertible
    {
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int
        {
            switch self
            {
                case Rank.ace:
                    return 1
                case Rank.numeric(let pips):
                    return pips
                case .face(let kind) where kind == "J"
                    return 11
                case .face(let kind) where kind == "Q"
                    return 12
                case .face(let kind) where kind == "K"
                    return 13
                default:
                    return 0
            }
        }

        static var all: [Rank]
        {
            var allRanks: [Rank] = [Rank.ace]
            
            for pips in 2...10
            {
                allRanks.append(Rank.numeric(pips)
            }
            
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            
            return allRanks
        }
    }
}
