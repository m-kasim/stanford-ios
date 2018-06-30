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
    lazy var game = Concentration(numberOfPairsOfCards: 6)

    // Variable definition, explicit
    // var flipCount: Int = 0
    
    // Variable definition, using [type inference]
    var flipCount = 0
    {
        
        // Property observer: It's executed everytime [flipCount] is changed
        didSet
        {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    
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
    func updateViewFromModel()
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
    var emoji = Dictionary<Int, String>()
    var emojiChoices = ["🐸","🎃","👻","🦄","🐠","🍄","🍇","🍭"]
    
    func emoji(for card: Card) -> String
    {
        // [!] - Dictionary returns an [optional]
        // let chosenEmoji = emoji[card.identifier]
        
        // [optionals]: how to check them
        if emoji[card.identifier] == nil, emojiChoices.count > 0
        {
            let randomIndex = Int( arc4random_uniform( UInt32(emojiChoices.count - 1) ) )
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
            
        }
        
        return emoji[card.identifier] ?? "?"
    }      
}

