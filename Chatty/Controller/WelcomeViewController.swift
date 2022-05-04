//
//  ViewController.swift
//  Chatty
//
//  Created by Spiky WU7 on 26.04.2022.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //String names from "Constants.swift"
        titleLabel.text = K.appName

    }


}











//        titleLabel.text = ""
//        var characterIndex = 0
//        let titleText = "💬CHATTY💭"
//        for letter in titleText {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(characterIndex), repeats: false) { (timer) in
//                self.titleLabel.text?.append(letter)
//            }
//            characterIndex += 1
//        }
