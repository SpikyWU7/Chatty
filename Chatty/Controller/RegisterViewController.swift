//
//  RegisterViewController.swift
//  Chatty
//
//  Created by Spiky WU7 on 27.04.2022.
//

import Foundation
import UIKit
import Firebase


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        // Firebase method for registration
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    //Navigate to the chat VC usind segue
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
                
            }
        }
    }
    
    
}
