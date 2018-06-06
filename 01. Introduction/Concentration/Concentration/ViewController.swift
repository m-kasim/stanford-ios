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

    @IBAction func touchCard(sender: UIButton) {
        print("Hello, Apple!")
        flipCard(withEmoji: "🐸", on: sender)
    }
    
    func flipCard( withEmoji emoji: String, on button: UIButton )
    {
        // Check button's title
        if button.currentTitle == emoji
        {
            // Change the title
            button.setTitle("", forState: UIControlState.Normal)
            button.backgroundColor = UIColor.orangeColor()
        }
        else
        {
            button.setTitle(emoji, forState: UIControlState.Normal)
            button.backgroundColor = UIColor.whiteColor()
        }
    }
}

