//
//  ViewController.swift
//  Concentration
//
//  Created by Murad Kasim (mkasim@uni-sofia.bg) on 05/06/2018.
//  Copyright © 2018 company. All rights reserved.
//

import UIKit

// CONTROLLER
class ViewController: UIViewController
{
    //================================================
    // Linking [Controller] => [Model]
    //================================================
    //var game: Concentration = Concentration()
    
    // With [type inference]
    //lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    // CUSTOM: Fix for Swift 3, since the behavior of [lazy] in Swift 4 is different
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // Property: COMPUTED - READ-ONLY (because it does not have a [set])
    var numberOfPairsOfCards: Int
    {
        get
        {
            return (cardButtons.count + 1) / 2
        }
    }
    // Property: COMPUTED - READ-ONLY: Shorthand
    // var numberOfPairsOfCards: Int {
    //    return (cardButtons.count + 1) / 2
    //}
    
    // Variable definition, explicit
    // var flipCount: Int = 0
    
    // Variable definition, using [type inference]
    private(set) var flipCount = 0
    {
        
        // Property observer: It's executed everytime [flipCount] is changed
        didSet
        {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    
    // ==========================================================
    // VARIABLES
    // [full syntax]
    // var emojiChoices: Array<String> = ["🐸","🎃","👻","🦄"]
    // [type inference syntax]
    //var emojiChoices = ["🐸","🎃","👻","🦄"]
    
    // MARK: This is a very important message!
    // FIXME: There is crash bug here!
    // TODO: I will finish this later!    
    @IBAction func touchCard(_ sender: UIButton)
    {
        //flipCard(withEmoji: "🐸", on: sender)
        
        flipCount += 1
        
        if let cardNumber = cardButtons.index(of: sender)
        {
            //flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
            game.chooseCard(at: cardNumber)
            
            updateViewFromModel()
            
            print("Card: \(cardNumber)")
        }
        else
        {
            print("ERROR: Card was not found!")
        }
    }
    
    // Lecture 1: Introduction
    /*
    func flipCard( withEmoji emoji: String, on button: UIButton )
    {
        // DEBUG
        print("Emoji is: \(emoji)")
        print("Flip count: \(flipCount)")
        
        // Check button's title
        if button.currentTitle == emoji
        {
            // Change the title
            button.setTitle("", for: UIControlState())
            button.backgroundColor = UIColor.orange
            // button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) // color literal
        }
        else
        {
            button.setTitle(emoji, for: UIControlState())
            button.backgroundColor = UIColor.white
        }
    }
    */
    
    // Lesson 2: MVC
    private func updateViewFromModel()
    {
        print("Flip count: \(flipCount)")
        
        // Classic
        // for index in 0..< cardButtons.count
        
        // Alternative
        for index in cardButtons.indices
        {
            let button = cardButtons[index]
            let card   = game.cards[index]
            
            if card.isFaceUp
            {
                // DEBUG
                print("Card fase is up!")
                button.setTitle(emoji (for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            else
            {
                // DEBUG
                print("Card fase is down!")
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0) : #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            }
        }
    }
    
    // Create emtpy dictionary: Alternative
    // var emoji = [Int:String]()
    private var emoji = Dictionary<Int, String>()
    private var emojiChoices = ["🐸","🎃","👻","🦄","🐠","🍄","🍇","🍭"]
    
    private func emoji(for card: Card) -> String
    {
        // [!] - Dictionary returns an [optional]
        // let chosenEmoji = emoji[card.identifier]
        
        // [optionals]: how to check them
        if emoji[card.identifier] == nil, emojiChoices.count > 0
        {
            // We use EXTENSION to add a new method to INT (method: arc4random)
            let randomIndex = emojiChoices.count.arc4random
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
            
        }
        
        return emoji[card.identifier] ?? "?"
    }
    
}

// EXTENSTION
extension Int
{
    var arc4random: Int
    {
        if self > 0
        {
            return Int( arc4random_uniform( UInt32(self) ) )
        }
        else if self < 0
        {
            return Int( arc4random_uniform ( UInt32( abs(self) ) ) )
        }
        else
        {
            return 0
        }
    }
}
 
