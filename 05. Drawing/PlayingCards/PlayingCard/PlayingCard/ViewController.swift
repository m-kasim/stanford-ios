//
//  ViewController.swift
//  PlayingCard
//
//  Created by Developer on 18/07/2018.
//  Copyright © 2018 development. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad()
    {
        super.viewDidLoad()

        var deck = PlayingCardDeck()
        
        for _ in 1...10
        {
            if let card = deck.draw()
            {
               print("\(card)")
            }
        }
    }

}

