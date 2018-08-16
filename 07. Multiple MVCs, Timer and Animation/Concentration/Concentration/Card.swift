//
//  Card.swift
//  Concentration
//
//  Created by Developer on 20/06/2018.
//  Copyright © 2018 company. All rights reserved.
//

import Foundation

// Difference between [struct] and [class] in iOS:
// [struct] - no inheritance
// [struct] - they are value types
// [class]  - they are reference types

// MODEL
struct Card : Hashable
{
    // [PROTOCOL]: Hashable
    var hashValue: Int {
        return identifier
    }
    
    // [PROTOCOL]: Equitable
    static func == (lhs: Card, rhs: Card) -> Bool {
        return { lhs.identifier == rhs.identifier }()
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() ->Int
    {
        identifierFactory += 1
        return identifierFactory
    }
    
    // [init] usually has the same [internal] and [external] name for arguments
    init ()
    {
        self.identifier = Card.getUniqueIdentifier()
    }
}
