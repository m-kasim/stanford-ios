//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Developer on 13/08/2018.
//  Copyright © 2018 company. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    // Delegate
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    // CUSTOM:          "I'm adapting to the fact I'm a SplitViewController for iPhone and I want to collapse on the Detail page using a NavigationController. Should I do it?"
    // return true:     "Don't do it"
    // return false:    "I did not collapse this, so you do it!"
    func splitViewController(_ splitViewController: UISplitViewController,
                               collapseSecondary secondaryViewController: UIViewController,
                               onto primaryViewController: UIViewController) -> Bool
    {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        
        return false
    }
    
    // Themes
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓🏸🥊🥋",
        "Animals": "🐶🐱🐭🐹🐰🦊🐻🐼🐷🐸🐧🐣",
        "Faces": "😃😍😎🤪😜😫😡😰🤢🤩😘😌",
    ]
    
    // Button: Sports
    @IBAction func changeTheme(_ sender: Any)
    {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        }
            
        else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }
            
        else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    // [!]: iPad only: Only iPads have SplitViewController
    private var splitViewDetailConcentrationViewController:ConcentrationViewController? {
            return splitViewController?.viewControllers.last as? ConcentrationViewController
    }

    // Strong pointer
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "Choose Theme" {
            
            // Long way:
//            // Check: Make sure that the type of the [sender] is [UIButton]
//            if let button = sender as? UIButton {
//
//                // Check: If a [button] has been created with that title
//                if let themeName = button.currentTitle {
//
//                    // Check: If the title of the [sender] button matches a title in our themes dictionary
//                    if themeName == themes[themeName] {
//
//                    }
//                }
//            }
          

            
            // Short way:
            if let themeName = (sender as? UIButton)?.currentTitle,
                let theme = themes[themeName] {
                
                // Case: Successful segue
                // [!]: Typecast from superclass [UIViewController] to child: [ConcentrationViewController]
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
                
            
        }
    }
 

}
