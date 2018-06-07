//
//  ViewController.swift
//  Concentration
//
//  Created by Murad Kasim (mkasim@uni-sofia.bg) on 05/06/2018.
//  Copyright © 2018 company. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // Variable definition, explicit
    // var flipCount: Int = 0
    
    // Variable definition, using [type inference]
    var flipCount = 0 {
        
        // Property observer: It's executed everytime [flipCount] is changed
        didSet
        {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    // [full syntax]
    // var emojiChoices: Array<String> = ["🐸","🎃","👻","🦄"]
    // [type inference syntax]
    var emojiChoices = ["🐸","🎃","👻","🦄"]
    
    @IBAction func touchCard(_ sender: UIButton)
    {
        //flipCard(withEmoji: "🐸", on: sender)
        
        flipCount += 1
        
        if let cardNumber = cardButtons.index(of: sender)
        {
            flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
            
            print("Card: \(cardNumber)")
        }
        else
        {
            print("ERROR: Card was not found!")
        }
    }
    
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
}

