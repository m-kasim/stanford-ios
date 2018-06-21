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
struct Card
{
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() ->Int
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
