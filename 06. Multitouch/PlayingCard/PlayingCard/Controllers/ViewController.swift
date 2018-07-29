//
//  ViewController.swift
//  PlayingCard
//
//  Created by Developer on 18/07/2018.
//  Copyright © 2018 development. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    var deck = PlayingCardDeck()

    // Gesture recognizer
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet
        {
            // Gesture: Swipe
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard)) // Define gesture
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe) // Gesture recognizer: Add it to the view
            
            // Gesture: Pinch (this gesture works only on FACE cards (J, Q, K)
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)) ) // // Define gesture
            playingCardView.addGestureRecognizer(pinch) // Gesture recognizer: Add it to the view
        }
    }
    
    // Flip card
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
            case .ended:
                print("[Gesture][flipCard()]")
                playingCardView.isFaceUp = !playingCardView.isFaceUp
            default: break
        }
    }
    
    // Get a random card
    @objc func nextCard()
    {
        let card = deck.draw()
        if card != nil
        {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        /*
        var deck = PlayingCardDeck()
        
        for _ in 1...10
        {
            let card = deck
            if let card = deck.draw()
            {
               print("\(card)")
            }
        }
                */
    }

}

